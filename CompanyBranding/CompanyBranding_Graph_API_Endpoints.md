# Company Branding — Microsoft Graph API Endpoints

Customizes the tenant sign-in experience (logos, background, custom CSS, sign-in page text) — the same branding users see across Microsoft 365 login screens. Supports per-locale (language) customization on top of a single default branding.

Base URL: `https://graph.microsoft.com/{version}/organization/{organizationId}/branding`

> 💡 Requires **Microsoft Entra ID P1 or P2** license. Minimum role: **Organizational Branding Administrator**.

## Default Branding

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get default branding | GET | `/organization/{id}/branding` | same | Retrieves text-based properties of the default branding (e.g. `usernameHintText`, `signInPageText`). Requires `Accept-Language: 0` or `default` header. Does **not** return image/CSS (Stream) properties — use localizations for those. |
| Update default branding | PATCH | `/organization/{id}/branding` | same | Updates text-based properties of the default branding. |
| Update an image/CSS property | PUT | `/organization/{id}/branding/localizations/0/{propertyName}` | same | Uploads binary content (e.g. `bannerLogo`, `backgroundImage`, `customCSS`) directly to the property endpoint — image/CSS fields are `Stream` type and require a dedicated PUT with the raw file as the request body, not a normal PATCH. |

## Localizations (per-language branding)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List localizations | GET | `/organization/{id}/branding/localizations` | same | Retrieves all locale-specific branding objects, including the default (`id: "0"`). |
| Get a localization | GET | `/organization/{id}/branding/localizations/{locale}` | same | Retrieves branding for one specific locale (e.g. `fr-FR`). |
| Create localization | POST | `/organization/{id}/branding/localizations` | same | Creates a new locale-specific branding. If default branding doesn't yet exist, creating the first localization also creates it (one-time). |
| Update localization | PATCH | `/organization/{id}/branding/localizations/{locale}` | same | Updates text-based properties for that locale. |
| Delete localization | DELETE | `/organization/{id}/branding/localizations/{locale}` | same | Removes a locale-specific branding, falling back to default for that language. |

## Key properties
| Property | Type | Purpose |
|---|---|---|
| `bannerLogo` | Stream | Logo shown on the sign-in page header. PNG/JPEG. |
| `squareLogo` | Stream | Logo shown in compact/tile UI contexts. |
| `backgroundImage` | Stream | Full sign-in page background image. |
| `backgroundColor` | String | RGB fallback color if no background image is set. |
| `customCSS` | Stream | Custom CSS file for the sign-in page. `.css` only, max 25KB. |
| `signInPageText` | String | Custom text shown on the sign-in page. |
| `usernameHintText` | String | Placeholder hint text shown in the username field. |
| `customPrivacyAndCookiesText` / `customPrivacyAndCookiesUrl` | String | Overrides the footer "Privacy and Cookies" link text/URL. |
| `customTermsOfUseText` | String | Overrides the footer "Terms of Use" link text. |
| `customForgotMyPasswordText` | String | Overrides the "Forgot my password" link text. |
| `customCannotAccessYourAccountText` / `...Url` | String | Overrides the "Can't access your account?" link. |
| `id` | String | Locale identifier, e.g. `en-US` (RFC 1766 format). Default branding always uses `0` or `default`. |

## Common permissions required
- `Organization.Read.All` — read branding
- `Organization.ReadWrite.All` — create/update/delete branding and localizations

## Notes
- Text properties (strings) update via a normal `PATCH` on the branding/localization object. **Image and CSS properties are `Stream` type and must be uploaded via a separate `PUT` request** directly to that property's own sub-URL, with the raw file bytes as the body and the correct `Content-Type` header (e.g. `image/jpeg`).
- Branding doesn't apply when a user signs in with a **personal Microsoft account** — only work/school account sign-ins reflect your custom branding.
- If only some elements are set (e.g. logo but no background image), unset elements fall back to Microsoft's defaults — you don't need to configure every property.
- Creating the very first localization also creates the default branding object automatically if one doesn't already exist — you don't need a separate initialization step.
