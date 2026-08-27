# Licenses — Microsoft Graph API Endpoints

Covers tenant subscription SKUs, direct user licensing, and group-based licensing (assigning licenses to a group so all members inherit them).

Base URL: `https://graph.microsoft.com/{version}/`

## Tenant Subscriptions (SKUs)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List subscribed SKUs | GET | `/subscribedSkus` | `/subscribedSkus` | Lists all license SKUs (subscriptions) purchased/available in the tenant, including total and consumed unit counts. |
| Get a subscribed SKU | GET | `/subscribedSkus/{id}` | `/subscribedSkus/{id}` | Retrieves details of one SKU, including its `servicePlans` (the individual features bundled inside it). |

## Direct User Licensing

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Assign/remove license | POST | `/users/{id}/assignLicense` | same | Adds and/or removes licenses on a specific user in one call. Body takes `addLicenses` (array of `assignedLicense`, each with a `skuId` and optional `disabledPlans`) and `removeLicenses` (array of `skuId` GUIDs). |
| Assign/remove license (self) | POST | `/me/assignLicense` | same | Same operation, but scoped to the signed-in user. |
| Reprocess license assignment | POST | Not available in v1.0 | `/users/{id}/reprocessLicenseAssignment` | Re-runs group-based license assignment for a user — useful after resolving a licensing conflict/error state. |
| View a user's licenses | GET | `/users/{id}?$select=assignedLicenses` | same | Retrieves the licenses currently assigned to a user (also documented in `Users.md`). |
| View license assignment states | GET | Not available in v1.0 | `/users/{id}?$select=licenseAssignmentStates` | Shows per-license assignment status, including any errors and which group(s) triggered the assignment. |

## Group-Based Licensing

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Assign/remove license on group | POST | `/groups/{id}/assignLicense` | same | Assigns licenses to a group — every current and future member automatically inherits them. Same `addLicenses`/`removeLicenses` body shape as the user version. |
| View a group's licenses | GET | `/groups/{id}?$select=assignedLicenses` | same | Retrieves licenses currently assigned to the group (also documented in `Groups.md`). |

## Common permissions required
- `LicenseAssignment.ReadWrite.All` — least-privileged permission for assigning/removing licenses on users or groups
- `Directory.ReadWrite.All` / `Group.ReadWrite.All` — higher-privileged alternatives that also work
- `Organization.Read.All` — read tenant subscribed SKUs

## Notes
- `disabledPlans` lets you assign a license (e.g. Microsoft 365 E3) while turning off specific service plans within it (e.g. disable Yammer but keep Exchange/Teams) — useful for cost or compliance control without needing a separate SKU.
- Group-based licensing is generally preferred over direct user assignment at scale — add/remove group membership and licensing follows automatically, instead of scripting individual `assignLicense` calls per user.
- License assignment via group can fail per-user for specific reasons (e.g. conflicting service plans, missing usage location) — check `licenseAssignmentStates` on the affected user to see the actual error before reprocessing.
- Assigning a license to a user requires `usageLocation` to be set on that user object first — an unset `usageLocation` is a very common cause of assignment failures.
