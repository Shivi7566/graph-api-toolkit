# Cross-Tenant Synchronization — Microsoft Graph API Endpoints

Cross-tenant synchronization automatically provisions/deprovisions user accounts between Entra ID tenants within the same organization (e.g. across subsidiaries) — built on top of Cross-Tenant Access Policy partner configurations (see `ExternalIdentities.md`) plus the general provisioning job engine (see `Provisioning.md`).

Base URL: `https://graph.microsoft.com/{version}/policies/crossTenantAccessPolicy/`

> ⚠️ Nearly all of this is **beta-only** — no v1.0 support for identity sync policy configuration.

## Identity Synchronization Policy (per-partner)

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| Get sync policy for a partner | GET | `/policies/crossTenantAccessPolicy/partners/{tenantId}/identitySynchronization` | Retrieves the user sync policy (inbound settings) configured for a specific partner tenant. |
| Create/set sync policy for a partner | PUT | `/policies/crossTenantAccessPolicy/partners/{tenantId}/identitySynchronization` | Creates or replaces the sync policy for a partner-specific configuration. Body includes `userSyncInbound.isSyncAllowed`. |
| Delete sync policy for a partner | DELETE | `/policies/crossTenantAccessPolicy/partners/{tenantId}/identitySynchronization` | Removes the sync policy — this does **not** delete already-synced users, only stops future syncs. |
| List all partners with sync policy | GET | `/policies/crossTenantAccessPolicy/partners?$select=tenantId&$expand=identitySynchronization` | Lists all partner configurations, expanding to include each one's sync policy in the same response. |

## Multi-Tenant Organization (MTO) Templates

For organizations managing many tenants at once, templates let you apply a consistent sync policy without configuring each partner individually.

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| Get MTO sync template | GET | `/policies/crossTenantAccessPolicy/templates/multiTenantOrganizationIdentitySynchronization` | Retrieves the default identity sync template applied across the multi-tenant organization. |
| Update MTO sync template | PATCH | `/policies/crossTenantAccessPolicy/templates/multiTenantOrganizationIdentitySynchronization` | Updates sync settings and `templateApplicationLevel` (`newPartners`, `existingPartners`, or both). |
| Get MTO partner config template | GET | `/policies/crossTenantAccessPolicy/templates/multiTenantOrganizationPartnerConfiguration` | Retrieves the default inbound/outbound access template for the MTO. |
| Update MTO partner config template | PATCH | `/policies/crossTenantAccessPolicy/templates/multiTenantOrganizationPartnerConfiguration` | Updates the default B2B collaboration/direct connect settings applied across MTO partners. |

## Underlying Provisioning Job (once sync is configured)

Cross-tenant sync actually runs as a **provisioning job** attached to a service principal, same mechanism as `Provisioning.md` — see that file for job start/stop/status/restart endpoints once a cross-tenant sync configuration has been created via the Entra admin center or the partner APIs above.

## Key concepts
| Term | Meaning |
|---|---|
| `isSyncAllowed` | Boolean switch — `false` stops future syncs from that partner tenant but does **not** remove already-synced users. |
| `templateApplicationLevel` | Controls whether an MTO template auto-applies to `newPartners` only, `existingPartners` only, or both. |
| Inheritance | Any partner-specific setting left `null` inherits from the tenant's default cross-tenant access policy (see `ExternalIdentities.md`). |

## Common permissions required
- `Policy.ReadWrite.CrossTenantAccess` — manage cross-tenant access policy and identity sync policy, both per-partner and MTO templates

## Notes
- Cross-tenant sync is distinct from regular B2B guest invitations — synced users are typically provisioned as **member**-type accounts in the target tenant (not guests), intended for organizations under the same corporate umbrella.
- Disabling `isSyncAllowed` stops new syncing but leaves existing synced users in place — plan a separate deprovisioning step if full removal is required.
- This feature depends on Cross-Tenant Access Policy partner configurations existing first — configure the partner relationship (`ExternalIdentities.md`) before layering sync policy on top of it.
