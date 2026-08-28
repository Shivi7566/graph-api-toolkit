# Audit Logs — Microsoft Graph API Endpoints

Covers Entra ID's **directory audit logs** — a record of every admin/system action across user, group, app, device management, PIM, access reviews, terms of use, identity protection, and password management. For sign-in activity specifically, see `SignInLogs.md`.

Base URL: `https://graph.microsoft.com/{version}/auditLogs/`

## Directory Audits

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List directory audits | GET | `/auditLogs/directoryAudits` | same | Lists all audit log entries — one per admin/system action performed in the tenant. |
| Get a directory audit | GET | `/auditLogs/directoryAudits/{id}` | same | Retrieves a specific audit log entry's full details. |
| Filter by activity | GET | `/auditLogs/directoryAudits?$filter=activityDisplayName eq 'Add user'` | same | Narrows results to a specific type of action. |
| Filter by date range | GET | `/auditLogs/directoryAudits?$filter=activityDateTime ge 2026-08-01T00:00:00Z and activityDateTime le 2026-08-28T00:00:00Z` | same | Scopes results to a specific time window. |
| Filter by initiating user | GET | `/auditLogs/directoryAudits?$filter=initiatedBy/user/id eq '{userId}'` | same | Shows only actions performed by a specific admin/user. |

## Custom Security Attribute Audit Logs

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List custom sec. attribute audits | GET | Not available in v1.0 | `/auditLogs/customSecurityAttributeAudits` | Lists changes specifically to custom security attributes (see `CustomSecurityAttributes.md`) — separate feed from general directory audits, single category `AttributeManagement`. |
| Get a custom sec. attribute audit | GET | Not available in v1.0 | `/auditLogs/customSecurityAttributeAudits/{id}` | Retrieves a specific custom security attribute change event. |

## Key `directoryAudit` properties
| Property | Type | Description |
|---|---|---|
| `activityDateTime` | DateTimeOffset | When the activity occurred (UTC). Supports `$filter` (`eq`, `ge`, `le`). |
| `activityDisplayName` | String | The action name, e.g. "Add user", "Update application". Supports `$filter` (`eq`, `startswith`). |
| `category` | String | High-level grouping, e.g. `UserManagement`, `ApplicationManagement`, `RoleManagement`. |
| `result` | String | `success`, `failure`, `timeout`, or `unknownFutureValue`. |
| `initiatedBy` | Object | Who/what triggered the action — either a `user` or an `app`. |
| `targetResources` | Collection | The object(s) affected by the action, with `modifiedProperties` showing old/new values. |
| `correlationId` | String | Unique ID linking related log entries across services — useful for tracing a multi-step operation. |
| `additionalDetails` | Key-value collection | Extra context specific to the activity type. |

## Purview Audit (Microsoft 365-wide, cross-service)

For audit data spanning beyond Entra ID (Exchange, SharePoint, OneDrive, Dynamics, Endpoint DLP), Microsoft Graph exposes the **Purview Audit Search API** as a separate, newer system:

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| Create audit log query | POST | `/security/auditLog/queries` | Submits a search job across one or more Microsoft 365 services, filtered by date range, operations, keyword, or specific object/user. |
| Get a query | GET | `/security/auditLog/queries/{id}` | Checks status of a submitted query (queries run asynchronously). |
| List query records | GET | `/security/auditLog/queries/{id}/records` | Retrieves the actual audit records once the query has completed. |

## Common permissions required
- `AuditLog.Read.All` — read directory audit logs (paired with `Directory.Read.All` for full context on referenced objects)
- `CustomSecAttributeAuditLogs.Read.All` — read custom security attribute-specific audit logs
- `AuditLogsQuery-Entra.Read.All` (or the broader `AuditLogsQuery.Read.All`) — Purview Audit Search for Entra-specific records
- Additional `AuditLogsQuery-{Service}.Read.All` permissions per M365 service if querying beyond Entra via Purview

## Notes
- Directory audit log retention is governed by Microsoft's data retention policies (commonly 30 days without an Entra ID P1/P2 license, longer with one) — export/archive logs externally (e.g. to a SIEM) if longer retention is needed.
- `targetResources[].modifiedProperties` is the most useful field for actually seeing **what changed** (old value → new value) in a given action — don't stop at just the activity name.
- The Purview Audit Search API (`/security/auditLog/queries`) is the modern, broader replacement path for cross-service audit needs and runs **asynchronously** — always poll the query status before trying to read `/records`.
