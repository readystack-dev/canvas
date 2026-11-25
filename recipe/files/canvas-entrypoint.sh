#!/bin/sh
# ReadyStack Canvas LMS entrypoint: one image, two roles, as upstream's docker-compose runs it (services web and jobs).
#   web   (default) Puma on port 3000. It first waits for PostgreSQL, then prepares an empty database with
#         `bin/rake db:initial_setup` (schema, default account, first administrator from CANVAS_LMS_ADMIN_EMAIL,
#         CANVAS_LMS_ADMIN_PASSWORD and CANVAS_LMS_ACCOUNT_NAME) or applies pending migrations with `bin/rake db:migrate`.
#         CANVAS_SKIP_MIGRATE=1 skips that step (more than one web container on one database).
#   jobs  the background job worker, `script/delayed_job run` (upstream's jobs service). It waits until the database
#         has no pending migration, so start it with the web container.
# Any other command (bin/rails console, bin/rake ...) runs as given.
set -e
cd /usr/src/app

export PGHOST="${CANVAS_DATABASE_HOST:-db}" PGPORT="${CANVAS_DATABASE_PORT:-5432}" \
       PGDATABASE="${CANVAS_DATABASE_NAME:-canvas_production}" PGUSER="${CANVAS_DATABASE_USERNAME:-canvas}" \
       PGPASSWORD="${CANVAS_DATABASE_PASSWORD:-}" PGCONNECT_TIMEOUT=5

need_key() {
  if [ "${#CANVAS_ENCRYPTION_KEY}" -lt 20 ]; then
    echo "canvas: set CANVAS_ENCRYPTION_KEY to a random secret of 20 or more characters (for example the output of" >&2
    echo "canvas: 'openssl rand -hex 32') and keep it: Canvas encrypts stored secrets with it." >&2
    exit 64
  fi
}

wait_db() {
  i=0
  until pg_isready -q; do
    i=$((i + 1))
    if [ "$i" -ge 150 ]; then
      echo "canvas: PostgreSQL at $PGHOST:$PGPORT did not accept connections for 5 minutes" >&2
      exit 69
    fi
    sleep 2
  done
  if ! psql -XtAqc 'SELECT 1' >/dev/null; then
    echo "canvas: cannot sign in to database $PGDATABASE on $PGHOST:$PGPORT as $PGUSER (check CANVAS_DATABASE_*)" >&2
    exit 69
  fi
}

if [ -n "${CANVAS_JWT_ENCRYPTION_KEY:-}" ] && [ "${#CANVAS_JWT_ENCRYPTION_KEY}" -ne 64 ]; then
  echo "canvas: CANVAS_JWT_ENCRYPTION_KEY must be exactly 64 characters (for example the output of 'openssl rand -hex 32')" >&2
  exit 64
fi

# Empty, or a first start that stopped before it created the administrator (no account_users row): db:initial_setup
# again (it creates only what is missing).
fresh_db() {
  [ -z "$(psql -XtAqc "SELECT to_regclass('public.account_users')")" ] && return 0
  [ -z "$(psql -XtAqc 'SELECT 1 FROM account_users LIMIT 1')" ]
}

case "$1" in
  web)
    need_key
    wait_db
    if [ "${CANVAS_SKIP_MIGRATE:-0}" != "1" ]; then
      if fresh_db; then
        for v in CANVAS_LMS_ADMIN_EMAIL CANVAS_LMS_ADMIN_PASSWORD CANVAS_LMS_ACCOUNT_NAME; do
          eval "val=\${$v:-}"
          if [ -z "$val" ]; then
            echo "canvas: the database is empty: set $v (with CANVAS_LMS_ADMIN_EMAIL, CANVAS_LMS_ADMIN_PASSWORD and" >&2
            echo "canvas: CANVAS_LMS_ACCOUNT_NAME) so the first start can create the account and its administrator" >&2
            exit 64
          fi
        done
        if [ "${#CANVAS_LMS_ADMIN_PASSWORD}" -lt 8 ]; then
          echo "canvas: CANVAS_LMS_ADMIN_PASSWORD must be at least 8 characters (Canvas refuses a shorter one)" >&2
          exit 64
        fi
        echo "canvas: empty database, running bin/rake db:initial_setup (this takes several minutes)"
        bin/rake db:initial_setup
      else
        echo "canvas: applying pending database migrations (bin/rake db:migrate)"
        bin/rake db:migrate
      fi
    fi
    shift
    exec bundle exec puma -C config/puma.rb -b "tcp://0.0.0.0:${CANVAS_PORT:-3000}" "$@"
    ;;
  jobs)
    need_key
    wait_db
    n=0
    until ! fresh_db && bin/rake db:abort_if_pending_migrations >/dev/null 2>&1; do
      [ $((n % 6)) -eq 0 ] && echo "canvas: waiting for the web container to finish the database migrations"
      n=$((n + 1))
      sleep 10
    done
    shift
    exec bundle exec script/delayed_job run "$@"
    ;;
esac
exec "$@"
