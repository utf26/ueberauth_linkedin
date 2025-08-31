# Überauth LinkedIn

[![License][license-img]][license]

[license-img]: http://img.shields.io/badge/license-MIT-brightgreen.svg
[license]: http://opensource.org/licenses/MIT

> LinkedIn v2 OAuth2 strategy for Überauth.

## Installation

1. Setup your application at [LinkedIn Developers](https://developer.linkedin.com/).

1. Add `:ueberauth_linkedin` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ueberauth_linkedin, "~> 1.0.0", hex: :ueberauth_linkedin_modern}]
    end
    ```

1. Add LinkedIn to your Überauth configuration:

    ```elixir
    config :ueberauth, Ueberauth,
      providers: [
        linkedin: {Ueberauth.Strategy.LinkedIn, []}
      ]
    ```

1.  Update your provider configuration:

    ```elixir
    config :ueberauth, Ueberauth.Strategy.LinkedIn.OAuth,
      client_id: System.get_env("LINKEDIN_CLIENT_ID"),
      client_secret: System.get_env("LINKEDIN_CLIENT_SECRET"),
      redirect_uri: System.get_env("LINKEDIN_REDIRECT_URI")
    ```

1.  Include the Überauth plug in your controller:

    ```elixir
    defmodule MyApp.AuthController do
      use MyApp.Web, :controller
      plug Ueberauth
      ...
    end
    ```

1.  Create the request and callback routes if you haven't already:

    ```elixir
    scope "/auth", MyApp do
      pipe_through :browser

      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
      post "/:provider/callback", AuthController, :callback
    end
    ```

1. Your controller needs to implement callbacks to deal with `Ueberauth.Auth` and `Ueberauth.Failure` responses.

For an example implementation see the [Überauth Example](https://github.com/ueberauth/ueberauth_example) application.

## Calling

Depending on the configured url you can initiate the request through:

    /auth/linkedin?state=csrf_token_here

Or with scope:

    /auth/linkedin?state=csrf_token_here&scope=r_emailaddress

By default the requested scope is "openid profile email". Scope can be configured either explicitly as a `scope` query value on the request path or in your configuration:

```elixir
config :ueberauth, Ueberauth,
  providers: [
    linkedin: {Ueberauth.Strategy.LinkedIn, [default_scope: "openid profile email"]}
  ]
```

## License

Please see [LICENSE](https://github.com/utf26/ueberauth_linkedin/blob/main/LICENSE) for licensing details.
