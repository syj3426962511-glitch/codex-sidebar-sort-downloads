# Compatibility and acceptance

## Current release

Companion 0.3.0-rc.5 and installer 0.3.0-setup.2 have the following cloud results.

| Official client | Native installer lifecycle | Original app launch with the companion | Signed-in sorting with this release |
| --- | --- | --- | --- |
| Windows x64 26.1111.2228.0 | Passed | Two signed-out starts passed | Pending |
| Apple Silicon Mac 26.1111.71025 | Passed | Two signed-out starts passed | Pending |
| Intel Mac 26.1111.71025 | Passed | Two signed-out starts passed | Pending |

The Mac builds use separate official arm64 and x64 images. On both, the new
interface variant matches 13 interface modules and 25 sidebar hook positions.
Every tested start reached the candidate renderer readiness marker and the
desktop stayed closed after exit.

[Current cloud run](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/actions/runs/44216837597) |
[Current release](https://github.com/syj3426962511-glitch/codex-sidebar-sort-downloads/releases/tag/v0.3.0-rc.5)

## Historical acceptance

Earlier 0.2.0 signed-in evidence covers Windows 26.1111.2228.0 x64 and macOS
26.1111.21308 arm64 with 30 projects and 360 test chats per platform. The rc.2
native sorting and preference code matches the accepted rc.1 source after
line-ending normalization. The release has 119 automated tests and 22 Skill
checks per OS and three delivered package installation checks.

## Existing interface profiles

| Renderer | Recorded Windows package | Adapter family | Acceptance coverage |
| --- | --- | --- | --- |
| 26.1111.71025 | Not sampled | native-v3 structural variant | Mac arm64 and x64 source and startup passed with rc.5, signed-in acceptance pending |
| 26.1111.21308 | 26.1111.2228.0 | native-v3 | Windows x64 and Mac arm64 full native matrix |
| 26.1002.51308 | 26.1002.6548.0 | legacy-sidebar-v2 | Historical partial/source checks, refreshed full matrix pending |
| 26.930.31730 | 26.930.3930.0 | legacy-sidebar-v2 | Historical partial/source checks, refreshed full matrix pending |
| 26.928.21956 | 26.928.2636.0 | legacy-sidebar-v2 | Historical partial/source checks, refreshed full matrix pending |
| 26.928.20755 | 26.928.1915.0 | legacy-sidebar-v2 | Historical partial/source checks, refreshed full matrix pending |
| 26.924.22138 | 26.924.2738.0 | legacy-sidebar-v2 | Historical partial/source checks, refreshed full matrix pending |

## Historical sample inventory

The inventory contains 158 archived release records. The table records available source references. Cloud downloads, publisher signatures, interface comparisons and native acceptance establish support for each sample.

Windows package and Mac renderer release schedules differ. The underlying Windows renderer version is recorded separately in the machine-readable inventory. Matching actual interfaces establishes shared evidence across builds.

| Mac renderer release | Archived Windows x64 candidate | Current family classification | Inspection state |
| --- | --- | --- | --- |
| 26.1111.21308 | 26.1111.2228.0 | native-v3 | Profile recorded |
| 26.1106.51428 | 26.1106.6628.0 | unclassified | Package/interface inspection pending |
| 26.1103.60933 | 26.1103.7773.0 | unclassified | Package/interface inspection pending |
| 26.1103.41825 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.1103.32239 | 26.1103.4239.0 | unclassified | Package/interface inspection pending |
| 26.1103.31037 | 26.1103.3517.0 | unclassified | Package/interface inspection pending |
| 26.1029.70936 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.1029.61003 | 26.1029.7803.0 | unclassified | Package/interface inspection pending |
| 26.1027.61615 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.1027.51404 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.1027.30824 | 26.1027.3384.0 | unclassified | Package/interface inspection pending |
| 26.1023.51421 | 26.1023.6621.0 | unclassified | Package/interface inspection pending |
| 26.1023.50603 | 26.1023.6123.0 | unclassified | Package/interface inspection pending |
| 26.1021.31345 | 26.1021.3705.0 | unclassified | Package/interface inspection pending |
| 26.1021.22027 | 26.1021.2667.0 | unclassified | Package/interface inspection pending |
| 26.1016.62342 | 26.1016.8622.0 | unclassified | Package/interface inspection pending |
| 26.1016.61520 | 26.1016.8120.0 | unclassified | Package/interface inspection pending |
| 26.1016.51333 | 26.1016.6573.0 | unclassified | Package/interface inspection pending |
| 26.1013.40934 | 26.1013.4894.0 | unclassified | Package/interface inspection pending |
| 26.1013.31256 | 26.1013.3656.0 | unclassified | Package/interface inspection pending |
| 26.1007.71326 | 26.1007.9446.0 | unclassified | Package/interface inspection pending |
| 26.1007.41230 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.1007.30912 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.1007.21434 | 26.1007.2314.0 | unclassified | Package/interface inspection pending |
| 26.1007.21159 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.1002.52244 | 26.1002.7124.0 | unclassified | Package/interface inspection pending |
| 26.1002.51308 | 26.1002.6548.0 | legacy-sidebar-v2 | Profile recorded |
| 26.930.61225 | 26.930.7945.0 | unclassified | Package/interface inspection pending |
| 26.930.51102 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.930.41038 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.930.31730 | 26.930.3930.0 | legacy-sidebar-v2 | Profile recorded |
| 26.930.31428 | 26.930.3748.0 | unclassified | Package/interface inspection pending |
| 26.930.21537 | 26.930.2377.0 | unclassified | Package/interface inspection pending |
| 26.928.40906 | 26.928.4866.0 | unclassified | Package/interface inspection pending |
| 26.928.31416 | 26.928.3736.0 | unclassified | Package/interface inspection pending |
| 26.928.21956 | 26.928.2636.0 | legacy-sidebar-v2 | Profile recorded |
| 26.928.20755 | 26.928.1915.0 | legacy-sidebar-v2 | Profile recorded |
| 26.924.51851 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.924.22138 | 26.924.2738.0 | legacy-sidebar-v2 | Profile recorded |
| 26.924.20706 | 26.924.1866.0 | unclassified | Package/interface inspection pending |
| 26.917.71314 | 26.917.9434.0 | unclassified | Package/interface inspection pending |
| 26.917.62051 | 26.917.8451.0 | unclassified | Package/interface inspection pending |
| 26.917.61114 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.917.51856 | 26.917.6896.0 | unclassified | Package/interface inspection pending |
| 26.915.31945 | 26.915.4065.0 | unclassified | Package/interface inspection pending |
| 26.915.31029 | 26.915.3509.0 | unclassified | Package/interface inspection pending |
| 26.911.61220 | 26.911.7940.0 | unclassified | Package/interface inspection pending |
| 26.908.70816 | 26.908.9136.0 | unclassified | Package/interface inspection pending |
| 26.908.61612 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.908.40834 | 26.908.4834.0 | unclassified | Package/interface inspection pending |
| 26.908.40401 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.908.31748 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.908.31457 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.903.71938 | 26.903.9818.0 | unclassified | Package/interface inspection pending |
| 26.903.61454 | 26.903.8094.0 | unclassified | Package/interface inspection pending |
| 26.901.51231 | 26.901.6511.0 | unclassified | Package/interface inspection pending |
| 26.901.41600 | 26.901.5280.0 | unclassified | Package/interface inspection pending |
| 26.901.41123 | 26.901.5003.0 | unclassified | Package/interface inspection pending |
| 26.901.31953 | 26.901.4073.0 | unclassified | Package/interface inspection pending |
| 26.901.22334 | 26.901.2854.0 | unclassified | Package/interface inspection pending |
| 26.901.20858 | 26.901.1978.0 | unclassified | Package/interface inspection pending |
| 26.831.21537 | 26.831.2377.0 | unclassified | Package/interface inspection pending |
| 26.831.20005 | 26.831.1445.0 | unclassified | Package/interface inspection pending |
| 26.831.11858 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.825.51511 | 26.825.6671.0 | unclassified | Package/interface inspection pending |
| 26.825.41651 | 26.825.5331.0 | unclassified | Package/interface inspection pending |
| 26.825.32147 | 26.825.4187.0 | unclassified | Package/interface inspection pending |
| 26.825.31414 | 26.825.3734.0 | unclassified | Package/interface inspection pending |
| 26.820.80927 | 26.820.10647.0 | unclassified | Package/interface inspection pending |
| 26.820.71523 | 26.820.9563.0 | unclassified | Package/interface inspection pending |
| 26.820.60940 | 26.820.7780.0 | unclassified | Package/interface inspection pending |
| 26.818.61809 | 26.818.8289.0 | unclassified | Package/interface inspection pending |
| 26.818.41705 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.818.41509 | 26.818.5229.0 | unclassified | Package/interface inspection pending |
| 26.818.32112 | 26.818.4152.0 | unclassified | Package/interface inspection pending |
| 26.818.31338 | 26.818.3698.0 | unclassified | Package/interface inspection pending |
| 26.818.22352 | 26.818.2872.0 | unclassified | Package/interface inspection pending |
| 26.818.21641 | 26.818.2441.0 | unclassified | Package/interface inspection pending |
| 26.814.41957 | 26.814.5517.0 | unclassified | Package/interface inspection pending |
| 26.814.41407 | 26.814.5167.0 | unclassified | Package/interface inspection pending |
| 26.810.52044 | 26.810.7004.0 | unclassified | Package/interface inspection pending |
| 26.810.50856 | 26.810.6296.0 | unclassified | Package/interface inspection pending |
| 26.810.41047 | 26.810.4967.0 | unclassified | Package/interface inspection pending |
| 26.803.81509 | 26.803.10989.0 | unclassified | Package/interface inspection pending |
| 26.803.61601 | 26.803.8161.0 | unclassified | Package/interface inspection pending |
| 26.803.41515 | 26.803.5235.0 | unclassified | Package/interface inspection pending |
| 26.730.61639 | 26.730.8199.0 | unclassified | Package/interface inspection pending |
| 26.730.61309 | 26.730.7989.0 | unclassified | Package/interface inspection pending |
| 26.727.51351 | 26.727.6591.0 | unclassified | Package/interface inspection pending |
| 26.727.40816 | 26.727.4816.0 | unclassified | Package/interface inspection pending |
| 26.721.81911 | 26.721.11231.0 | unclassified | Package/interface inspection pending |
| 26.721.41059 | 26.721.4979.0 | unclassified | Package/interface inspection pending |
| 26.721.31836 | 26.721.3996.0 | unclassified | Package/interface inspection pending |
| 26.721.30844 | 26.721.3404.0 | unclassified | Package/interface inspection pending |
| 26.715.72359 | 26.715.10079.0 | unclassified | Package/interface inspection pending |
| 26.715.72028 | 26.715.9868.0 | unclassified | Package/interface inspection pending |
| 26.715.71837 | 26.715.9757.0 | unclassified | Package/interface inspection pending |
| 26.715.70719 | 26.715.9079.0 | unclassified | Package/interface inspection pending |
| 26.715.61943 | 26.715.8383.0 | unclassified | Package/interface inspection pending |
| 26.715.52143 | 26.715.7063.0 | unclassified | Package/interface inspection pending |
| 26.715.31925 | 26.715.4045.0 | unclassified | Package/interface inspection pending |
| 26.715.31251 | 26.715.3651.0 | unclassified | Package/interface inspection pending |
| 26.715.21425 | 26.715.2305.0 | unclassified | Package/interface inspection pending |
| 26.715.21316 | 26.715.2236.0 | unclassified | Package/interface inspection pending |
| 26.707.91948 | 26.707.12708.0 | unclassified | Package/interface inspection pending |
| 26.707.72221 | 26.707.9981.0 | unclassified | Package/interface inspection pending |
| 26.707.71524 | 26.707.9564.0 | unclassified | Package/interface inspection pending |
| 26.707.62119 | 26.707.8479.0 | unclassified | Package/interface inspection pending |
| 26.707.61608 | 26.707.8168.0 | unclassified | Package/interface inspection pending |
| 26.707.51957 | 26.707.6957.0 | unclassified | Package/interface inspection pending |
| 26.707.41301 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.707.31428 | 26.707.3748.0 | unclassified | Package/interface inspection pending |
| 26.623.141536 | 26.623.19656.0 | unclassified | Package/interface inspection pending |
| 26.623.101652 | 26.623.13972.0 | unclassified | Package/interface inspection pending |
| 26.623.81905 | 26.623.11225.0 | unclassified | Package/interface inspection pending |
| 26.623.70822 | 26.623.9142.0 | unclassified | Package/interface inspection pending |
| 26.623.61825 | 26.623.8305.0 | unclassified | Package/interface inspection pending |
| 26.623.42026 | 26.623.5546.0 | unclassified | Package/interface inspection pending |
| 26.623.41415 | 26.623.5175.0 | unclassified | Package/interface inspection pending |
| 26.623.31921 | 26.623.4041.0 | unclassified | Package/interface inspection pending |
| 26.623.31443 | 26.623.3763.0 | unclassified | Package/interface inspection pending |
| 26.623.30605 | 26.623.3245.0 | unclassified | Package/interface inspection pending |
| 26.616.81150 | 26.616.10790.0 | unclassified | Package/interface inspection pending |
| 26.616.71553 | 26.616.9593.0 | unclassified | Package/interface inspection pending |
| 26.616.51431 | 26.616.6631.0 | unclassified | Package/interface inspection pending |
| 26.616.41845 | 26.616.5445.0 | unclassified | Package/interface inspection pending |
| 26.616.32156 | 26.616.4196.0 | unclassified | Package/interface inspection pending |
| 26.616.31447 | 26.616.3767.0 | unclassified | Package/interface inspection pending |
| 26.616.30709 | 26.616.3309.0 | unclassified | Package/interface inspection pending |
| 26.611.62324 | 26.611.8604.0 | unclassified | Package/interface inspection pending |
| 26.611.61753 | 26.611.8273.0 | unclassified | Package/interface inspection pending |
| 26.611.61049 | 26.611.7849.0 | unclassified | Package/interface inspection pending |
| 26.609.71450 | 26.609.9530.0 | unclassified | Package/interface inspection pending |
| 26.609.71144 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.609.41114 | 26.609.4994.0 | unclassified | Package/interface inspection pending |
| 26.608.12217 | 26.608.1337.0 | unclassified | Package/interface inspection pending |
| 26.602.71036 | 26.602.9276.0 | unclassified | Package/interface inspection pending |
| 26.602.40724 | 26.602.4764.0 | unclassified | Package/interface inspection pending |
| 26.602.30954 | 26.602.3474.0 | unclassified | Package/interface inspection pending |
| 26.601.21317 | 26.601.2237.0 | unclassified | Package/interface inspection pending |
| 26.601.20914 | 26.601.1994.0 | unclassified | Package/interface inspection pending |
| 26.527.60818 | 26.527.7698.0 | unclassified | Package/interface inspection pending |
| 26.527.31326 | 26.527.3686.0 | unclassified | Package/interface inspection pending |
| 26.527.30818 | 26.527.3378.0 | unclassified | Package/interface inspection pending |
| 26.519.81530 | 26.519.11010.0 | unclassified | Package/interface inspection pending |
| 26.519.80914 | 26.519.10634.0 | unclassified | Package/interface inspection pending |
| 26.519.41501 | 26.519.5221.0 | unclassified | Package/interface inspection pending |
| 26.519.31651 | 26.519.3891.0 | unclassified | Package/interface inspection pending |
| 26.519.22136 | 26.519.2736.0 | unclassified | Package/interface inspection pending |
| 26.519.21041 | 26.519.2081.0 | unclassified | Package/interface inspection pending |
| 26.513.40821 | 26.513.4821.0 | unclassified | Package/interface inspection pending |
| 26.513.31313 | 26.513.3673.0 | unclassified | Package/interface inspection pending |
| 26.513.20950 | Source not located in this record | unclassified | Package/interface inspection pending |
| 26.506.31421 | 26.506.3741.0 | unclassified | Package/interface inspection pending |
| 26.506.31004 | 26.506.3484.0 | unclassified | Package/interface inspection pending |
| 26.506.21252 | 26.506.2212.0 | unclassified | Package/interface inspection pending |
| 26.506.20924 | 26.506.2004.0 | unclassified | Package/interface inspection pending |
| 26.429.61741 | 26.429.8261.0 | unclassified | Package/interface inspection pending |

## Automatic adapter maintenance

The 0.3.0-rc.3 candidate requests the adapter catalog at every startup, including starts with a healthy local adapter. It adds accepted-adapter downloads, staging syntax checks, installed preflight, atomic cache selection, offline reuse and version/update diagnostics. Existing rc.2 installations need one transition upgrade to receive the updater. The released rc.2 guide describes the current manual upgrade procedure.

GitHub runner admission prevented the candidate cloud tests from starting. The candidate's 64 dedicated regression cases await execution. Six saved source samples have static AST inspection, with four candidate structure groups. Broader historical native acceptance, in-session health recovery, Node.js interpreter upgrades and continuous official-build monitoring remain development work.

Startup activation recovery is now implemented in the candidate. It records fresh renderer health, skips runtime/interface pairs that failed startup, tries a compatible local recovery runtime and reloads the native renderer after failed recovery. Early client closure, damaged health metadata and missing adapter files have dedicated recovery or diagnostic paths. Windows selects the runtime and activates its renderer under the same launch mutex.

The component bootstrap can update its updater, platform launchers and startup monitors before client archive discovery. Existing MCP connections follow selected adapter replacements and read current configuration. These paths await independent cloud execution and native lifecycle acceptance.

The structural discovery candidate has four legacy recipes based on 26.928.20755, 26.928.21956, 26.930.31730 and 26.1002.51308, each covering eleven hooks in eight function contexts. Unique function syntax trees, token boundaries and semantic renderer/import declarations determine selection. The schema-2 lexical signatures preserve shadowing and parameter-expression binding relationships. The native-v3 structural candidate adds thirteen required interfaces across three module factories, twenty-two integration points in eleven function contexts and three loader captures. Both paths await native acceptance. The 26.924 recipe needs its matching shared source.

[Multi-version architecture](MULTIVERSION_COMPATIBILITY.en.md) · [Machine-readable history](compatibility/history.json) · [Current release receipt](receipts/release-0.3.0-rc.5.json)
