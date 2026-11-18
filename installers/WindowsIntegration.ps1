param(
  [ValidateSet('Install','Uninstall')][string]$Mode='Install',
  [Parameter(Mandatory=$true)][string]$ProductDirectory,
  [string]$PayloadRoot
)
$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath($ProductDirectory).TrimEnd('\')
if(-not [IO.Path]::IsPathRooted($ProductDirectory) -or $root -eq [IO.Path]::GetPathRoot($root).TrimEnd('\')){throw 'Choose a dedicated installation folder.'}
$marker=Join-Path $root 'installer-manifest.json'
$powershell=Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'

function Stop-OwnedSortingProcesses {
  if(Test-Path -LiteralPath (Join-Path $root 'config.json')){
    $config=Get-Content -LiteralPath (Join-Path $root 'config.json') -Raw|ConvertFrom-Json
    foreach($process in @(Get-CimInstance Win32_Process -Filter "Name='node.exe'")){
      if($process.ExecutablePath -eq $config.nodePath -and $process.CommandLine -and $process.CommandLine.Contains($root) -and $process.CommandLine -match '[\\/]bin[\\/](watch|companion-mcp)\.mjs(?:"|\s)'){
        Stop-Process -Id $process.ProcessId -Force -ErrorAction Stop
      }
    }
  }
}

if($Mode -eq 'Uninstall'){
  $owned=Get-Content -LiteralPath $marker -Raw|ConvertFrom-Json
  if($owned.product -ne 'Codex Sidebar Sort' -or $owned.root -ne $root){throw 'Installation ownership check failed.'}
  & $powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -File (Join-Path $root 'scripts\Restore.ps1') -InstallDirectory $root
  if($LASTEXITCODE -ne 0){throw 'The original desktop shortcut could not be restored. Files were retained.'}
  Stop-OwnedSortingProcesses
  $config=Get-Content -LiteralPath (Join-Path $root 'config.json') -Raw|ConvertFrom-Json
  & $config.nodePath (Join-Path $root 'installer\mcp-registration.mjs') disconnect $root
  if($LASTEXITCODE -ne 0){throw 'The MCP connection could not be removed. Files were retained.'}
  $directories=@('runtime','scripts','node','adapters','installer')
  $directories+=@(Get-ChildItem -LiteralPath $root -Directory|Where-Object Name -match '^previous-runtime-\d{8}-\d{6}-\d{3}$'|Select-Object -ExpandProperty Name)
  $files=@($owned.files)+@('installer-manifest.json','MCP-connection.toml','mcp-registration.json','startup-state.json','watcher-state.json','state.json','bootstrap-state.json','runtime-health.json','compatibility-state.json','Compatibility.html','adapter-state.json','catalog-cache.json','activation-state.json','Open Codex Sorting.vbs','.update.lock')
  foreach($name in @($directories+$files|Select-Object -Unique)){
    if($name -eq 'Uninstall.exe'){continue}
    $target=[IO.Path]::GetFullPath((Join-Path $root $name))
    if((Split-Path -Parent $target) -ne $root){throw 'Uninstall target is outside the installation folder.'}
    if(Test-Path -LiteralPath $target){Remove-Item -LiteralPath $target -Recurse -Force}
  }
  Write-Output 'Sorting startup, owned runtime and the local MCP connection were removed. Codex projects and chats are retained.'
  exit 0
}

if(-not (Test-Path -LiteralPath (Join-Path $PayloadRoot 'assets\node\node.exe'))){throw 'The bundled Node.js runtime is missing.'}
if(Test-Path -LiteralPath $root){
  $recognized=(Test-Path -LiteralPath (Join-Path $root 'shortcut.json')) -and (Test-Path -LiteralPath (Join-Path $root 'config.json'))
  if(-not $recognized){throw 'Choose a new dedicated installation folder. This folder contains unrelated files.'}
}
if(Test-Path -LiteralPath (Join-Path $root 'startup.json')){Stop-OwnedSortingProcesses}
  & $powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -File (Join-Path $PayloadRoot 'scripts\Setup.ps1') -InstallDirectory $root
  if($LASTEXITCODE -ne 0){throw 'Desktop sorting setup failed. See the installation details.'}
  $config=Get-Content -LiteralPath (Join-Path $root 'config.json') -Raw|ConvertFrom-Json
  if(-not (Test-Path -LiteralPath $config.nodePath)){throw 'Installed Node.js is missing.'}
  $integration=Join-Path $root 'installer'
  New-Item -ItemType Directory -Path $integration -Force|Out-Null
  foreach($file in Get-ChildItem -LiteralPath $PSScriptRoot -File){Copy-Item -LiteralPath $file.FullName -Destination (Join-Path $integration $file.Name) -Force}
  $connection=& $config.nodePath (Join-Path $root 'installer\mcp-registration.mjs') connect $root $config.nodePath
  if($LASTEXITCODE -ne 0){throw 'Automatic MCP configuration failed.'}
  Write-Output (($connection|ConvertFrom-Json).message)
  $startup=Get-Content -LiteralPath (Join-Path $root 'startup.json') -Raw|ConvertFrom-Json
  $task=Get-ScheduledTask -TaskName $startup.taskName
  if($task.State -ne 'Running'){throw 'The startup service is not running.'}
  $files=@('config.json','shortcut.json','shortcut.original.lnk','Codex.ico','Start-Sorting.cmd','MCP-connection.toml','mcp-registration.json')
  $version=(Get-Content -LiteralPath (Join-Path $root 'runtime\package.json') -Raw|ConvertFrom-Json).version
  @{product='Codex Sidebar Sort';root=$root;installerVersion='0.3.1-setup.1';companionVersion=$version;files=$files;time=(Get-Date).ToString('o')}|ConvertTo-Json -Depth 5|Set-Content -LiteralPath $marker -Encoding UTF8
  @'
Set shell = CreateObject("WScript.Shell")
Set files = CreateObject("Scripting.FileSystemObject")
folder = files.GetParentFolderName(WScript.ScriptFullName)
windows = shell.ExpandEnvironmentStrings("%SystemRoot%")
powershell = windows & "\System32\WindowsPowerShell\v1.0\powershell.exe"
native = windows & "\Sysnative\WindowsPowerShell\v1.0\powershell.exe"
If files.FileExists(native) Then powershell = native
quote = Chr(34)
command = quote & powershell & quote & " -NoProfile -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden -File " & quote & folder & "\scripts\Launch.ps1" & quote & " -RestartExisting"
result = shell.Run(command, 0, True)
If result <> 0 Then
  MsgBox "Sorting did not start. See Compatibility.html or state.json in:" & vbCrLf & folder, vbExclamation, "Codex Sidebar Sort"
End If
'@|Set-Content -LiteralPath (Join-Path $root 'Open Codex Sorting.vbs') -Encoding ASCII
  Write-Output 'Installation complete. The bundled runtime and startup service are configured.'
