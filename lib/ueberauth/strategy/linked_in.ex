defmodule Ueberauth.Strategy.LinkedIn do
  @moduledoc """
  LinkedIn Strategy for Überauth.
  """
  @user_url "https://api.linkedin.com/v2/userinfo"

  use Ueberauth.Strategy,
      uid_field: :id,
      default_scope: "openid profile email",
      send_redirect_uri: true,
      oauth2_module: Ueberauth.Strategy.LinkedIn.OAuth

  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth.Credentials
  alias Ueberauth.Auth.Extra

  @doc """
  Handles initial request for LinkedIn authentication.
  """
  def handle_request!(conn) do
    opts =
      []
      |> with_scopes(conn)
      |> with_state_param(conn)
      |> with_redirect_uri(conn)

    module = option(conn, :oauth2_module)
    redirect!(conn, apply(module, :authorize_url!, [opts]))
  end

  @doc """
  Handles the callback from LinkedIn.
  """
  def handle_callback!(%Plug.Conn{params: %{"code" => code}} = conn) do
    module = option(conn, :oauth2_module)
    args = [[code: code] |> with_redirect_uri(conn)]
    token = apply(module, :get_token!, args)

    if token.access_token == nil do
      set_errors!(conn, [
        error(token.other_params["error"], token.other_params["error_description"])
      ])
    else
      fetch_user(conn, token)
    end
  end

  @doc false
  def handle_callback!(conn) do
    set_errors!(conn, [error("missing_code", "No code received")])
  end

  @doc """
  Cleans up the private area of the connection used for passing the raw LinkedIn
  response around during the callback.
  """
  def handle_cleanup!(conn) do
    conn
    |> put_private(:linkedin_user, nil)
    |> put_private(:linkedin_token, nil)
  end

  @doc """
  Fetches the `:uid` field from the LinkedIn response.

  This defaults to the option `:uid_field` which in-turn defaults to `:id`
  """
  def uid(conn) do
    conn |> option(:uid_field) |> to_string() |> fetch_uid(conn)
  end

  @doc """
  Includes the credentials from the LinkedIn response.
  """
  def credentials(conn) do
    token = conn.private.linkedin_token
    scope_string = token.other_params["scope"] || ""
    scopes = String.split(scope_string, ",")

    %Credentials{
      token: token.access_token,
      refresh_token: token.refresh_token,
      expires_at: token.expires_at,
      token_type: token.token_type,
      expires: !!token.expires_at,
      scopes: scopes
    }
  end

  @doc """
  Fetches the fields to populate the info section of `Ueberauth.Auth` struct.
  """
  def info(conn) do
    user = conn.private.linkedin_user

    %Info{
      name: user["name"],
      first_name: user["given_name"],
      last_name: user["family_name"],
      image: user["picture"],
      email: user["email"],
    }
  end

  @doc """
  Stores the raw information (including the token) obtained from the LinkedIn callback.
  """
  def extra(conn) do
    %Extra{
      raw_info: %{
        token: conn.private.linkedin_token,
        user: conn.private.linkedin_user,
      }
    }
  end

  defp fetch_user(conn, token) do
    conn = put_private(conn, :linkedin_token, token)

    case Ueberauth.Strategy.LinkedIn.OAuth.get(token, @user_url) do
      {:ok, %OAuth2.Response{status_code: 200, body: user}} ->
        put_private(conn, :linkedin_user, user)

      {:ok, %OAuth2.Response{status_code: status_code, body: _body}} when status_code not in 200..299 ->
        set_errors!(conn, [error("LinkedIn API error", "Failed to fetch user data")])

      {:error, %OAuth2.Response{status_code: 401, body: _body}} ->
        set_errors!(conn, [error("token", "unauthorized")])

      {:error, %OAuth2.Response{status_code: 403, body: body}} ->
        set_errors!(conn, [error("token", body["message"])])

      {:error, %OAuth2.Error{reason: reason}} ->
        set_errors!(conn, [error("OAuth2", reason)])

      {:error, _} ->
        set_errors!(conn, [error("OAuth2", "Unknown error")])
    end
  end

  defp option(conn, key) do
    Keyword.get(options(conn), key, Keyword.get(default_options(), key))
  end

  defp with_scopes(opts, conn) do
    scopes = conn.params["scope"] || option(conn, :default_scope)
    opts |> Keyword.put(:scope, scopes)
  end

  defp with_redirect_uri(opts, conn) do
    if option(conn, :send_redirect_uri) do
      opts |> Keyword.put(:redirect_uri, callback_url(conn))
    else
      opts
    end
  end

  defp fetch_uid(field, conn) do
    conn.private.linkedin_user[field]
  end
end
