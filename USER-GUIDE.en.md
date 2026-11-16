# English buyer guide

## Included with the purchase

Codex Sidebar Sort supplies an agent workflow for sorting Codex Desktop from
chat. The companion adds sorting to the three-dot menus and saves independent
rules for each project and section. The companion is free under the MIT license.
Purchase the Skill through Agensi at the price displayed on its listing.
[Agensi product page](https://www.agensi.io/skills/codex-sidebar-sort)

Install the desktop companion once on the computer running Codex, then connect
its local MCP service to your agent. Load this Skill through Agensi after
connecting the service. Your existing Codex Desktop account supplies the login.

## Computers and compatibility

- Windows x64 uses the registered official Codex Desktop package.
- Apple Silicon Macs use the `darwin-arm64` download.
- Intel Macs use the `darwin-x64` download.

Downloads include Node.js and its license. Setup copies it into the durable
installation. The companion checks exact renderer and dependency fingerprints
at startup. Consult the release validation report for tested desktop versions.
Renamed or relocated resources are discovered by verified content. Changes to
the renderer interfaces receive support through a companion update. The current
signed-in acceptance covers Windows 26.1111.2228.0 and macOS 26.1111.21308.

Your agent needs local stdio MCP support. Connection snippets cover Codex,
Cursor and Claude Desktop. The service controls Codex Desktop's sidebar. The
official MCP SDK is used for connection and tool-call acceptance. Additional
agent-specific checks appear in the release report as they are completed.

## Download

Choose the free ZIP matching your computer and extract it before installation.

- `codex-project-chat-sort-win-x64.zip`
- `codex-project-chat-sort-darwin-arm64.zip`
- `codex-project-chat-sort-darwin-x64.zip`

[Free companion releases](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/releases)

Use the compatibility information on the release page to check your desktop
build before installing. The source repository is maintained privately. The
download repository supplies the free companion and public setup information.

## Windows installation

1. Open the extracted `codex-project-chat-sort` folder.
2. Double-click `Install.cmd`.
3. Setup discovers the registered desktop app and its desktop ChatGPT/Codex shortcut, creating a Codex shortcut if needed,
   then copies the companion and bundled runtime into its durable folder.
4. Setup registers a current-user login task for startup following.
5. Save your work, fully quit Codex, and reopen it.
6. Open a project's three-dot menu and look for `Sort chats by`.

Normal starts are detected using the registered app's actual executable path.
The default installation is `addons\codex-project-chat-sort` inside `CODEX_HOME`.
When that variable is unset, Setup uses your user profile's `.codex` folder.
Retain the exact installation path shown by Setup for the MCP connection.

Custom installations use `scripts/Setup.ps1` with `-InstallDirectory` and
`-ShortcutPath`. Update using the same installation path.

## macOS installation

1. Extract the ZIP for your Mac's processor.
2. Open `Install-mac.command`. If macOS asks you to review a downloaded command,
   review the file and use the system's Open action.
3. Setup discovers the official Codex/ChatGPT app bundle.
4. Setup installs into `~/Library/Application Support/CodexProjectChatSort` and
   creates `Codex Sorting.command` on the desktop.
5. A current-user LaunchAgent follows subsequent normal app starts. An already
   open desktop is allowed to finish.
6. Save your work, fully quit Codex, and open it again. Check the project menu.

For an explicit app path, use the bundled Node to run
`scripts/mac.mjs install --app "/Applications/Codex.app" --root "/your/install/path"`.
Keep the installation path when updating.

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

Names use numeric-aware, case-insensitive `zh-CN` comparison, so `Project 2`
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

The 0.3.0-rc.1 startup updater is an implementation candidate awaiting cloud
acceptance. Existing rc.2 installations need one transition upgrade to receive
it after acceptance. Its per-start patch checks, recovery boundaries and
remaining work are recorded in the compatibility architecture.

[Startup update development status](MULTIVERSION_COMPATIBILITY.en.md#startup-patch-checks)

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

## Removal

Windows uses `Uninstall.cmd` to restore its owned shortcut and remove its login
task. macOS uses `Uninstall-mac.command` to remove its launcher and LaunchAgent.
Remove the `codex_sidebar_sort` MCP entry from your agent.

Use `Restore app default sorting` for each override you want to clear. Retain
the companion configuration until any desired restore steps are complete.

## Support

Include your OS, desktop version, companion release, affected scope, actual
error and relevant state-file messages. Review screenshots for personal data
before sharing them.

[Companion downloads and support](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads)
