# ReadyStack: config/environments/production.rb evaluates every production-*.rb file beside it. This image has no web
# server in front of Puma, so Rails serves the compiled assets in public/ itself (upstream's production image serves them
# with nginx and Passenger).
config.public_file_server.enabled = true
config.public_file_server.headers = { "Cache-Control" => "public, max-age=31536000" }
# Upstream's production.rb sets force_ssl, so Rails writes the session cookie only on HTTPS requests (or behind a proxy
# that sends X-Forwarded-Proto: https). CANVAS_SSL=false (plain HTTP, for a private network or local evaluation only)
# turns it off; anything else keeps upstream's setting.
config.force_ssl = false if ENV["CANVAS_SSL"] == "false"
