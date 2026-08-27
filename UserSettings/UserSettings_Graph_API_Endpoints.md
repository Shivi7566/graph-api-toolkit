# User Settings — Microsoft Graph API Endpoints

Covers the tenant-wide "User settings" page in the Entra admin center — controls what regular (non-admin) users are allowed to do by default: register apps, create security groups, create tenants, read other users, and more. All managed through a single `authorizationPolicy` object.

Base URL: `https://graph.microsoft.com/{version}/policies/authorizationPolicy`

## Core

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get authorization policy | GET | `/policies/authorizationPolicy` | same | Retrieves the tenant's single authorization policy object (settings apply tenant-wide, there's only one). |
| Get by ID | GET | `/policies/authorizationPolicy/{id}` | same | Same object, addressed directly by its ID (usually `authorizationPolicy`). |
| Update authorization policy | PATCH | `/policies/authorizationPolicy` | same | Updates one or more settings. Only properties included in the request body are changed — others keep their current value. |

## Top-Level Properties (directly on `authorizationPolicy`)

| Property | Type | Description |
|---|---|---|
| `allowInvitesFrom` | Enum | Who can invite guests: `none`, `adminsAndGuestInviters`, `adminsGuestInvitersAndAllMembers`, `everyone` (default). |
| `allowEmailVerifiedUsersToJoinOrganization` | Boolean | Whether a user can join the tenant just by verifying their email (self-service, no invite). |
| `allowedToSignUpEmailBasedSubscriptions` | Boolean | Whether users can self-sign-up for email-based subscriptions (e.g. Power BI, other freemium M365 products). |
| `allowedToUseSSPR` | Boolean | Tenant-wide switch for whether Self-Service Password Reset is permitted at all (see `PasswordReset.md` for the fuller SSPR picture). |
| `allowUserConsentForRiskyApps` | Boolean | Whether users can consent to apps flagged as risky. **Keep `false`** — Microsoft's explicit recommendation. |
| `blockMsolPowerShell` | Boolean | Disables the legacy MSOnline PowerShell module tenant-wide. Doesn't affect Entra Connect or Microsoft Graph itself. |
| `guestUserRoleId` | GUID | Which role template is granted to new guest users — `User`, `Guest User`, or `Restricted Guest User` role template IDs. |
| `permissionGrantPolicyIdsAssignedToDefaultUserRole` | String collection | Governs whether/how users can consent to app permissions — an empty list disables user consent entirely. |
| `enabledPreviewFeatures` | String collection | Tenant-enabled private preview features. |

## `defaultUserRolePermissions` (nested object — the "can regular users..." switches)

| Property | Type | Corresponds to (admin center) |
|---|---|---|
| `allowedToCreateApps` | Boolean | "Users can register applications" |
| `allowedToCreateSecurityGroups` | Boolean | "Users can create security groups" |
| `allowedToCreateTenants` | Boolean | "Restrict non-admin users from creating tenants" (inverse logic — `false` restricts) |
| `allowedToReadOtherUsers` | Boolean | Whether default users can read other users' directory info. **Microsoft explicitly warns: do not set to `false`** — breaks many normal experiences. |
| `allowedToReadBitlockerKeysForOwnedDevice` | Boolean | Whether a device's registered owner can read their own BitLocker key (also see `Devices.md`). |
| `permissionGrantPoliciesAssigned` | String collection | Format: `managePermissionGrantsForSelf.{policyId}` — which app-consent policy applies to the default user role. |

## Example update (PATCH body)

Disabling app registration for regular users:
```json
{
  "defaultUserRolePermissions": {
    "allowedToCreateApps": false
  }
}
```
Enabling SSPR tenant-wide:
```json
{
  "allowedToUseSSPR": true
}
```

## Common permissions required
- `Policy.Read.All` — read the authorization policy
- `Policy.ReadWrite.Authorization` — update the authorization policy

## Notes
- There is only **one** `authorizationPolicy` object per tenant — unlike Conditional Access or app-specific policies, you're always reading/updating the same singleton resource.
- PATCH only needs to include the fields you're changing — omitted fields keep their existing values (this differs from PUT-style full-replace semantics used elsewhere in Graph).
- `allowedToReadOtherUsers: false` is explicitly called out by Microsoft as something to avoid — it can break core sign-in and collaboration experiences across the tenant, not just a minor restriction.
- LinkedIn connection settings (showing LinkedIn info on user profiles) live under a **different, separate settings area** (`People`/organization profile settings), not this authorization policy — don't conflate the two "User settings"-adjacent features.
