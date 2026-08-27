# Microsoft Entra Connect — Microsoft Graph API Endpoints

Covers the tenant-wide **on-premises directory synchronization** configuration — the Graph-visible settings/status behind Microsoft Entra Connect (formerly Azure AD Connect), the on-prem tool that syncs on-prem Active Directory to Entra ID.

> 💡 Entra Connect itself is an **on-premises installed application**, not something you configure entirely through Graph — most day-to-day sync operation (scheduling, running cycles) happens on the server itself via PowerShell (`Start-ADSyncSyncCycle`, etc.). Graph exposes the tenant-side configuration and status this on-prem tool writes back.

Base URL: `https://graph.microsoft.com/{version}/directory/onPremisesSynchronization`

## Configuration & Status

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get sync configuration | GET | `/directory/onPremisesSynchronization` | same | Retrieves the tenant's on-premises directory sync configuration and status collection. |
| Get a specific sync config entry | GET | `/directory/onPremisesSynchronization/{id}` | same | Retrieves one `onPremisesDirectorySynchronization` object (most tenants have exactly one). |
| Update sync configuration | PATCH | `/directory/onPremisesSynchronization/{id}` | same | Updates `configuration` sub-properties, notably accidental deletion prevention thresholds. |

## Key properties inside `onPremisesDirectorySynchronization`
| Property | Purpose |
|---|---|
| `features` | Feature flags for what's synced/enabled (e.g. password hash sync, password writeback, device writeback, user writeback). |
| `configuration.accidentalDeletionPrevention` | Safety threshold — blocks a sync cycle from deleting more than a configured percentage of objects in one run, to catch runaway/misconfigured sync jobs. |

## Related tenant-wide organization data (read via `/organization`)

| Action | Method | Endpoint | Description |
|---|---|---|---|
| Check directory sync enabled | GET | `/organization?$select=onPremisesSyncEnabled` | Quick check on whether the tenant has directory sync enabled at all (`true`/`false`/`null` if never configured). |
| Check last sync time | GET | `/organization?$select=onPremisesLastSyncDateTime` | Timestamp of the most recent successful sync cycle — useful for monitoring/alerting if sync has stalled. |

## Per-object sync metadata (visible on synced users/groups/devices)
| Property | Applies to | Purpose |
|---|---|---|
| `onPremisesSyncEnabled` | user, group, device | Whether this specific object is actively synced from on-prem. |
| `onPremisesImmutableId` | user | The anchor/matching ID linking the cloud object to its on-prem AD counterpart. |
| `onPremisesSecurityIdentifier` | user, group | The on-prem AD SID of the synced object. |
| `onPremisesDistinguishedName` | user, group | The on-prem AD distinguished name (LDAP path). |
| `onPremisesLastSyncDateTime` | user, group, device | Timestamp of the last time this specific object was synced. |

## Common permissions required
- `Directory.Read.All` — read sync configuration and status
- `Directory.ReadWrite.All` — required to update accidental deletion prevention thresholds
- `Organization.Read.All` — read `onPremisesSyncEnabled`/`onPremisesLastSyncDateTime` from the organization object

## Notes
- Entra Connect Health (monitoring/alerting on sync server health, agent status) is a **separate, portal-centric feature** with limited/no direct Graph API surface — mainly viewed through the Entra admin center rather than scripted.
- For actually **triggering** a sync cycle, that's done on the on-prem Entra Connect server itself via its own PowerShell module — Graph only reports the resulting status back, it doesn't remotely trigger sync runs.
- Distinguish this from `CrossTenantSynchronization.md` (cloud-to-cloud, tenant-to-tenant sync) and `Provisioning.md` (the general-purpose sync job engine used for HR-to-cloud, cloud-to-app scenarios) — Entra Connect specifically means the on-prem AD ↔ cloud hybrid sync.
