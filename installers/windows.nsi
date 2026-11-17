Unicode true
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!include "x64.nsh"
!ifndef PAYLOAD
  !error "PAYLOAD must point to the extracted platform package"
!endif
!ifndef OUTPUT
  !define OUTPUT "Codex-Sidebar-Sort-Windows-x64-Setup.exe"
!endif
!define PRODUCT_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\CodexSidebarSort"
Name "Codex Sidebar Sort"
OutFile "${OUTPUT}"
InstallDir "$LOCALAPPDATA\Programs\Codex Sidebar Sort"
InstallDirRegKey HKCU "${PRODUCT_KEY}" "InstallLocation"
RequestExecutionLevel user
SetCompressor /SOLID lzma
SetFont "Times New Roman" 11
VIProductVersion "0.3.0.4"
VIAddVersionKey /LANG=1033 "ProductName" "Codex Sidebar Sort"
VIAddVersionKey /LANG=1033 "FileDescription" "Offline desktop companion installer"
VIAddVersionKey /LANG=1033 "FileVersion" "0.3.0-setup.1"
VIAddVersionKey /LANG=1033 "LegalCopyright" "MIT licensed community companion"
Var ExistingInstall
!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TEXT "Install the free desktop companion, its Node.js runtime and automatic startup service.$\r$\n$\r$\nCodex Desktop must already be installed and signed in. This installer uses your existing projects and chats.$\r$\n$\r$\nSorting starts the next time Codex opens. Save work before selecting the restart option on the final page."
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION StartSorting
!define MUI_FINISHPAGE_RUN_TEXT "Open Codex with sorting (restarts any running Codex)"
!define MUI_FINISHPAGE_RUN_NOTCHECKED
!define MUI_FINISHPAGE_TEXT "Installation completed.$\r$\n$\r$\nOpen Codex normally to use sorting. The startup service follows the registered application and checks for published compatible repairs.$\r$\n$\r$\nYour local MCP connection is configured. Load the purchased Agensi Skill when using sorting from chat."
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${PAYLOAD}\assets\runtime\LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

Function .onInit
  SetShellVarContext current
  ${IfNot} ${RunningX64}
    MessageBox MB_ICONSTOP|MB_OK "Use this installer on Windows x64." /SD IDOK
    Abort
  ${EndIf}
  ReadRegStr $ExistingInstall HKCU "${PRODUCT_KEY}" "InstallLocation"
  ${If} $ExistingInstall == ""
    ReadEnvStr $0 "CODEX_HOME"
    ${If} $0 == ""
      StrCpy $0 "$PROFILE\.codex"
    ${EndIf}
    IfFileExists "$0\addons\codex-project-chat-sort\shortcut.json" 0 +2
      StrCpy $ExistingInstall "$0\addons\codex-project-chat-sort"
  ${EndIf}
  ${If} $ExistingInstall != ""
    StrCpy $INSTDIR $ExistingInstall
  ${EndIf}
FunctionEnd

Function .onVerifyInstDir
  ${If} $ExistingInstall != ""
  ${AndIf} $INSTDIR != $ExistingInstall
    Abort
  ${EndIf}
  StrLen $0 $INSTDIR
  ${If} $0 < 5
    Abort
  ${EndIf}
FunctionEnd

Function StartSorting
  Exec '"$WINDIR\Sysnative\wscript.exe" "$INSTDIR\Open Codex Sorting.vbs"'
FunctionEnd

Section "Desktop companion"
  InitPluginsDir
  SetOutPath "$PLUGINSDIR\payload"
  File /r "${PAYLOAD}"
  SetOutPath "$PLUGINSDIR\integration"
  File "WindowsIntegration.ps1"
  File "mcp-registration.mjs"
  File "INSTALL.en.md"
  nsExec::ExecToLog /TIMEOUT=600000 '"$WINDIR\Sysnative\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "$PLUGINSDIR\integration\WindowsIntegration.ps1" -Mode Install -ProductDirectory "$INSTDIR" -PayloadRoot "$PLUGINSDIR\payload\codex-project-chat-sort"'
  Pop $0
  ${If} $0 != 0
    SetErrorLevel 1
    MessageBox MB_ICONSTOP|MB_OK "Installation failed. Open the details above for the cause. The usual prerequisite is an installed Codex Desktop client." /SD IDOK
    Abort
  ${EndIf}
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKCU "${PRODUCT_KEY}" "DisplayName" "Codex Sidebar Sort"
  WriteRegStr HKCU "${PRODUCT_KEY}" "DisplayVersion" "0.3.0-setup.1"
  WriteRegStr HKCU "${PRODUCT_KEY}" "Publisher" "Codex Sidebar Sort community"
  WriteRegStr HKCU "${PRODUCT_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "${PRODUCT_KEY}" "UninstallString" '$\"$INSTDIR\Uninstall.exe$\"'
  WriteRegStr HKCU "${PRODUCT_KEY}" "QuietUninstallString" '$\"$INSTDIR\Uninstall.exe$\" /S'
  WriteRegDWORD HKCU "${PRODUCT_KEY}" "NoModify" 1
  WriteRegDWORD HKCU "${PRODUCT_KEY}" "NoRepair" 1
  CreateDirectory "$SMPROGRAMS\Codex Sidebar Sort"
  CreateShortcut "$SMPROGRAMS\Codex Sidebar Sort\Open Codex with sorting.lnk" "$SYSDIR\wscript.exe" '$\"$INSTDIR\Open Codex Sorting.vbs$\"'
  CreateShortcut "$SMPROGRAMS\Codex Sidebar Sort\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"
  SetShellVarContext current
  nsExec::ExecToLog /TIMEOUT=120000 '"$WINDIR\Sysnative\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "$INSTDIR\installer\WindowsIntegration.ps1" -Mode Uninstall -ProductDirectory "$INSTDIR"'
  Pop $0
  ${If} $0 != 0
    SetErrorLevel 1
    MessageBox MB_ICONSTOP|MB_OK "Removal stopped. Open the details for the cause. Retained files are in the installation folder." /SD IDOK
    Abort
  ${EndIf}
  Delete "$SMPROGRAMS\Codex Sidebar Sort\Open Codex with sorting.lnk"
  Delete "$SMPROGRAMS\Codex Sidebar Sort\Uninstall.lnk"
  RMDir "$SMPROGRAMS\Codex Sidebar Sort"
  DeleteRegKey HKCU "${PRODUCT_KEY}"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir "$INSTDIR"
SectionEnd
