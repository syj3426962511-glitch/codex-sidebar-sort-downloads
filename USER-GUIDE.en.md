# English buyer guide

## Current release

This guide covers desktop companion 0.3.1 for Windows x64 and 0.3.0 for Mac
Apple Silicon and Intel. Menus, diagnostics and installation documents use English.
Name sorting uses numeric-aware, case-insensitive English comparison.

Windows 0.3.1 fixes the Start menu launcher's restart behavior and reports
startup failures. Mac 0.3.0 adds the ChatGPT 26.1111.71025 interface.
The published compatibility table lists the exact desktop builds used for
installer, startup and signed-in testing. Earlier 0.2.0 signed-in evidence
describes that runtime.

## Included with the purchase

Codex Sidebar Sort supplies an agent workflow for sorting Codex Desktop from
chat. The companion adds sorting to the three-dot menus and saves independent
rules for each project and section. The companion is free under the MIT license.
Purchase the Skill through Agensi at the price displayed on its listing.
[Agensi product page](https://www.agensi.io/skills/codex-sidebar-sort)

Install the desktop companion once on the computer running Codex. The native
installer includes its runtime, enables startup following and configures the
local Codex MCP connection. Load this Skill through Agensi after installation.
Your existing Codex Desktop account supplies the login.

## Computers and compatibility

- Windows x64 uses the registered official Codex Desktop package.
- Apple Silicon Macs use the Apple Silicon companion DMG and official arm64
  ChatGPT Desktop.
- Intel Macs use the Intel companion DMG and official x64 ChatGPT Desktop.
  Select the matching official client at [ChatGPT downloads](https://chatgpt.com/download/).

Downloads include Node.js and its license. Setup copies it into the durable
installation. At startup, the companion discovers the current desktop and
inspects renderer and storage interfaces. Existing content profiles and
structural recipes provide matching strategies. A changed interface can receive
a published adapter when one becomes available. The earlier 0.2.0 release line
has signed-in evidence for Windows 26.1111.2228.0 and macOS 26.1111.21308.

| Desktop | Earlier 0.2.0 acceptance |
| --- | --- |
| Windows 26.1111.2228.0 x64 | Signed-in sorting, complete project/chat membership and restart retention |
| macOS 26.1111.21308 arm64 | Signed-in sorting, complete project/chat membership and restart retention |
| Intel Mac | Packaging and installation, signed-in UI acceptance pending |
| Additional historical interfaces | Source inventory and existing profiles, family inspection and native acceptance in progress |

The historical inventory contains 158 release source records. The compatibility
table records the acceptance stage of each interface family.
[Compatibility and observed coverage](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/blob/main/COMPATIBILITY.en.md)

Your agent needs local stdio MCP support. Connection snippets cover Codex,
Cursor and Claude Desktop. The service controls Codex Desktop's sidebar. The
official MCP SDK is used for connection and tool-call acceptance. Additional
agent-specific checks appear in the release report as they are completed.

## Download

Choose the self-contained installer for your operating system and processor.
Each includes the free companion and its Node.js runtime.

- `Codex-Sidebar-Sort-Windows-x64-Setup.exe`
- `Codex-Sidebar-Sort-Mac-Apple-Silicon.dmg`
- `Codex-Sidebar-Sort-Mac-Intel.dmg`

[Windows x64 0.3.1 EXE](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/releases/download/v0.3.1/Codex-Sidebar-Sort-Windows-x64-Setup.exe)
[Mac Apple Silicon 0.3.0 DMG](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/releases/download/v0.3.0/Codex-Sidebar-Sort-Mac-Apple-Silicon.dmg)
[Mac Intel 0.3.0 DMG](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/releases/download/v0.3.0/Codex-Sidebar-Sort-Mac-Intel.dmg)

Read the release notes for your installer. [Windows 0.3.1](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/releases/tag/v0.3.1) · [macOS 0.3.0](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/releases/tag/v0.3.0)

Use the compatibility information on the release page to check your desktop
build before installing. The source repository is maintained privately. The
download repository supplies the free companion and public setup information.

## Offline transfer to another computer

Each EXE or DMG contains the complete sorting companion, Node.js and licenses.
The installer runs without downloading Python, Node.js or companion libraries.

1. Select the EXE or DMG matching the receiving computer's operating system and
   processor. Check its Codex Desktop build against the acceptance table above.
2. Copy that installer by USB drive, local network or file transfer.
3. Run the Windows EXE, or open the matching Mac DMG and its installation app.
4. Save work, fully quit Codex and reopen it. Check the three-dot sorting menu.
5. The native installer configures the local Codex MCP service. Load the paid
   Skill through Agensi for chat commands. The receiving computer uses its own
   Codex account. Cursor and Claude Desktop use the optional connection steps below.

The sorting installer reads its runtime dependencies from the local package.
Codex sign-in, cloud conversations and Agensi services use their normal network
connections. Removal uses Windows Installed apps or the installed Mac uninstaller.

## Windows installation

1. Open `Codex-Sidebar-Sort-Windows-x64-Setup.exe`.
2. Choose a dedicated folder for a first installation. When upgrading Codex
   Sidebar Sort under the same Windows account, run Setup over the existing
   installation. Setup selects its existing folder and preserves its configuration.
3. Setup discovers the registered desktop app and configures its shortcut,
   current-user startup service and local Codex MCP connection.
4. Save work, fully quit Codex and reopen it. An explicit restart option is
   available on the final installer page.
5. Open a project's three-dot menu and look for `Sort chats by`.

Normal starts are detected using the registered app's actual executable path.
The default new installation is `Programs\Codex Sidebar Sort` inside your
local application-data folder. An existing portable installation is recognized
and upgraded at its current location. Retain the exact path shown by Setup.
The similarly named Codex Sidebar Sorter is a separate product with its own
installation and startup service.

Remove it from Windows Installed apps or the Start menu's Codex Sidebar Sort
uninstall entry. The older portable ZIP remains available for advanced use.

## macOS installation

1. Open the DMG for your Mac processor, then open `Install Codex Sidebar Sort.app`.
2. Choose the installation folder and confirm the actual Codex/ChatGPT app.
3. Select Install. Setup copies Node.js into the installation, enables its
   current-user LaunchAgent and configures the local Codex MCP connection.
4. Save work and reopen Codex. The installer offers an explicit Restart Codex
   button. Eject the disk image after installation.
5. Open a project's menu to use sorting. Removal uses the installed
   `Uninstall Codex Sidebar Sort.app`.

The default installation is `~/Library/Application Support/CodexProjectChatSort`.
Upgrades use the current location. The community installers have no commercial
Windows signing certificate or Apple Developer ID notarization. Downloaded
software may require the operating system's approval. Managed computers follow
their administrator's software policy.

## Connect Agensi

Add the following remote MCP URL in your agent's MCP connection settings and
complete Agensi's browser sign-in with the account that owns this Skill.

```text
https://mcp.agensi.io/mcp/auth
```

In the agent, ask to load `codex-sidebar-sort`. Agensi delivers SKILL.md and its
references while the agent uses it. Agensi allows one connected agent per
account, so authorizing a different agent replaces the previous connection.
[Agensi connection guide](https://www.agensi.io/docs/mcp-server)

## Connect the local companion

The native EXE and DMG installers configure this connection automatically for
Codex. The following steps are for another MCP-capable agent or for an existing
manually edited connection that the installer preserved. Such an installation
also writes `MCP-connection.toml` with the correct installed paths.

Use the installed Node and `runtime/bin/companion-mcp.mjs`, passing the installed
folder after `--root`. The command prints the exact snippet for your paths.

Windows PowerShell, substituting the actual installation path

```powershell
$sortRoot = 'D:\Tools\CodexProjectChatSort'
$sortConfig = Get-Content -LiteralPath "$sortRoot\config.json" -Raw | ConvertFrom-Json
& $sortConfig.nodePath "$sortRoot\runtime\bin\companion-mcp.mjs" --root $sortRoot --print-config codex
```

macOS Terminal

```bash
sort_root="$HOME/Library/Application Support/CodexProjectChatSort"
"$sort_root/node/node" "$sort_root/runtime/bin/companion-mcp.mjs" --root "$sort_root" --print-config codex
```

Use `--print-config cursor` or `--print-config claude` for those agents.
Generated snippets quote paths containing spaces and non-English characters.

For Codex, add the generated `[mcp_servers.codex_sidebar_sort]` section to the
configuration used by your agent. For Cursor or Claude Desktop, merge the
generated `codex_sidebar_sort` entry into its existing `mcpServers` object.
Retain the other server entries. Save and reconnect the agent's MCP connection.

An agent with an MCP form can use the generated command and argument array for
a local stdio server. Use installed paths so removal of the extracted download
folder leaves the service available.

Keep both connections available. Agensi supplies the Skill instructions, and
the local companion operates the Codex Desktop sidebar on your computer.

## Access check

Ask the agent to check this Skill's connection. It should discover five tools.
`sidebar_status` reports `ready` as `true` when the signed-in desktop sidebar is
ready. `sidebar_list_scopes` lists Projects, Recents, Pinned, custom sections
and individual projects.

If tools are missing, reconnect the MCP entry. If readiness is false, open the
installed desktop, sign in and wait for the sidebar before checking again.

## Requests to copy

- Sort the chats in my Research project by name, ascending.
- Sort the project list by creation date, newest first.
- Sort Recents by most recently updated first.
- Sort Pinned by name, descending.
- Sort my Writing section by creation date, oldest first.
- Keep this project's current sequence as a manual order.
- Put these chats in this exact order, keeping every chat in the project.
- Restore the app's default sorting for Recents.

Select the exact scope if several projects share a name. A project-header rule
and that project's chat rule have independent settings.

## Menu controls

Open a project or section's three-dot menu and its sorting submenu. Choose
Recently updated, Date created, Name or Manual. Automatic modes offer Ascending
and Descending. `Adjust manual order…` opens the editor. Drag rows or use Move
up / Move down, then Save.

Names use numeric-aware, case-insensitive `en` comparison, so `Project 2`
precedes `Project 10`. Equal values use stable IDs. Missing dates stay last.
Date modes become available when native metadata supplies timestamps. Manual
orders append new items in oldest-created-first order.

## Restarts and desktop updates

Preferences are saved separately by account and scope. Project rules also retain
their source, host and project ID. The renderer watcher reconnects after a
supported renderer reload. Startup following detects a normal app start and
connects the matching companion, which can reopen that newly started desktop
with the required local connection enabled.

The next launch discovers the registered Windows package or Mac app bundle.
A newly released renderer needs a matching companion update. Install that
release into the same folder, fully quit and reopen Codex, then reconnect MCP.

The app keeps project membership and history. Sorting preferences use separate
per-scope records. Preserve the desktop profile when moving computers or
restoring a backup.

## Troubleshooting

| Observed result | Next step |
| --- | --- |
| Five tools are absent | Reconnect MCP and check its installed paths. |
| Service asks you to open Codex | Start the installed desktop and wait for its sidebar. |
| Build mismatch | Update the companion, fully quit and reopen Codex, then reconnect MCP. |
| Unsupported new renderer | Install its matching companion release when available. |
| Duplicate project names | Select the exact scope from the current inventory. |
| Manual membership changed | Read the complete scope and include every current ID once. |
| Date action unavailable | Wait for metadata or select Name or Manual. |
| Startup service needs attention | Read `startup-state.json` and `watcher-state.json`. |

### Version and startup diagnosis

If Windows shows **Sorting did not start**, run the read-only diagnostics on
the affected computer. The report identifies the installed desktop package,
companion, startup service and most recent activation result.
[Windows startup diagnostics](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/releases/download/v0.3.1/Codex-Sidebar-Sort-Diagnostics.cmd)

Record the actual desktop version, companion version and operating-system
architecture. Read `state.json`, `startup-state.json` and `watcher-state.json`
from the companion installation folder when available. A healthy renderer
watcher reports `ready`, the current client process and the selected payload
build. The agent's `sidebar_status` then checks the signed-in native connection.

Newer updater installations may also provide `compatibility-state.json`,
`Compatibility.html` and `runtime-health.json`. They record update checks,
selected interface contents, activation outcomes and local recovery. Read the
fields present in that installed version and preserve their actual messages.

### Recovery for the released companion

1. Save work and fully quit Codex. Keep the desktop profile and companion
   configuration available throughout recovery.
2. Open the official installed Codex entry to check its normal startup. An
   unfamiliar renderer requires its matching accepted adapter or release.
3. Install a matching released companion into the same companion folder,
   then reopen Codex and reconnect the local MCP service.
4. Call `sidebar_status` and `sidebar_list_scopes`. Read complete scope pages
   and compare the exact project/chat IDs and saved sorting rules.
5. Use `Restore app default sorting` when the requested recovery includes
   clearing a particular scope's override.

### Startup updater development status

The 0.3.0 release requests the online adapter catalog at each start. Its
implementation stages matching downloads, checks their integrity and JavaScript
syntax, and preflights the installed interface. Startup activation recovery
records the client process, selected build and renderer/storage signature. It
can try a compatible local runtime, with at most two activation attempts, and
reloads the native renderer after failed recovery.

The candidate adds component-updater, launcher and startup-monitor replacement,
MCP runtime refresh, four legacy structural rule sets and one current native
rule set. The native structural candidate covers thirteen required interfaces
and twenty-two sorting integration points. Lexical signatures preserve renamed
variables, parameter expressions and shadowed bindings.

Read the platform receipts on the release page. They cover the final installer,
upgrade, bundled runtime, startup registration, MCP setup and uninstall.
The launch checks use a signed-out desktop and record the renderer readiness
marker after exit and reopen. Signed-in sorting and settings retention use a
separate test account. Automatic repair and recovery have isolated regression
coverage. The published repair catalog is empty pending live acceptance.

Current downloads supply Windows companion 0.3.1 and Mac companion 0.3.0.
Existing 0.2.0 customers install their platform package once to receive
its startup updater.
The accepted-adapter catalog currently contains zero repair packs. Node.js
interpreter upgrades, in-session recovery, broader historical native acceptance
and continuous official-build monitoring retain development work.

[Startup update architecture](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/blob/main/MULTIVERSION_COMPATIBILITY.en.md)


## Removal

For the native EXE installation, use Windows Installed apps or the Start menu
uninstall entry. For the native DMG installation, open the installed
`Uninstall Codex Sidebar Sort.app`. These remove the owned runtime, startup
service and automatically configured local Codex MCP entry. Other agent
connections that you added manually can be removed in that agent.

Older portable ZIP setups use `Uninstall.cmd` on Windows or
`Uninstall-mac.command` on macOS to restore their launch entries. Their runtime
files and manually configured MCP entries are retained for review.

Use `Restore app default sorting` for each override you want to clear. Retain
the companion configuration until any desired restore steps are complete.

## Support

Include your OS, desktop version, companion release, affected scope, actual
error and relevant state-file messages. Review screenshots for personal data
before sharing them.

[Companion downloads and support](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads)

