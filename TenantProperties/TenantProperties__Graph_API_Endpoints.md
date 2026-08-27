# Properties (Organization Profile) — Microsoft Graph API Endpoints

Covers the "Properties" page in the Entra admin center — the tenant's core organizational profile: name, technical/security notification contacts, privacy statement URL, and marketing email settings. Backed by the `organization` resource (the same object used for `onPremisesSyncEnabled`, `subscribedSkus` context, etc. seen in earlier folders).

Base URL: `https://graph.microsoft.com/{version}/organization`

> 💡 `organization` is defined as a collection of **exactly one record** — the tenant itself — but must still be addressed by its ID (the tenant ID) when reading/updating specific properties or calling PATCH.

## Core

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List organization | GET | `/organization` | same | Returns a collection with exactly one entry — the current tenant's organization object. |
| Get organization | GET | `/organization/{id}` | same | Retrieves the full organization object by tenant ID. |
| Update organization | PATCH | `/organization/{id}` | same | Updates one or more of the properties below. Only submitted fields are changed. |

## Key Properties

| Property | Type | Description |
|---|---|---|
| `displayName` | String | The tenant's display name shown throughout the admin center and sign-in screens. |
| `id` | String | The tenant ID (GUID) — also the record's key. |
| `verifiedDomains` | Collection | All domains verified for the tenant (cross-reference with `CustomDomainNames.md`). |
| `technicalNotificationMails` | String collection | Email(s) that receive technical notifications about the tenant (e.g. certificate expiry warnings). Not nullable. |
| `securityComplianceNotificationMails` | String collection | Email(s) for security/compliance-related notifications. |
| `securityComplianceNotificationPhones` | String collection | Phone number(s) for security/compliance notifications. |
| `marketingNotificationEmails` | String collection | Email(s) that receive marketing communications from Microsoft about the tenant's subscriptions. Not nullable. |
| `privacyProfile` | Object | Contains `statementUrl` (link to your org's privacy statement) and `contactEmail`. |
| `onPremisesSyncEnabled` | Boolean | Whether directory sync is active — see `MicrosoftEntraConnect.md`. |
| `onPremisesLastSyncDateTime` | DateTime | Last successful sync timestamp — see `MicrosoftEntraConnect.md`. |
| `assignedPlans` | Collection | Service plans/subscriptions assigned to the tenant (read-only summary; full detail lives in `subscribedSkus`, see `Licenses.md`). |
| `businessPhones` | String collection | Tenant's listed business phone number(s). |
| `city` / `state` / `country` / `postalCode` / `street` | String | Tenant's registered address fields. |
| `countryLetterCode` | String | ISO country code for the tenant's registered country. |

## Example update (PATCH body)

Updating technical and security notification contacts:
```json
{
  "technicalNotificationMails": ["it-admin@contoso.com"],
  "securityComplianceNotificationMails": ["security@contoso.com"],
  "privacyProfile": {
    "statementUrl": "https://contoso.com/privacy",
    "contactEmail": "privacy@contoso.com"
  }
}
```

## Common permissions required
- `Organization.Read.All` — read organization profile properties
- `Organization.ReadWrite.All` — update organization profile properties

## Notes
- This is the same singleton pattern as `UserSettings.md`'s `authorizationPolicy` — one record per tenant, but here it's still addressed with an explicit ID (the tenant ID) rather than a fixed path.
- `technicalNotificationMails` and `marketingNotificationEmails` are **not nullable** — attempting to clear them entirely (empty array in some cases) may be rejected; check current Microsoft Learn docs before scripting a full clear.
- For best performance on updates, only include fields that are actually changing — omitted fields keep their existing values, same PATCH behavior as `UserSettings.md`.
- Don't confuse this with `CompanyBranding.md` (visual sign-in customization) or `UserSettings.md` (default user permission toggles) — this folder is specifically the tenant's identity/contact metadata.
