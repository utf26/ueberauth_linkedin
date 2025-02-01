defmodule Ueberauth.Strategy.LinkedIn.OAuth do
  @moduledoc """
  OAuth2 for LinkedIn.

  Add `client_id` and `client_secret` to your configuration:

  config :ueberauth, Ueberauth.Strategy.LinkedIn.OAuth,
    client_id: System.get_env("LINKEDIN_CLIENT_ID"),
    client_secret: System.get_env("LINKEDIN_CLIENT_SECRET")
  """
  use OAuth2.Strategy

  @defaults [
    strategy: __MODULE__,
    site: "https://www.linkedin.com",
    authorize_url: "https://www.linkedin.com/oauth/v2/authorization",
    token_url: "https://www.linkedin.com/oauth/v2/accessToken"
  ]

  @doc """
  Construct a client for requests to LinkedIn.

  This will be setup automatically for you in `Ueberauth.Strategy.LinkedIn`.

  These options are only useful for usage outside the normal callback phase of
  Ueberauth.
  """
  def client(opts \\ []) do
    config =
      :ueberauth
      |> Application.fetch_env!(Ueberauth.Strategy.LinkedIn.OAuth)
      |> check_credential(:client_id)
      |> check_credential(:client_secret)

    @defaults
    |> Keyword.merge(config)
    |> Keyword.merge(opts)
    |> OAuth2.Client.new()
    |> OAuth2.Client.put_serializer("application/json", Ueberauth.json_library())
  end

  @doc """
  Provides the authorized url for the request phase of Ueberauth.
  No need to call this usually.
  """
  def authorize_url!(params \\ [], opts \\ []) do
    opts
    |> client
    |> OAuth2.Client.authorize_url!(params)
  end

  def get(token, url, headers \\ [], opts \\ []) do
    [token: token]
    |> client
    |> put_param("client_secret", client().client_secret)
    |> OAuth2.Client.get(url, headers, opts)
  end

  def get_token!(params \\ [], options \\ []) do
    headers = Keyword.get(options, :headers, [])
    options = Keyword.get(options, :options, [])
    client_options = Keyword.get(options, :client_options, [])

    client = client(client_options)

    params_in_opts =
      Keyword.merge(params,
        client_id: client.client_id,
        client_secret: client.client_secret,
        grant_type: "authorization_code"
      )

    options = Keyword.put(options, :params, params_in_opts)

    client = OAuth2.Client.get_token!(client, [], headers, options)
    client.token
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, _params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> put_headers(headers)
    |> basic_auth()
  end

  defp check_credential(config, key) do
    check_config_key_exists(config, key)

    case Keyword.get(config, key) do
      value when is_binary(value) ->
        config

      {:system, env_key} ->
        case System.get_env(env_key) do
          nil ->
            raise "#{inspect(env_key)} missing from environment, expected in config :ueberauth, Ueberauth.Strategy.LinkedIn"

          value ->
            Keyword.put(config, key, value)
        end
    end
  end

  defp check_config_key_exists(config, key) when is_list(config) do
    unless Keyword.has_key?(config, key) do
      raise "#{inspect(key)} missing from config :ueberauth, Ueberauth.Strategy.LinkedIn"
    end

    config
  end

  defp check_config_key_exists(_, _) do
    raise "Config :ueberauth, Ueberauth.Strategy.LinkedIn is not a keyword list, as expected"
  end
end
