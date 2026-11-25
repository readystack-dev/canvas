# Canvas LMS: ReadyStack build kit

The offline build kit for the Docker image `readystack/canvas:2026-05-20.143-CE-ubuntu24.04-r9`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [2026-05-20.143-CE-ubuntu24.04-r9](https://github.com/readystack-dev/canvas/releases/tag/2026-05-20.143-CE-ubuntu24.04-r9)
- Image: [`docker.io/readystack/canvas:2026-05-20.143-CE-ubuntu24.04-r9`](https://hub.docker.com/r/readystack/canvas/tags), manifest digest `sha256:80a5bbec80508439c107aec0ee2e16fb81531278c4c4118a6eb4714e74fb8d98`
- Product page: https://readystack.dev/products/canvas
- Source and build recipe: https://readystack.dev/products/canvas/recipe
- Build trail: https://readystack.dev/products/canvas/trail/2026-05-20.143-CE-ubuntu24.04-r9
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=canvas

## The image

Two containers from this one image, plus your PostgreSQL and Redis, as upstream's own docker-compose runs Canvas (services web and jobs): the web server (default command `web`: Puma on port 3000, non-root user canvas, uid 9999) and the background job worker (command `jobs`: `script/delayed_job run`). Both are required: without the jobs container, notifications, course imports and copies, file and thumbnail processing, grade exports and the scheduled (periodic) jobs are queued in PostgreSQL and never run. No PostgreSQL, Redis, nginx or Passenger inside the image; put your own TLS reverse proxy in front.

## Who uses Canvas LMS and why

Colleges, universities and schools that run their own learning management system.

Canvas LMS gives each course an online home where instructors publish content and assignments, post announcements, hold discussions and record grades in a gradebook.

A typical use: A college moves its courses online. Each course gets a Canvas site where the instructor publishes materials and assignments with due dates, students take part in course discussions, and marks go into a gradebook that shows each learner's progress.

From the upstream project's own description: https://github.com/instructure/canvas-lms, https://github.com/instructure/canvas-lms/wiki, https://www.instructure.com/canvas.

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-25 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 119 packages with copyleft licences (AGPL, GPL, LGPL, MPL), 111 of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component). AGPL: academic_benchmarks.
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`canvas`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-25; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/canvas.

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

— ReadyStack · https://readystack.dev
