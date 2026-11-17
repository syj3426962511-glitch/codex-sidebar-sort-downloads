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
$run=Start-Process -FilePath $installer -ArgumentList @('/S',('/D='+$root)) -PassThru -Wait
if($run.ExitCode -ne 0){throw "The final installer failed with exit code $($run.ExitCode)."}
$manifest=Get-Content -LiteralPath (Join-Path $root 'installer-manifest.json') -Raw|ConvertFrom-Json
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
$run=Start-Process -FilePath $installer -ArgumentList @('/S',('/D='+$root)) -PassThru -Wait
if($run.ExitCode -ne 0){throw 'The final installer upgrade failed.'}
$config=Get-Content -LiteralPath (Join-Path $root 'config.json') -Raw|ConvertFrom-Json
if($config.installerAcceptanceMarker -ne 'preserve-on-upgrade'){throw 'The upgrade lost installed configuration.'}
Save-Screenshot '02-windows-installed-desktop.png'
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
$receipt|ConvertTo-Json -Depth 6|Set-Content -LiteralPath (Join-Path $output 'win-x64-installer.json') -Encoding UTF8
Write-Output ($receipt|ConvertTo-Json -Depth 6)
