use Mix.Config

config :ex_napster, api_base_url: System.get_env("EX_NAPSTER_API_BASE_URL"),
                    api_version:  System.get_env("EX_NAPSTER_API_VERSION"),
                    api_key:      System.get_env("EX_NAPSTER_API_KEY")

import_config "#{Mix.env}.exs"
