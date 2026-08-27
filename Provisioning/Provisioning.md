# Provisioning — Microsoft Graph API Endpoints

Covers the general-purpose **application provisioning** scenarios: syncing users/groups from Entra ID out to SaaS apps (Dropbox, Salesforce, ServiceNow, etc.), HR-driven provisioning (Workday/SuccessFactors → Entra ID), and API-driven (SCIM) inbound provisioning.

> 💡 All provisioning scenarios (including Cloud Sync and Cross-Tenant Sync) share the **same underlying job engine** — `servicePrincipals/{id}/synchronization/jobs`, already fully documented in `CloudSync.md` (start/pause/restart/schema/credentials/provisionOnDemand). This file covers what's specific to app/HR/API-driven provisioning: **provisioning logs** and **inbound SCIM provisioning**.

Base URL: `https://graph.microsoft.com/{version}/`

## Provisioning Logs (audit trail of what synced)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List provisioning logs | GET | `/auditLogs/provisioning` | same | Lists individual provisioning events — one entry per object synced (created/updated/deleted) per cycle. |
| Get a provisioning log entry | GET | `/auditLogs/provisioning/{id}` | same | Retrieves details of one provisioning event, including which attributes changed (`modifiedProperties`) and success/failure status. |
| Filter by service principal | GET | `/auditLogs/provisioning?$filter=servicePrincipalId eq '{id}'` | same | Scopes provisioning logs to a specific app's sync job. |
| Filter by status | GET | `/auditLogs/provisioning?$filter=provisioningStatus eq 'failure'` | same | Useful for quickly surfacing sync failures for troubleshooting. |

## Application (SaaS) Provisioning Setup

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List available templates | GET | `/servicePrincipals/{id}/synchronization/templates` | same | Lists provisioning templates available for this app (e.g. pre-built connectors for gallery apps). *(Same endpoint as documented in CloudSync.md.)* |
| Configure attribute mappings | PUT | `/servicePrincipals/{id}/synchronization/jobs/{jobId}/schema` | same | Defines which Entra ID attributes map to which target app attributes. *(See CloudSync.md for full schema details.)* |

## HR-Driven Provisioning (Workday / SuccessFactors)

| Action | Method | Notes |
|---|---|---|
| Job setup | Same `synchronization/jobs` endpoints as above | HR-driven provisioning uses the same job engine, with the source being Workday/SuccessFactors instead of Entra ID or AD. |
| Full sync trigger | `POST .../jobs/{jobId}/restart` | Full sync (re-fetch **all** workers from Workday) happens automatically on first enable, and can be manually re-triggered via job restart. |
| Common target attributes | — | Frequently mapped fields include `employeeHireDate`, `employeeType`, `employeeOrgData` — readable/writable on the `user` object via `/users/{id}?$select=employeeHireDate,employeeType,employeeOrgData`. |

## API-Driven (Inbound SCIM) Provisioning

Lets external systems push identity data **into** Entra ID via a SCIM-compliant bulk endpoint — useful for custom/home-grown HR or identity sources that aren't Workday/SuccessFactors.

| Action | Method | Endpoint | Description |
|---|---|---|---|
| Send bulk SCIM request | POST | Provisioning app's dedicated URL (retrieved from the app's "API-driven provisioning" overview page in the admin center — not a fixed Graph path) | Submits a bulk request using SCIM Enterprise User Schema. Requires header `Content-Type: application/scim+json`. |
| Check bulk request status | GET | URL returned in the `Location` response header from the POST above | Points to the corresponding provisioning logs entry to verify how the bulk request was processed. |

## Common permissions required
- `Synchronization.ReadWrite.All` — manage sync jobs (shared with Cloud Sync/Cross-Tenant Sync)
- `AuditLog.Read.All` — read provisioning logs
- Directory role: **Application Administrator** or **Cloud Application Administrator** — minimum role to configure app provisioning or HR-driven provisioning (note: this differs from Cloud Sync, which requires **Hybrid Identity Administrator** instead — see `CloudSync.md`)

## Notes
- Provisioning logs are the single best place to debug "why didn't this user sync correctly" — always check `modifiedProperties` and `provisioningStatus` on the specific object before assuming the job itself is broken.
- "Full sync" (re-evaluating every source object against provisioning rules) happens automatically the first time a job is enabled, and again whenever a job is restarted from the admin center or via the `restart` endpoint — this can be slow/heavy on large directories, so avoid unnecessary restarts on production jobs.
- API-driven (SCIM) provisioning doesn't have a fixed, guessable Graph endpoint — each provisioning app instance gets a unique URL you retrieve from its own overview page; don't hardcode a path, always look it up per-app.
