# Installer and client validation

This evidence applies to installer 0.3.0-setup.2 and desktop companion 0.3.0-rc.5.

| Platform | Official client | Installer checks | Signed-out original-entry starts |
| --- | --- | ---: | ---: |
| Windows x64 | OpenAI.Codex 26.1111.2228.0 | 12 | 2 |
| Apple Silicon Mac | ChatGPT 26.1111.71025 arm64 | 11 | 2 |
| Intel Mac | ChatGPT 26.1111.71025 x64 | 11 | 2 |

The cloud jobs install the final packages into paths with spaces, run the
bundled Node, validate startup and local MCP registration, upgrade in place,
then remove the companion. Uninstall preserves an unrelated user file and a
separate MCP entry. Each official desktop opens twice from its original entry,
exposes the candidate renderer marker, and stays closed after exit.

The official Mac package was first reproduced with a failed interface match.
Two observed module variants restored source discovery. The patched source
passed parsing and the final artifact passed the two-start test on each Mac
architecture. The official Intel image contains an x86_64 executable.

All 192 source and fixture tests passed, including account isolation, manual
membership validation, single-write sorting, malformed and user-edited MCP
configuration, failed startup rollback and update recovery fixtures.

Signed-in sidebar sorting, stored rule retention and acceptance of a published
online repair remain pending for rc.5. The screenshots show real cloud installer
windows and a signed-out official desktop. The Windows runner is Windows Server
2025 and the Mac runners use macOS 15.

[Final cloud run](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/actions/runs/44216837597)
