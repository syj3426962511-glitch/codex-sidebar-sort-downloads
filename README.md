# Codex Sidebar Sort desktop companion

Install the free companion on the computer that runs Codex Desktop. It adds
independent sorting rules to project chats, Projects, Pinned, Recents and
custom sections through supported three-dot menus.

## Install

Open the native installer, choose a dedicated installation folder and Install.
Node.js, companion libraries, startup following and the local Codex MCP
connection are included. No separate runtime or terminal setup is required.

| Computer | Self-contained installer | Size |
| --- | --- | --- |
| Windows x64 | [EXE setup wizard](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/releases/download/v0.3.0-rc.4/Codex-Sidebar-Sort-Windows-x64-Setup.exe) | 21.57 MiB |
| Mac Apple Silicon | [DMG installer](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/releases/download/v0.3.0-rc.4/Codex-Sidebar-Sort-Mac-Apple-Silicon.dmg) | 40.89 MiB |
| Mac Intel | [DMG installer](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/releases/download/v0.3.0-rc.4/Codex-Sidebar-Sort-Mac-Intel.dmg) | 42.37 MiB |

Save work, close Codex and reopen after installation. The installer offers an
explicit restart action. Your computer supplies its own compatible Codex Desktop
installation and sign-in. You can copy the EXE or DMG directly to another computer.

[English setup guide](installers/INSTALL.en.md) | [Complete buyer guide](USER-GUIDE.en.md)

## Verified installer lifecycle

Installer setup.1 packages companion 0.3.0-rc.4. All 34 cloud installation,
upgrade and uninstall checks passed across Windows x64, Apple Silicon Mac and
Intel Mac. They execute the final native installer, installed bundled Node,
startup service, automatic local MCP setup, configuration-preserving upgrade
and normal uninstaller. Existing unrelated configuration and a user file survive
removal. [Exact scope and cloud runs](installers/VALIDATION.en.md).

Current-release signed-in sidebar sorting, adapter recovery and complete client
restart acceptance remain pending. Earlier 0.2.0 signed-in results describe that
runtime. The community installers have no commercial code-signing certificate
or Apple Developer ID notarization; downloaded software may need OS approval.

![Windows setup on the independent cloud host](images/installers/windows-setup.png)
![Mac setup on the independent cloud host](images/installers/mac-setup.png)

## Sorting and updates

Choose Recently updated, Date created, natural English Name or Manual in a
supported sidebar sorting menu. Each project and sidebar scope saves a separate
rule. Startup discovers the installed desktop app, checks the published adapter
catalog and selects a matching local or accepted downloaded adapter. New interface
families enter support after adaptation and native acceptance. The accepted
repair catalog currently contains zero published packs.

[Compatibility](COMPATIBILITY.en.md) | [Multi-version implementation](MULTIVERSION_COMPATIBILITY.en.md)

## Use from chat

The native installer connects the local Codex MCP service. Load the purchased
[Agensi Skill](https://www.agensi.io/skills/codex-sidebar-sort) for agent-guided
sorting. Agensi delivers the paid Skill separately. Cursor and Claude Desktop
can connect the local service using the complete guide.

This repository contains free MIT companion distribution and installer source.
The full development repository is private. The paid Skill and creator's full
offline delivery kit are excluded from public Release assets. The portable
platform ZIPs remain available for advanced installations.
