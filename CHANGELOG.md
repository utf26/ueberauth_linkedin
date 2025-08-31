# Changelog

## v1.0.0 - 2025-08-31

### Features

- Initial public release of `ueberauth_linkedin` with LinkedIn OAuth2 support via Überauth
- Supports modern LinkedIn v2 API with `openid profile email` scopes
- Secure `basic_auth` token exchange
- Graceful handling of token revocation and 401 errors

### Fixes & Improvements

- Fix invalid pattern matching for 401 responses (`REVOKED_ACCESS_TOKEN`) [#3](https://github.com/utf26/ueberauth_linkedin/pull/3)
- Use query params for token exchange to resolve intermittent LinkedIn errors [#5](https://github.com/utf26/ueberauth_linkedin/pull/5)

---

## v0.10.8 - 2024-04-05

### Enhancements

- Fixed: redirect_uri not sent in callback phase if not configured explicitly

---

## v0.10.7 - 2024-02-02

### Enhancements

- Updated the package for compatibility with Elixir 1.15, addressing the need for modernization from the last update in 2016.
- Add support for Ueberauth ~0.10

---