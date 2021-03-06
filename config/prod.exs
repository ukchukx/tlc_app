use Mix.Config

config :tlc_app, env: :prod
# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :tlc_app, TlcApp.Web.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 12000],
  url: [host: "tlc.catena.com.ng", port: 80],
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json",
  version: Application.spec(:tlc_app, :vsn)

# Do not print debug messages in production
config :logger, level: :info

config :logger,
  backends: [:console, {LoggerFileBackend, :info}]
  # compile_time_purge_matching: [ For Elixir >= 1.7
  #   [application: :tlc_app, level_lower_than: :info]
  # ]

config :logger, :info,
  path: "logs/log.log",
  format: "[$date] [$time] [$level] $metadata $levelpad$message\n",
  metadata: [:date, :application, :module, :function, :line, :request_id],
  level: :info


# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :tlc_app, TlcApp.Web.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         :inet6,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :tlc_app, TlcApp.Web.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases (distillery)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :tlc_app, TlcApp.Web.Endpoint, server: true
#
# Note you can't rely on `System.get_env/1` when using releases.
# See the releases documentation accordingly.

# Finally import the config/prod.secret.exs which should be versioned
# separately.
config :tlc_app, TlcApp.Web.Endpoint,
  secret_key_base: "ERuPyHaKvmyhi4fxg8LFVRiHHhlD4H8OjWM9FlSNN9C54oETLHPSWEncJth+dgKX"

# Configure your database
config :tlc_app, TlcApp.Repo,
  username: "postgres",
  password: "postgres",
  database: "tlc",
  pool_size: 15
