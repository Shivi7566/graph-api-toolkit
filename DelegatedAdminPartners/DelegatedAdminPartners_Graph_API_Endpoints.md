# Delegated Admin Partners (GDAP) — Microsoft Graph API Endpoints

Covers **Granular Delegated Admin Privileges (GDAP)** — used by Microsoft partners (CSPs / resellers) to request scoped, time-bound admin access into a customer tenant, replacing the old "Admin On Behalf Of" (AOBO) full-access model.

> ⚠️ **This entire API surface is beta-only** — there is no v1.0 equivalent yet. Not recommended for production automation without accounting for breaking changes.

Base URL: `https://graph.microsoft.com/beta/tenantRelationships/delegatedAdminRelationships`

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| List relationships | GET | `/tenantRelationships/delegatedAdminRelationships` | Lists all delegated admin (GDAP) relationships for the partner tenant. |
| Get a relationship | GET | `/tenantRelationships/delegatedAdminRelationships/{id}` | Retrieves details of a specific relationship, including status and duration. |
| Create relationship | POST | `/tenantRelationships/delegatedAdminRelationships` | Initiates a new relationship request to a customer tenant. Requires `displayName`, `duration` (ISO 8601, e.g. `P730D`), and `customer.tenantId`. |
| Delete relationship | DELETE | `/tenantRelationships/delegatedAdminRelationships/{id}` | Deletes a relationship — only allowed while status is still `created` (not yet approved by the customer). Requires `If-Match` ETag header. |
| List access assignments | GET | `/tenantRelationships/delegatedAdminRelationships/{id}/accessAssignments` | Lists the specific admin roles granted under this relationship. |
| Create access assignment | POST | `/tenantRelationships/delegatedAdminRelationships/{id}/accessAssignments` | Assigns specific Entra roles (e.g. Helpdesk Admin, User Admin) to a partner security group within the relationship's scope. |
| Delete access assignment | DELETE | `/tenantRelationships/delegatedAdminRelationships/{id}/accessAssignments/{id}` | Removes a specific role assignment from the relationship. Requires `If-Match` ETag header. |
| Create relationship request | POST | `/tenantRelationships/delegatedAdminRelationships/{id}/requests` | Submits a lifecycle request against the relationship — e.g. approve, terminate, or lock for approval. |
| Get relationship request | GET | `/tenantRelationships/delegatedAdminRelationships/{id}/requests/{id}` | Checks the status of a lifecycle request (e.g. termination in progress). |
| Get relationship operation | GET | `/tenantRelationships/delegatedAdminRelationships/{id}/operations/{id}` | Tracks long-running async operations tied to the relationship (e.g. role assignment propagation). |

## Related: Reseller relationships (indirect providers/resellers)
| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| Get reseller relationship | GET | `/tenantRelationships/resellerDelegatedAdminRelationships/{id}` | Represents delegated privileges an indirect reseller has, created on their behalf by an indirect provider. Inherits from `delegatedAdminRelationship`. |

## Relationship lifecycle (status values)
`created` → `approvalPending` → `approved` (active) → `terminationRequested` → `terminated`
Only relationships still in `created` status can be deleted outright; anything approved must go through a termination request instead.

## Common permissions required
- `DelegatedAdminRelationship.ReadWrite.All` — create/manage GDAP relationships and access assignments
- `DelegatedAdminRelationship.Read.All` — read-only visibility into relationships

## Notes
- GDAP relationships require an `If-Match` (ETag) header on delete calls — fetch the current ETag via GET first, or the delete will fail.
- Duration is capped by Microsoft policy (commonly up to 2 years / `P730D`) — check current partner center limits before scripting renewals.
- This replaces the legacy "Admin On Behalf Of" (AOBO) relationships, which granted full Global Admin-equivalent access; GDAP is scoped to only the specific roles assigned via `accessAssignments`, which is the security-recommended model going forward.
