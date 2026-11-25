# Canvas LMS: ReadyStack build kit

The offline build kit for the Docker image `readystack/canvas:2026-05-20.143-CE-ubuntu24.04-r9`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [2026-05-20.143-CE-ubuntu24.04-r9](https://github.com/readystack-dev/canvas/releases/tag/2026-05-20.143-CE-ubuntu24.04-r9)
- Image: [`docker.io/readystack/canvas:2026-05-20.143-CE-ubuntu24.04-r9`](https://hub.docker.com/r/readystack/canvas/tags), manifest digest `sha256:80a5bbec80508439c107aec0ee2e16fb81531278c4c4118a6eb4714e74fb8d98`
- Product page: https://readystack.dev/products/canvas
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=canvas

Canvas LMS is distributed under its upstream licence (AGPL-3.0-only); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [2026-05-20.143-CE-ubuntu24.04-r9 release](https://github.com/readystack-dev/canvas/releases/tag/2026-05-20.143-CE-ubuntu24.04-r9): `ReadyStack-canvas-2026-05-20.143-CE-ubuntu24.04-r9.tar.gz` (964.8 MB), SHA-256 `a847ca58da07fbd5c3b0fc197bf10b60c0bd7961b7869479d681b05dc446dfb6`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-canvas-2026-05-20.143-CE-ubuntu24.04-r9.rebuild.json.sigstore ReadyStack-canvas-2026-05-20.143-CE-ubuntu24.04-r9.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-canvas-2026-05-20.143-CE-ubuntu24.04-r9.tar.gz
cd 2026-05-20.143-CE-ubuntu24.04-r9
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-canvas-2026-05-20.143-CE-ubuntu24.04-r9.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/canvas/recipe. The complete kit is the release download. Each release is a tag here.
