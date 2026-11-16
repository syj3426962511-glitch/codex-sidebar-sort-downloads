# Multi-version compatibility architecture

## Outcome

Install the desktop companion once. At each normal Codex start, discover the
actual application, identify its available sidebar interfaces and select the
appropriate adapter. Retain sorting rules across compatible adapter changes.
Publish the observed coverage for historical and newly released builds.

The current production Skill is Agensi 1.1 with companion 0.2.0-rc.2. Its
signed-in acceptance covers Windows 26.1111.2228.0 and macOS 26.1111.21308.
The historical inventory currently contains 158 archived release records from
26.429.61741 through 26.1111.21308. Package availability, publisher signatures,
interface families and native acceptance are recorded as individual stages.

## Engineering choices

| Technique | Role | Required evidence |
| --- | --- | --- |
| Exact interface and dependency contents | Fast reuse of an accepted adapter after asset renames, relocation or package-version changes | Renderer and storage dependencies match the accepted interface |
| Semantic AST discovery | Identify interfaces after minifier names or unrelated source change | Unique anchors, lexical bindings, data shape and complete interface contract |
| Runtime capability discovery | Confirm native IDs, membership, metadata, menu actions, subscriptions and persistence | Read-only live contract checks in the intended application context |
| DOM and accessibility discovery | Find menu hosts, inspect rows and verify rendered order | Stable IDs, correct scope and a complete traversal of virtualized lists |
| Structural clustering | Group package samples and prioritize adapter work | Measured signatures and acceptance for each resulting interface family |
| Adapter downloads | Deliver newly accepted family adapters to existing installations | Trusted distribution source, package digest and installed preflight |

DOM manipulation needs to respect the framework's ownership of rendered nodes.
React documents how external changes can conflict with its reconciliation.
Virtualized lists render the visible subset of a larger collection. Whole-scope
sorting therefore uses the complete native model and stable IDs. DOM checks
verify the resulting native display. [React DOM guidance](https://react.dev/learn/manipulating-the-dom-with-refs)
· [Virtualized lists](https://tanstack.com/virtual/latest/docs/introduction)

Permanent HTML/preload edits also depend on package signing, ASAR validation and
the application's script policy. Electron can terminate an application when an
enabled ASAR integrity check fails. The production integration uses the running
renderer response and independent companion files. The architecture retains
that delivery path while adding feature discovery. [Electron ASAR integrity](https://www.electronjs.org/docs/latest/tutorial/asar-integrity)

## Discovery and family selection

1. Discover the registered Windows package or installed Mac bundle. Record its
   actual version, architecture, executable, archive path and data-home context.
2. Check accepted interface contents, including storage dependencies. Identical
   interfaces can share their corresponding acceptance evidence.
3. For an unfamiliar interface, parse candidate modules and identify stable
   business fields, localization keys, native calls and storage contracts.
   Resolve variable bindings through their lexical scopes.
4. Compare semantic and runtime signatures with known families. Candidate
   matching considers project identity, source, host, membership, timestamps,
   menu descriptors, list virtualization and preference subscriptions.
5. A structural similarity score nominates a candidate adapter. Activation uses
   the adapter's required interface contract and its observed capabilities.
6. Record missing or ambiguous anchors with their stage, scope and client
   version. Feed genuinely new structures into the family acceptance process.

A string such as `conversations`, a CSS class or a localization key supplies
one discovery clue. A complete contract combines independent anchors with the
actual native data model. Family counts and similarity thresholds are determined
from the inspected samples.

## Common sorting logic and family adapters

The shared core implements natural names, creation/update dates, missing-date
placement, manual permutations and independent per-scope rules. A family adapter
provides native project/chat records, complete membership, subscriptions, menu
integration, virtualized ordering and preference access.

Each adapter declares these capabilities explicitly.

- Project headers, project chats, Pinned, Recents and custom sections.
- Stable native IDs and account/source/host/project identity.
- Complete pagination and authoritative displayed order.
- Available timestamps and supported automatic directions.
- Manual editor, saved order, live metadata updates and restore-default action.
- Persistence and migration contract for companion-owned rules.

Native project identity and membership remain the source for grouping. Sorting
rules use separate, versioned companion records. Migration reads older records,
retains reset markers and keeps rules available when an adapter is temporarily
waiting for support.

## User-visible states

| State | Meaning | User experience |
| --- | --- | --- |
| Verified interface | The native interface family has the applicable complete acceptance evidence | Automatic selection and normal sorting controls |
| Dynamically detected | Semantic and live contracts match a known family, with coverage recorded for this detected interface | Show actual version, activated capabilities and remaining acceptance |
| Waiting for adapter | A required interface is missing, ambiguous or awaiting validation | Open Codex normally, retain rules and show the failed detection stage |

The diagnostic page and `sidebar_status` show the actual client version, matched
renderer/family, adapter origin, last check and any update error. A message about
dynamic discovery is tied to the tests that actually passed.

## Transactional installation and recovery

1. Download a candidate into an extension-owned staging directory.
2. Validate its distribution URL, package digest, file paths and runtime API.
3. Parse the transformed JavaScript and run the family contract checks before
   selecting it for the client.
4. Commit the selected adapter atomically. Keep the previous usable family
   adapter available for recovery.
5. Check renderer health, native catalog readiness and each activated scope.
   On a failed activation, disable that candidate and restore the previous
   selected adapter or the normal application startup path.
6. Record the failed stage and acknowledged changes. Preserve native project
   data and companion sorting rules throughout recovery.

Shortcut replacement retains its exact original backup. Adapter transactions
operate on companion files and renderer interception. A successful syntax check
is one stage in the complete native acceptance process.

## Historical coverage and new releases

The history inventory records source URLs and provenance. Official vendor URLs
and archived original packages have separate source records. Before execution,
verify the actual publisher signature and platform package identity in the
independent cloud environment.

For every inspected sample, record its renderer/dependency contents, structural
signature, menu model, metadata model, storage schema and native capabilities.
Cluster those results into interface families and implement the missing family
bindings around the common core.

Version 26.1103.4239.0 is an explicit Windows sample target. Archived Mac and
Windows release dates can differ. The Windows renderer version and native
contents establish its relationship to a Mac sample.

The maintenance pipeline checks official update feeds, inspects new packages,
reuses existing family evidence where the actual interfaces match and runs the
remaining family acceptance before publishing an update. Existing installations
retrieve a matching accepted adapter at startup. An offline installation uses
its available compatible local adapters and records any pending update.

## Acceptance matrix

Every interface family receives the following native checks on its supported
platforms.

| Area | Checks |
| --- | --- |
| Five scope types | Projects, project chats, Pinned, Recents and custom sections |
| Ordering | Name, creation, update, manual, both automatic directions and reset |
| Complete membership | Full pagination, duplicate titles, exact IDs and virtualized traversal |
| Grouping | Same project identities, chat IDs, source/host membership and section placement |
| Live behavior | Rename, new records, metadata updates and stale manual-edit membership |
| Persistence | Independent rules, complete process exit/restart and adapter replacement |
| Recovery | Offline feed, invalid package, failed preflight, failed activation and rollback |
| Concurrency | Concurrent starts/updates and explicitly tested multiple native windows |
| Performance | Idle CPU, startup cost and bounded observer work |

Use real cloud clients with fictional projects and chats. Reuse evidence for
byte-identical interfaces and record exactly which layers it covers. An
interface or storage change receives the affected native checks again.

## Delivery status

| Component | Current status |
| --- | --- |
| Common core and five native scope types | Accepted for the current Windows/Mac family |
| Content discovery after resource renames/relocation | Released in companion 0.2.0-rc.2 |
| Current automated suite | 119 passes per OS, plus 22 Skill checks per OS |
| Current official-client startup checks | Fresh-profile Windows/Mac launch, exit/reopen and fixture preference retention passed |
| Historical source inventory | 158 release records collected, six existing profiles mapped |
| Automatic adapter selection/download and diagnostic page | Implementation candidate, cloud acceptance in progress |
| Semantic AST discovery and measured family clustering | Historical-package inspection and implementation work in progress |
| Complete refreshed historical-family acceptance | Pending the corresponding inspected and adapted samples |

Unknown future interfaces receive the same discovery, contract and recovery
process. The compatibility table reports observed coverage as that work proceeds.
