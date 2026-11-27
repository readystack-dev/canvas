# Provenance — Canvas LMS (`2026-05-20.143-CE-ubuntu24.04-r10`)

Every item below is copied from a record in this archive; the record is named in brackets.

## Source

- Upstream repository: https://github.com/instructure/canvas-lms
- Revision built: `release/2026-05-20.143` (commit `2e2b4a46d08e32667d4845f7b78e1214250345d3`)
- Source tree: `222ae1df10656048500098d09530d7337d8bb8fb99e7e3676629165870c2e1af` over 22662 files [`docs/provenance/SOURCE_TREE_HASH.json`]
- Community Edition only: enterprise code is removed or refused before the build (CE audit at acquire).

## Build

- Method: `source-rebuild-ruby`; base image `ubuntu:24.04`
- Compiled with `--network=none` from vendored source, dependencies and base images; BuildKit pinned to `moby/buildkit:v0.31.2` (shipped in `toolchain/`).
- SOURCE_DATE_EPOCH: `1795672787` [`SOURCE_DATE_EPOCH.txt`]
- Frozen inputs: [`docs/provenance/FREEZE_MANIFEST.json`], build recipe: [`docs/provenance/BUILD_RECIPE.json`].

## Output

- Published image: `readystack/canvas:2026-05-20.143-CE-ubuntu24.04-r10` — index digest `sha256:e24a6b596412136d3f6fc82ee2b7ec452470b23218288851d112a5f5158073d7` [`docs/provenance/LOCKED_DIGEST.txt`]
- linux/amd64 image digest `sha256:2547c4f3502c230a5eaf1bf23e88043ad73016317ac9404ee68ebbc90ad46223` — reproduced from this archive before publishing [`docs/provenance/REPRO_VERIFICATION.json`].

## Attestations and signature

- SBOM + SLSA provenance attached to the image: attached: an SPDX SBOM and SLSA v1 provenance [`docs/provenance/SCOUT_VERDICT.json`]
- cosign signature by the ReadyStack release key: verified before publishing. Check it: `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/canvas:2026-05-20.143-CE-ubuntu24.04-r10`

## Pinned inputs, and why

- 47 pinned inputs, each with where it came from, why this one, how it was checked and when it was decided: `docs/PINS.md` [`docs/provenance/PINS.json`] (upstream source 2, base and build images 1, image digests 1, language runtimes and toolchains 2, dependency versions readystack sets 32, pins in the kit's dockerfiles 4, readystack's build engine 1, dependencies upstream chose 2, services the release checks run beside 2).

## Build trail

- How this release passed through the ReadyStack harness, record by record (every chain, drive, stage, review round, defect and check, each naming the record it is copied from): `ReadyStack-canvas-2026-05-20.143-CE-ubuntu24.04-r10.trail.json`, published beside this archive and signed with the release key (`ReadyStack-canvas-2026-05-20.143-CE-ubuntu24.04-r10.trail.json.sigstore`), and readable at https://readystack.dev/products/canvas/trail/2026-05-20.143-CE-ubuntu24.04-r10.

