param([switch]$PreviewOnly,[string]$PreviousInstaller)
$ErrorActionPreference='Stop'
if($env:GITHUB_ACTIONS -ne 'true'){throw 'Use an independent cloud Windows desktop.'}
$output=Join-Path $PWD 'dist'
$installer=Join-Path $output 'Codex-Sidebar-Sort-Windows-x64-Setup.exe'
$root=Join-Path $env:RUNNER_TEMP 'Installer acceptance\Codex Sidebar Sort'
$evidence=Join-Path $output 'evidence'
New-Item -ItemType Directory -Path $evidence -Force|Out-Null
Add-Type -AssemblyName System.Windows.Forms,System.Drawing
function Save-Screenshot([string]$Name){
  $bounds=[Windows.Forms.SystemInformation]::VirtualScreen
  $bitmap=New-Object Drawing.Bitmap $bounds.Width,$bounds.Height
  $graphics=[Drawing.Graphics]::FromImage($bitmap)
  try{$graphics.CopyFromScreen($bounds.Location,[Drawing.Point]::Empty,$bounds.Size);$bitmap.Save((Join-Path $evidence $Name),[Drawing.Imaging.ImageFormat]::Png)}
  finally{$graphics.Dispose();$bitmap.Dispose()}
}
$preview=Start-Process -FilePath $installer -PassThru
Start-Sleep -Seconds 3
Save-Screenshot '01-windows-installation-wizard.png'
Stop-Process -Id $preview.Id -Force
if($PreviewOnly){exit 0}
$codex=Join-Path $env:USERPROFILE '.codex'
New-Item -ItemType Directory -Path $codex -Force|Out-Null
$configFile=Join-Path $codex 'config.toml'
$unrelated='[mcp_servers.acceptance_sentinel]'+"`n"+'command = "unrelated-test-service"'+"`n"
Set-Content -LiteralPath $configFile -Value $unrelated -Encoding utf8
$originalShortcut=$null
foreach($name in @('ChatGPT.lnk','Codex.lnk')){
  $shortcut=Join-Path ([Environment]::GetFolderPath('Desktop')) $name
  if(Test-Path -LiteralPath $shortcut){$originalShortcut=Get-FileHash -LiteralPath $shortcut;break}
}
$initialInstaller=if($PreviousInstaller){$PreviousInstaller}else{$installer}
$run=Start-Process -FilePath $initialInstaller -ArgumentList @('/S',('/D='+$root)) -WindowStyle Hidden -PassThru -Wait
if($run.ExitCode -ne 0){throw "The final installer failed with exit code $($run.ExitCode)."}
$manifest=Get-Content -LiteralPath (Join-Path $root 'installer-manifest.json') -Raw|ConvertFrom-Json
$buildReceipt=Get-Content -LiteralPath (Join-Path $output 'win-x64-installer.json') -Raw|ConvertFrom-Json
if(-not $PreviousInstaller -and ($manifest.companionVersion -ne $buildReceipt.companionVersion -or $manifest.installerVersion -ne $buildReceipt.installerVersion)){throw 'Installed version differs from its build receipt.'}
$initialVersion=$manifest.companionVersion
if($PreviousInstaller -and $initialVersion -eq $buildReceipt.companionVersion){throw 'The existing installer did not provide an older release.'}
$config=Get-Content -LiteralPath (Join-Path $root 'config.json') -Raw|ConvertFrom-Json
if(-not $config.nodePath.StartsWith($root+'\')){throw 'The installation depends on an external Node runtime.'}
& $config.nodePath --version
if($LASTEXITCODE -ne 0){throw 'The installed bundled runtime failed.'}
$startup=Get-Content -LiteralPath (Join-Path $root 'startup.json') -Raw|ConvertFrom-Json
$task=Get-ScheduledTask -TaskName $startup.taskName
if($task.State -ne 'Running'){throw 'The installed startup service did not start.'}
$mcp=Get-Content -LiteralPath $configFile -Raw
if(-not $mcp.Contains('mcp_servers.codex_sidebar_sort') -or -not $mcp.Contains('acceptance_sentinel')){throw 'Automatic MCP connection or unrelated-config preservation failed.'}
Set-Content -LiteralPath (Join-Path $root 'user-note.txt') -Value 'Unrelated user file must survive uninstall.'
$config|Add-Member -NotePropertyName installerAcceptanceMarker -NotePropertyValue 'preserve-on-upgrade'
$config|ConvertTo-Json -Depth 20|Set-Content -LiteralPath (Join-Path $root 'config.json') -Encoding UTF8
$run=Start-Process -FilePath $installer -ArgumentList @('/S',('/D='+$root)) -WindowStyle Hidden -PassThru -Wait
if($run.ExitCode -ne 0){throw 'The final installer upgrade failed.'}
$manifest=Get-Content -LiteralPath (Join-Path $root 'installer-manifest.json') -Raw|ConvertFrom-Json
if($manifest.companionVersion -ne $buildReceipt.companionVersion -or $manifest.installerVersion -ne $buildReceipt.installerVersion){throw 'The upgrade did not install the intended version.'}
$config=Get-Content -LiteralPath (Join-Path $root 'config.json') -Raw|ConvertFrom-Json
if($config.installerAcceptanceMarker -ne 'preserve-on-upgrade'){throw 'The upgrade lost installed configuration.'}
Save-Screenshot '02-windows-installed-desktop.png'
$runs=@()
$smokeError=$null
$ownedExe=$null
$manualStart=$null
try{
  . (Join-Path $root 'scripts\Common.ps1')
  $package=Get-CodexPackage
  $ownedExe=$package.Exe
  $processName=[IO.Path]::GetFileName($ownedExe)
  for($cycle=1;$cycle -le 2;$cycle++){
    $started=(Get-Date).ToUniversalTime()
    Start-Process -FilePath (Join-Path $env:SystemRoot 'explorer.exe') -ArgumentList ('shell:AppsFolder\'+$package.Aumid) -WindowStyle Hidden
    $until=(Get-Date).AddSeconds(140)
    $watcher=$null
    do{
      Start-Sleep -Seconds 2
      try{$watcher=Get-Content -LiteralPath (Join-Path $root 'watcher-state.json') -Raw -ErrorAction Stop|ConvertFrom-Json}catch{continue}
      if($watcher.state -eq 'ready' -and [datetime]$watcher.time -gt $started){
        $proc=Get-CimInstance Win32_Process -Filter "ProcessId=$([int]$watcher.appPid)"
        if($proc.ExecutablePath -eq $ownedExe){break}
      }
    }while((Get-Date) -lt $until)
    if($watcher.state -ne 'ready' -or [datetime]$watcher.time -le $started -or $proc.ExecutablePath -ne $ownedExe){throw 'The official desktop did not report candidate renderer readiness on normal startup.'}
    Save-Screenshot ("03-codex-normal-start-{0}.png" -f $cycle)
    $runs+=@{cycle=$cycle;appPid=$watcher.appPid;build=$watcher.build;rendererReady=$true}
    Stop-Process -Id $watcher.appPid
    Wait-Process -Id $watcher.appPid -Timeout 12 -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 7
    $remaining=@(Get-CimInstance Win32_Process -Filter "Name='$processName'"|Where-Object {$_.ExecutablePath -eq $ownedExe -and $_.CommandLine -notmatch '--type='})
    if($remaining.Count){throw 'The companion reopened the deliberately closed desktop.'}
  }
  $startLink=Join-Path ([Environment]::GetFolderPath('Programs')) 'Codex Sidebar Sort\Open Codex with sorting.lnk'
  if(!(Test-Path -LiteralPath $startLink -PathType Leaf)){throw 'The Start menu shortcut was not created.'}
  $configPath=Join-Path $root 'config.json'
  $configBefore=[IO.File]::ReadAllBytes($configPath)
  Stop-ScheduledTask -TaskName $startup.taskName
  try{
    $config.restartExisting=$false
    $config|ConvertTo-Json -Depth 20|Set-Content -LiteralPath $configPath -Encoding UTF8
    Start-Process -FilePath (Join-Path $env:SystemRoot 'explorer.exe') -ArgumentList ('shell:AppsFolder\'+$package.Aumid) -WindowStyle Hidden
    $until=(Get-Date).AddSeconds(45)
    do{
      Start-Sleep -Seconds 1
      $normal=@(Get-CimInstance Win32_Process -Filter "Name='$processName'"|Where-Object {$_.ExecutablePath -eq $ownedExe -and $_.CommandLine -notmatch '--type='})
      if($normal.Count -eq 1){break}
    }while((Get-Date) -lt $until)
    if($normal.Count -ne 1 -or $normal[0].CommandLine -match '--remote-debugging-port='){throw 'The ordinary client did not open before the manual restart test.'}
    $oldProcessId=[int]$normal[0].ProcessId
    $started=(Get-Date).ToUniversalTime()
    Start-Process -FilePath $startLink -WindowStyle Hidden
    $until=(Get-Date).AddSeconds(140)
    do{
      Start-Sleep -Seconds 1
      try{
        $watch=Get-Content -LiteralPath (Join-Path $root 'watcher-state.json') -Raw|ConvertFrom-Json
        $state=Get-Content -LiteralPath (Join-Path $root 'state.json') -Raw|ConvertFrom-Json
      }catch{continue}
      if($watch.state -ne 'ready' -or [datetime]$watch.time -le $started -or $watch.appPid -eq $oldProcessId -or $state.state -ne 'complete' -or $state.processId -ne $watch.appPid){continue}
      $new=Get-CimInstance Win32_Process -Filter "ProcessId=$([int]$watch.appPid)"
      if($new.ExecutablePath -eq $ownedExe -and !(Get-Process -Id $oldProcessId -ErrorAction SilentlyContinue)){
        $manualStart=@{passed=$true;previousProcess=$oldProcessId;appPid=$watch.appPid;build=$watch.build;restartFlagRequired=$true}
        break
      }
    }while((Get-Date) -lt $until)
    if(!$manualStart){throw 'The actual Start menu shortcut did not complete a verified restart.'}
    Save-Screenshot '04-codex-start-menu-restart.png'
    Stop-Process -Id $manualStart.appPid
    Wait-Process -Id $manualStart.appPid -Timeout 12 -ErrorAction SilentlyContinue
  }finally{
    [IO.File]::WriteAllBytes($configPath,$configBefore)
    Start-ScheduledTask -TaskName $startup.taskName
  }
}catch{
  $smokeError=$_.Exception.Message
  if($ownedExe){Get-CimInstance Win32_Process -Filter "Name='$processName'"|Where-Object {$_.ExecutablePath -eq $ownedExe -and $_.CommandLine -notmatch '--type='}|ForEach-Object {Stop-Process -Id $_.ProcessId -ErrorAction SilentlyContinue}}
}
$smoke=@{passed=$runs.Count -eq 2 -and $manualStart.passed -and -not $smokeError;authenticated=$false;cycles=$runs;manualStart=$manualStart;error=$smokeError}
$smoke|ConvertTo-Json -Depth 6|Set-Content -LiteralPath (Join-Path $output 'desktop-smoke.json') -Encoding UTF8
$uninstaller=Join-Path $root 'Uninstall.exe'
$remove=Start-Process -FilePath $uninstaller -ArgumentList '/S' -PassThru -Wait
if($remove.ExitCode -ne 0){throw 'The uninstall entry failed.'}
$until=(Get-Date).AddSeconds(60)
while(Test-Path -LiteralPath (Join-Path $root 'installer-manifest.json')){
  if((Get-Date) -gt $until){throw 'Uninstall did not finish.'};Start-Sleep -Milliseconds 500
}
if(Get-ScheduledTask -TaskName $startup.taskName -ErrorAction SilentlyContinue){throw 'The startup task survived uninstall.'}
$after=Get-Content -LiteralPath $configFile -Raw
if($after.Contains('[mcp_servers.codex_sidebar_sort]') -or -not $after.Contains('acceptance_sentinel')){throw 'Uninstall did not remove only the owned MCP connection.'}
if(-not (Test-Path -LiteralPath (Join-Path $root 'user-note.txt'))){throw 'Uninstall removed an unrelated user file.'}
if($originalShortcut -and (Get-FileHash -LiteralPath $originalShortcut.Path).Hash -ne $originalShortcut.Hash){throw 'The original desktop shortcut was not restored.'}
$receipt=Get-Content -LiteralPath (Join-Path $output 'win-x64-installer.json') -Raw|ConvertFrom-Json
$receipt.nativeInstallerLifecycle='passed'
$receipt|Add-Member -NotePropertyName checks -NotePropertyValue @('normal installer entry','custom folder with spaces','bundled Node execution','startup task running','automatic MCP configuration','unrelated MCP preserved','upgrade configuration retained','normal uninstall entry','startup removed','MCP removed','unrelated user file retained','owned shortcut restored')
$receipt|Add-Member -NotePropertyName initialCompanionVersion -NotePropertyValue $initialVersion
$receipt|ConvertTo-Json -Depth 6|Set-Content -LiteralPath (Join-Path $output 'win-x64-installer.json') -Encoding UTF8
Write-Output ($receipt|ConvertTo-Json -Depth 6)
