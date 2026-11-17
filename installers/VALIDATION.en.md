# Native installer validation

Installer version `0.3.0-setup.1` packages desktop companion `0.3.0-rc.4`.
All three platform lifecycle runs passed on independent GitHub-hosted systems.
The user's personal desktop was not installed, injected into or restarted.

| Installer | Cloud platform | Official client | Result |
| --- | --- | --- | --- |
| Windows x64 EXE | Windows Server 2025 x64 | OpenAI.Codex 26.1111.2228.0 | 12 lifecycle checks passed |
| Mac Apple Silicon DMG | macOS 15 arm64 | ChatGPT.app 26.1111.21308 | 11 lifecycle checks passed |
| Mac Intel DMG | macOS 15 x64 | ChatGPT.app 26.1111.21308 | 11 lifecycle checks passed |

Checks executed the final native installer and its uninstall entry. They cover
the custom folder with spaces, installed bundled Node, running startup service,
automatic local Codex MCP configuration, preservation of another MCP entry,
upgrade retention of installed configuration, service/MCP removal and retention
of an unrelated user file. Windows also verifies the owned shortcut restore
through its uninstall flow. Mac installation, upgrade and removal execute the
actual GUI app; the automated cloud driver invokes the same Install action.

The screenshots show actual native installer windows captured on those hosts.
They are installation evidence. Current-runtime signed-in sidebar sorting,
adapter recovery and complete client restart acceptance remain pending.
Historical 0.2.0 sorting results retain their original runtime scope.

- [Windows run](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/actions/runs/44133314834)
- [Apple Silicon run](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/actions/runs/44132955737)
- [Intel Mac run](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/actions/runs/44133323790)

The binary digests, exact checks and local-retention status are recorded in
`native-installers.json` on the release. Installers are community builds without
commercial code signing or Apple Developer ID notarization.
