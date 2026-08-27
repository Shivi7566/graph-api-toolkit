# Microsoft Entra Cloud Sync — Microsoft Graph API Endpoints

Cloud Sync syncs on-premises AD to Entra ID using a **lightweight on-prem agent**, with sync logic running in the cloud — unlike Microsoft Entra Connect (see `MicrosoftEntraConnect.md`), which runs the full sync engine on-prem. Cloud Sync is built on the same general-purpose **provisioning/synchronization job engine** used for app provisioning (`Provisioning.md`) and cross-tenant sync (`CrossTenantSynchronization.md`) — just configured against an "Active Directory to Microsoft Entra ID" template instead of a SaaS app.

Base URL: `https://graph.microsoft.com/{version}/servicePrincipals/{id}/synchronization/`

> 💡 Cloud Sync jobs live under the **service principal** representing the "Microsoft Entra Connect Provisioning" application/agent in your tenant — you first need that service principal's ID before calling any of the endpoints below (see `EnterpriseApplications.md` for how to find/list service principals).

## Synchronization Jobs

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List jobs | GET | `/servicePrincipals/{id}/synchronization/jobs` | same | Lists sync jobs configured on this service principal (a Cloud Sync configuration shows up as a job here). |
| Get a job | GET | `/servicePrincipals/{id}/synchronization/jobs/{jobId}` | same | Retrieves a specific job's status, including `status.quarantine` if the job is currently paused due to repeated errors. |
| Create job | POST | `/servicePrincipals/{id}/synchronization/jobs` | same | Creates a new sync job from a template (e.g. `AD2AADProvisioning` for Cloud Sync). |
| Start job | POST | `/servicePrincipals/{id}/synchronization/jobs/{jobId}/start` | same | Starts (or restarts) a sync job's regular cycle. |
| Pause job | POST | `/servicePrincipals/{id}/synchronization/jobs/{jobId}/pause` | same | Pauses a running job without deleting its configuration. |
| Restart job | POST | `/servicePrincipals/{id}/synchronization/jobs/{jobId}/restart` | same | Restarts a job, optionally with a full resync of all objects (clears watermark/state). |
| Delete job | DELETE | `/servicePrincipals/{id}/synchronization/jobs/{jobId}` | same | Removes the sync job entirely. |
| Validate credentials | POST | `/servicePrincipals/{id}/synchronization/jobs/{jobId}/validateCredentials` | same | Tests that provided (or previously saved) credentials can connect to the target system before enabling the job. |
| Provision on demand | POST | `/servicePrincipals/{id}/synchronization/jobs/{jobId}/provisionOnDemand` | same | Manually triggers sync for one or more specific objects (e.g. test a single user) without waiting for the next scheduled cycle. |

## Job Schema

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get job schema | GET | `/servicePrincipals/{id}/synchronization/jobs/{jobId}/schema` | same | Retrieves the attribute mapping rules between source (on-prem AD) and target (Entra ID). |
| Update job schema | PUT | `/servicePrincipals/{id}/synchronization/jobs/{jobId}/schema` | same | Updates attribute mappings, scoping filters, or matching rules used by the job. |

## Credentials & Connectivity

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Set connectivity credentials | PUT | `/servicePrincipals/{id}/synchronization/secrets` | same | Provides credentials/settings for connecting to the target directory (e.g. domain, service account). |
| List templates | GET | `/servicePrincipals/{id}/synchronization/templates` | same | Lists available sync job templates for this service principal (for Cloud Sync, look for the AD-to-Entra template). |

## Job Status Monitoring

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get job status | GET (part of Get job) | `/servicePrincipals/{id}/synchronization/jobs/{jobId}?$select=status` | same | Retrieves `status` object: sync progress, error counts, quarantine reason, last execution details. |

## Common permissions required
- `Synchronization.ReadWrite.All` — full read/write on sync jobs, schema, and credentials
- `Application.ReadWrite.OwnedBy` — narrower alternative when the calling app owns the target service principal

## Roles required (delegated scenarios)
- **Hybrid Identity Administrator** — minimum role specifically required to configure Microsoft Entra Cloud Sync (distinct from Application/Cloud Application Administrator, which covers general app provisioning instead).

## Notes
- A job that repeatedly errors gets automatically **quarantined** (paused) by the service — check `status.quarantine` on the job object when troubleshooting a sync that appears stuck.
- `provisionOnDemand` is genuinely useful for testing — point it at a single test user/group before trusting a new Cloud Sync configuration with the full directory.
- Don't confuse this with Entra Connect: Cloud Sync agents are lightweight and support multiple disconnected AD forests, while Entra Connect is a single heavier sync engine typically used for one larger/complex forest.
