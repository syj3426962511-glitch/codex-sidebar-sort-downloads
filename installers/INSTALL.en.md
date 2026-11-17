# Codex Sidebar Sort desktop installer

Install once on the computer that runs Codex Desktop. Node.js and all companion
libraries are included. No Python, terminal commands or separate runtime setup
is required. You use your existing Codex sign-in; authentication files and API
keys are never included in the installer.

## Windows x64

1. Open `Codex-Sidebar-Sort-Windows-x64-Setup.exe`.
2. Select a dedicated installation folder and select Install. An existing
   companion installation is upgraded at its current location.
3. Close and reopen Codex. Alternatively, save work and select the final-page
   option to reopen Codex with sorting.

The installer sets up the current-user startup service and local Codex MCP
connection. It adds a Start menu entry and an uninstall entry in Windows
Installed apps. Removing it restores its owned desktop shortcut and removes
its startup service. Native projects, chat membership and Codex authentication
stay in the client.

## Mac Apple Silicon or Intel

1. Open the DMG for your Mac processor.
2. Open `Install Codex Sidebar Sort.app` inside the disk image.
3. Select your installation folder, confirm the Codex app and select Install.
4. Close and reopen Codex. The installer offers an explicit restart button.

The installer copies its Node.js runtime into the chosen folder, installs a
current-user LaunchAgent and connects the local Codex MCP service. You can
eject the disk image after installation. Open the installed
`Uninstall Codex Sidebar Sort.app` to remove the companion.

These community installers are not signed with a commercial Windows signing
certificate or Apple Developer ID. If your device policy requires signed or
notarized software, ask its administrator to review the package. macOS may
require Finder's Open action or Privacy & Security approval for a downloaded
community app.

## Sorting and updates

Open a supported sidebar three-dot menu, then Sort by. Choose Recently updated,
Date created, Name or Manual. Each project and sidebar scope saves a separate
rule. In chat, load the Agensi Skill after the local companion is installed.

Startup discovers the installed Codex app and checks the published adapter
catalog. Matching accepted repairs are downloaded and activated with local
recovery. Existing compatible files remain available if a network check fails.
New interface families require adaptation and native acceptance before their
repairs appear in the catalog. See the actual compatibility status in the
installation folder. Current-release authenticated sorting and complete
restart acceptance are tracked separately from installer lifecycle checks.

If an existing `codex_sidebar_sort` MCP connection was edited manually, the
installer preserves it and writes `MCP-connection.toml` for review. Sidebar
menus operate independently of that chat connection.

## Transfer to another computer

Copy the EXE or matching DMG to the other computer and run it there. It contains
the complete companion and runtime; the install itself needs no dependency
downloads. Codex Desktop must already be installed. Internet access is used
for Codex sign-in and for published repair checks. The paid Agensi Skill is
delivered through Agensi, separately from the free desktop companion.
