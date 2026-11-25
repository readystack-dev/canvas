# GENERATED L-009 hermetic Ruby build (--network=none, SBOM+SLSA-attestation-producing).
# Compiles CRuby 3.4.13 from the vendored ruby-lang.org tarball and the native gems from vendor/cache, then
# copies Ruby + the installed bundle onto the pinned base with only runtime debs: no compiler, headers or Node.
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289 AS rubybuild
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 BUNDLE_LOCKFILE=Gemfile.lock CANVAS_PINNED_GITHUB_GEMS=skoji/gepub:f0647345b806d993c2e59a84b490fdcb21979dec
RUN --mount=type=bind,source=vendored/debs,target=/tmp/debs --mount=type=bind,source=vendored/build-debs,target=/tmp/bdebs \
    set --; for f in /tmp/debs/*.deb /tmp/bdebs/*.deb; do [ -e "$f" ] && set -- "$@" "$f"; done; \
    for pass in 1 2 3 4 5; do [ $# -eq 0 ] || dpkg -i --skip-same-version "$@" >/dev/null 2>&1 && break; done; \
    dpkg --configure -a && bad= && for d in "$@"; do p=$(dpkg-deb -f "$d" Package) v=$(dpkg-deb -f "$d" Version); \
      case "$(dpkg-query -W -f='${Version} ${db:Status-Abbrev}' "$p" 2>/dev/null)" in "$v ii"*) ;; *) bad="$bad $p=$v" ;; esac; done && \
    { [ -z "$bad" ] || { echo "vendored debs not installed at their vendored version:$bad" >&2; false; }; }
ARG SOURCE_DATE_EPOCH=1795543194
ENV SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}
COPY vendored/ruby/ /tmp/ruby/
RUN cd /tmp/ruby && echo 'd0d3bf3dd8c224a3c3b7ecd816a0f1b2cbcf4f87b5afcbdbe91d3fef177f351a  ruby-3.4.13.tar.gz' | sha256sum -c - && \
    tar -xzf ruby-3.4.13.tar.gz && cd ruby-3.4.13 && \
    ./configure --prefix=/usr/local --enable-shared --disable-install-doc --disable-install-static-library && \
    make -j"$(nproc)" && make install && \
    cd / && rm -rf /tmp/ruby && \
    find /usr/local/lib/ruby \( -name gem_make.out -o -name mkmf.log \) -delete && \
    ruby --version | grep -qF 'ruby 3.4.13'
COPY kitforge-ruby-gems.rb /tmp/kitforge-ruby-gems.rb
COPY vendored/ruby-gems/ /tmp/ruby-gems/
RUN ruby /tmp/kitforge-ruby-gems.rb install /tmp/ruby-gems net-imap=0.6.8 && \
    find /usr/local/lib/ruby \( -name gem_make.out -o -name mkmf.log \) -delete && \
    rm -rf /tmp/ruby-gems /tmp/kitforge-ruby-gems.rb
WORKDIR /usr/src/app
COPY vendored/canvas-src/ /usr/src/app/
RUN bundle install --local --jobs "$(nproc)" && bundle check && \
    rm -rf vendor/cache vendor/bundle/ruby/*/cache && \
    find vendor/bundle \( -name '*.o' -o -name '*.a' -o -name mkmf.log -o -name gem_make.out \) -delete && \
    chmod -R go-w vendor/bundle && \
    bundle check
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 RAILS_ENV=production BUNDLE_LOCKFILE=Gemfile.lock WEB_CONCURRENCY=2 CANVAS_LMS_STATS_COLLECTION=opt_out PATH=/usr/src/app/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin CANVAS_PINNED_GITHUB_GEMS=skoji/gepub:f0647345b806d993c2e59a84b490fdcb21979dec
RUN --mount=type=bind,source=vendored/debs,target=/tmp/debs \
    set --; for f in /tmp/debs/*.deb; do [ -e "$f" ] && set -- "$@" "$f"; done; \
    for pass in 1 2 3 4 5; do [ $# -eq 0 ] || dpkg -i --skip-same-version "$@" >/dev/null 2>&1 && break; done; \
    dpkg --configure -a && bad= && for d in "$@"; do p=$(dpkg-deb -f "$d" Package) v=$(dpkg-deb -f "$d" Version); \
      case "$(dpkg-query -W -f='${Version} ${db:Status-Abbrev}' "$p" 2>/dev/null)" in "$v ii"*) ;; *) bad="$bad $p=$v" ;; esac; done && \
    { [ -z "$bad" ] || { echo "vendored debs not installed at their vendored version:$bad" >&2; false; }; } && \
    rm -rf /var/lib/apt/lists/* \
           /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /var/cache/ldconfig/aux-cache /var/cache/fontconfig
ARG SOURCE_DATE_EPOCH=1795543194
RUN groupadd -g 9999 canvas && useradd -u 9999 -g canvas -s /bin/sh -d /home/canvas -m canvas && \
    : "${SOURCE_DATE_EPOCH:?SOURCE_DATE_EPOCH must be set for a reproducible build}" && \
    sed -ri "s/^([^:]*:[^:]*):[0-9]*:/\1:$((SOURCE_DATE_EPOCH/86400)):/" /etc/shadow && \
    rm -f /etc/passwd- /etc/shadow- /etc/group- /etc/gshadow-
COPY --from=rubybuild /usr/local/bin/ /usr/local/bin/
COPY --from=rubybuild /usr/local/lib/ /usr/local/lib/
COPY --from=rubybuild --chown=canvas:canvas /usr/src/app /usr/src/app
COPY canvas-entrypoint.sh /usr/local/bin/canvas-entrypoint.sh
COPY database.yml /usr/src/app/config/database.yml
COPY security.yml /usr/src/app/config/security.yml
COPY domain.yml /usr/src/app/config/domain.yml
COPY redis.yml /usr/src/app/config/redis.yml
COPY cache_store.yml /usr/src/app/config/cache_store.yml
COPY outgoing_mail.yml /usr/src/app/config/outgoing_mail.yml
COPY delayed_jobs.yml /usr/src/app/config/delayed_jobs.yml
COPY file_store.yml /usr/src/app/config/file_store.yml
COPY logging.yml /usr/src/app/config/logging.yml
COPY production-local.rb /usr/src/app/config/environments/production-local.rb
RUN ln -sf /dev/stdout /usr/src/app/log/production.log && ln -sf /dev/stdout /usr/src/app/log/delayed_job.log && \
    mkdir -p /usr/src/app/tmp/files /usr/src/app/tmp/pids /usr/src/app/log && chown -R canvas:canvas /usr/src/app/tmp/files /usr/src/app/tmp/pids /usr/src/app/log && \
    chown canvas:canvas /usr/src/app/config/database.yml && \
    chown canvas:canvas /usr/src/app/config/security.yml && \
    chown canvas:canvas /usr/src/app/config/domain.yml && \
    chown canvas:canvas /usr/src/app/config/redis.yml && \
    chown canvas:canvas /usr/src/app/config/cache_store.yml && \
    chown canvas:canvas /usr/src/app/config/outgoing_mail.yml && \
    chown canvas:canvas /usr/src/app/config/delayed_jobs.yml && \
    chown canvas:canvas /usr/src/app/config/file_store.yml && \
    chown canvas:canvas /usr/src/app/config/logging.yml && \
    chown canvas:canvas /usr/src/app/config/environments/production-local.rb && \
    chmod 0755 /usr/local/bin/canvas-entrypoint.sh && \
    ldconfig && rm -f /var/cache/ldconfig/aux-cache && \
    ruby --version | grep -qF 'ruby 3.4.13'
LABEL org.opencontainers.image.title="Canvas LMS"
LABEL org.opencontainers.image.description="Canvas LMS built from source on Ubuntu 24.04: non-root Puma web server; the same image runs the delayed_job worker; needs PostgreSQL and Redis"
LABEL org.opencontainers.image.version="2026-05-20.143-CE-ubuntu24.04-r9"
LABEL org.opencontainers.image.revision="2e2b4a46d08e32667d4845f7b78e1214250345d3"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"
LABEL org.opencontainers.image.source="https://github.com/instructure/canvas-lms"
LABEL org.opencontainers.image.vendor="ReadyStack.dev"
LABEL readystack.product="canvas"
LABEL readystack.edition="CE"
LABEL readystack.build_method="source-rebuild-ruby"
LABEL com.readystack.license.disclosure="This image includes Canvas LMS (https://github.com/instructure/canvas-lms), licensed under AGPL-3.0, built from upstream's tag release/2026-05-20.143 (upstream publishes no GA release tags after v5.14.2). Modifications: one line of Gemfile.d/app.rb allows css_parser 3.x (~> 3.3 instead of ~> 2.0) for GHSA-9pmc-p236-855h; full diff at https://readystack.dev/source/canvas/2026-05-20.143/canvas-2026-05-20.143-readystack.patch. Removed from the image (present in the upstream tag): spec/, .github/ and the JavaScript workspace package.json files (the JavaScript is precompiled into public/dist). Added: configuration files that read the environment. Other security patches are applied only via vendored updates to upstream-published RubyGems and apt dependencies (unmodified; gepub from its upstream repository at commit f0647345). ReadyStack license holders have access to the image build recipe and patched-package manifest on request via contact@readystack.dev."
HEALTHCHECK --interval=15s --timeout=30s --start-period=1800s \
  CMD curl -fsS -o /dev/null http://127.0.0.1:3000/health_check || exit 1
USER canvas
WORKDIR /usr/src/app
EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/canvas-entrypoint.sh"]
CMD ["web"]
