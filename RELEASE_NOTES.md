# Canvas LMS 2026-05-20.143 — ReadyStack release `2026-05-20.143-CE-ubuntu24.04-r10`

Generated 2026-11-27 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/canvas:2026-05-20.143-CE-ubuntu24.04-r10` (linux/amd64). Index digest `sha256:e24a6b596412136d3f6fc82ee2b7ec452470b23218288851d112a5f5158073d7` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:2547c4f3502c230a5eaf1bf23e88043ad73016317ac9404ee68ebbc90ad46223` [`TARGET_DIGEST.txt`].
- **Upstream:** Canvas LMS 2026-05-20.143 built from source at `release/2026-05-20.143` of https://github.com/instructure/canvas-lms — upstream notes: https://github.com/instructure/canvas-lms/releases/tag/release/2026-05-20.143 [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** `ubuntu:24.04`; runtime user `canvas`.
- **Build:** `source-rebuild-ruby`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `2026-05-20.143-CE-ubuntu24.04-r9`.

## What changed in this release

- Upstream version unchanged (2026-05-20.143); ReadyStack rebuild.
- Minimum dependency versions ReadyStack enforces on top of upstream (raised only where upstream's own version was lower); shipped versions from the SBOM [`docs/sbom/SBOM.json`]:
  - `css_parser` at least `3.3.0` (shipped: `3.4.0`)
  - `activestorage` at least `8.0.5.1` (shipped: `8.0.5.2`)
  - `concurrent-ruby` at least `1.3.7` (shipped: `1.3.8`)
  - `crass` at least `1.0.7` (shipped: `1.0.8`)
  - `datadog` at least `2.32.0` (shipped: `2.32.0`)
  - `faraday` at least `2.14.3` (shipped: `2.14.4`)
  - `graphql` at least `2.5.26` (shipped: `2.5.26`)
  - `jwt` at least `3.2.0` (shipped: `3.3.1`)
  - `loofah` at least `2.25.2` (shipped: `2.25.3`)
  - `mail` at least `2.9.1` (shipped: `2.9.1`)
  - `net-imap` at least `0.6.4.1` (shipped: `0.6.8`)
  - `nokogiri` at least `1.19.4` (shipped: `1.19.7`)
  - `oauth` at least `1.1.6` (shipped: `1.1.9`)
  - `oauth2` at least `2.0.22` (shipped: `2.0.26`)
  - `oj` at least `3.17.3` (shipped: `3.17.8`)
  - `puma` at least `7.2.1` (shipped: `7.2.4`)
  - `rails-html-sanitizer` at least `1.7.1` (shipped: `1.7.2`)
  - `rubyzip` at least `3.4.0` (shipped: `3.7.0`)
  - `sqlite3` at least `2.9.6` (shipped: `2.9.6`)
  - `websocket-driver` at least `0.8.2` (shipped: `0.8.2`)
  - `brotli` at least `0.9.2` (shipped: `0.9.3`)
  - `rack` at least `3.2.8` (shipped: `3.2.9`)
  - `msgpack` at least `1.8.7` (shipped: `1.8.7`)
- Canvas LMS 2026-05-20.143 is unchanged from the release this supersedes (2026-05-20.143-CE-ubuntu24.04-r9); this release rebuilds it. Changes: libgssapi-krb5-2 moves from 1.20.1-6ubuntu2.10 to 1.20.1-6ubuntu2.12 (USN-9202-1); libk5crypto3 moves from 1.20.1-6ubuntu2.10 to 1.20.1-6ubuntu2.12 (USN-9202-1); libkrb5-3 moves from 1.20.1-6ubuntu2.10 to 1.20.1-6ubuntu2.12 (USN-9202-1); libkrb5support0 moves from 1.20.1-6ubuntu2.10 to 1.20.1-6ubuntu2.12 (USN-9202-1). Settings, ports and data volumes are those of 2026-05-20.143-CE-ubuntu24.04-r9: replace the container with this image on the same volumes.

## Security status at release (measured 2026-11-27)

- **Docker Scout:** 0 fixable critical/high vulnerabilities; runs as `canvas` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/canvas:2026-05-20.143-CE-ubuntu24.04-r10` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.
- **Before exposing this service:** CANVAS_ENCRYPTION_KEY encrypts the secrets Canvas stores (for example authentication-provider and LTI credentials): set a random value of 20 or more characters before the first start, keep it, and never change it once data exists.
- **Before exposing this service:** The Canvas session cookie is marked Secure (upstream's production setting): browsers keep it only over HTTPS or on localhost, so serve Canvas through a TLS reverse proxy and set CANVAS_SSL=true with your public host name in CANVAS_DOMAIN.
- **Before exposing this service:** The rich content editor Canvas serves is TinyMCE 5.10.9 (compiled into public/dist from upstream's yarn.lock), which is end-of-life upstream; its published advisories fixed only in TinyMCE 6 and later are not in this image's scanner results because the compiled bundle carries no package metadata.

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:2547c4f3502c230a5eaf1bf23e88043ad73016317ac9404ee68ebbc90ad46223`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 3 of 3 use cases passed (4 authored, 3 kept in the suite; 1 not exercised, see below) against the running image [`docs/validation/test-results.json`].
- The cases are `GET /health_check` (200), `GET /login/canvas` (200), `GET /` (200); the suite checks nothing else.
- 1 further authored check was not exercised and is not counted above: it needed credentials the build's check does not have (listed under Not exercised in `docs/validation/FAILED_TESTS.md`).

## Known issues

- None found (reviewed by held semantic review (Claude) on 2026-11-27).

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/canvas:2026-05-20.143-CE-ubuntu24.04-r10
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

