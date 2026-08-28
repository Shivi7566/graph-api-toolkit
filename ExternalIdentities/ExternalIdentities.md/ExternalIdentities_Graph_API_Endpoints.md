# External Identities — Microsoft Graph API Endpoints

Covers B2B guest invitations, identity providers (social/built-in), and cross-tenant access policies.

Base URL: `https://graph.microsoft.com/{version}/`

## B2B Guest Invitations

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Send invitation | POST | `/invitations` | `/invitations` | Invites an external user to collaborate. Requires `invitedUserEmailAddress` and `inviteRedirectUrl`. Creates a guest user object. |
| Get invitation result | — | Response body of the POST above | same | Returns `invitedUser` (the created guest user object) and `inviteRedeemUrl`. |
| Resend / update invitation | — | Not directly supported | — | Re-invite by sending a new POST to `/invitations` for the same email, or update the guest user's `invitedUserMessageInfo` via `/users/{id}`. |
| List guest users | GET | `/users?$filter=userType eq 'Guest'` | same | Lists all guest (external) user accounts in the tenant. |
| Convert / manage guest status | PATCH | `/users/{id}` | `/users/{id}` | Update guest-specific properties like `externalUserState` (`PendingAcceptance` / `Accepted`). |

## Identity Providers (Social & Built-in, for B2B guest sign-in)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List identity providers | GET | `/identity/identityProviders` | `/identity/identityProviders` | Lists configured identity providers (Google, Facebook, etc.) available for B2B guest sign-in. |
| Get identity provider | GET | `/identity/identityProviders/{id}` | `/identity/identityProviders/{id}` | Retrieves a specific identity provider's configuration. |
| Create identity provider | POST | `/identity/identityProviders` | `/identity/identityProviders` | Adds a new social identity provider (e.g. Google) with `clientId`/`clientSecret`. |
| Update identity provider | PATCH | `/identity/identityProviders/{id}` | `/identity/identityProviders/{id}` | Updates client credentials for an existing identity provider. |
| Delete identity provider | DELETE | `/identity/identityProviders/{id}` | `/identity/identityProviders/{id}` | Removes an identity provider. |

## Cross-Tenant Access Policy (B2B Collaboration / B2B Direct Connect)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get default cross-tenant policy | GET | `/policies/crossTenantAccessPolicy/default` | same | Retrieves the tenant's default inbound/outbound B2B settings. |
| Update default cross-tenant policy | PATCH | `/policies/crossTenantAccessPolicy/default` | same | Updates default B2B collaboration / direct connect settings. |
| List partner configurations | GET | `/policies/crossTenantAccessPolicy/partners` | same | Lists per-partner (per-tenant) custom access configurations. |
| Create partner configuration | POST | `/policies/crossTenantAccessPolicy/partners` | same | Adds a custom configuration for a specific partner tenant by `tenantId`. |
| Update partner configuration | PATCH | `/policies/crossTenantAccessPolicy/partners/{tenantId}` | same | Updates inbound/outbound settings for a specific partner tenant. |
| Delete partner configuration | DELETE | `/policies/crossTenantAccessPolicy/partners/{tenantId}` | same | Removes a partner-specific configuration (reverts to default policy for that tenant). |
| Evaluate dynamic membership (not applicable here) | — | — | — | *(N/A — see Groups.md)* |

## External Collaboration Settings (legacy domain allow/block lists)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get B2B collaboration domain policy | GET | Not available | `/legacy/policies` (B2BManagementPolicy) | Manages the "allow/deny invitations to specified domains" legacy setting. Microsoft recommends migrating to cross-tenant access policies instead. |

## Common permissions required
- `User.Invite.All` — send B2B invitations
- `IdentityProvider.ReadWrite.All` — manage identity providers
- `Policy.ReadWrite.CrossTenantAccess` — manage cross-tenant access policy
- `Policy.Read.All` — read-only access to policies

## Notes
- Guest users created via invitation show up as regular user objects with `userType = Guest` — manage them using the same `/users` endpoints documented in `Users.md`.
- The legacy domain allow/deny list (`B2BManagementPolicy`) is being phased out in favor of cross-tenant access policies — avoid building new automation against it.
- Cross-tenant access policy changes can lock out external collaboration tenant-wide if misconfigured — test with a single partner configuration before applying tenant-wide defaults.
