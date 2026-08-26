# Enterprise Applications — Microsoft Graph API Endpoints

"Enterprise Applications" in the Entra admin center are represented in Graph as **service principals** — the tenant-local instance of an app (either your own registered app or a gallery/multi-tenant app someone consented to). Compare with `AppRegistrations.md`, which covers the underlying `application` object.

Base URL: `https://graph.microsoft.com/{version}/servicePrincipals`

## Core CRUD

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List service principals | GET | `/servicePrincipals` | `/servicePrincipals` | Lists all enterprise applications (service principals) in the tenant. |
| Get a service principal | GET | `/servicePrincipals/{id}` | `/servicePrincipals/{id}` | Retrieves details of a specific enterprise app. |
| Create service principal | POST | `/servicePrincipals` | `/servicePrincipals` | Creates a service principal from an existing app registration (`appId`) — effectively "installs" the app into the tenant. |
| Update service principal | PATCH | `/servicePrincipals/{id}` | `/servicePrincipals/{id}` | Updates properties like `accountEnabled`, `appRoleAssignmentRequired`, `tags`. |
| Delete service principal | DELETE | `/servicePrincipals/{id}` | `/servicePrincipals/{id}` | Removes the enterprise app instance from the tenant (does not delete the underlying app registration if it's yours). |

## App Role Assignments (application permissions & user/group access)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List roles assigned to this SP | GET | `/servicePrincipals/{id}/appRoleAssignedTo` | same | Lists users/groups/other SPs granted access (app roles) on this application. |
| Assign app role | POST | `/servicePrincipals/{id}/appRoleAssignedTo` | same | Grants a user, group, or client SP an app role (application permission) on this resource SP. |
| Remove app role assignment | DELETE | `/servicePrincipals/{id}/appRoleAssignedTo/{id}` | same | Revokes access. Recommended over deleting via the principal's own `appRoleAssignments`. |
| List roles this SP has | GET | `/servicePrincipals/{id}/appRoleAssignments` | same | Lists app roles this service principal has itself been granted on other resources. |
| Create app role assignment (client-side) | POST | `/servicePrincipals/{id}/appRoleAssignments` | same | Grants this SP a role/permission on a target resource SP. |

## Delegated Permissions (OAuth2 consent grants)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List delegated permission grants | GET | `/servicePrincipals/{id}/oauth2PermissionGrants` | same | Lists delegated (user-consented) permission grants for this app. |
| Grant admin consent | POST | `/oauth2PermissionGrants` | same | Creates a tenant-wide admin consent grant for delegated permissions. |

## Single Sign-On & Credentials

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Add password credential | POST | `/servicePrincipals/{id}/addPassword` | same | Adds a client secret to the service principal. |
| Remove password credential | POST | `/servicePrincipals/{id}/removePassword` | same | Removes a client secret. |
| Add key credential | POST | `/servicePrincipals/{id}/addKey` | same | Adds a certificate credential. |
| Delete SSO password credentials | POST | Not available in v1.0 | `/servicePrincipals/{id}/deletePasswordSingleSignOnCredentials` | Removes password-based SSO credentials configured for a user/group on this app. |
| Get/set home realm discovery policy | GET / POST / DELETE | Not available in v1.0 | `/servicePrincipals/{id}/homeRealmDiscoveryPolicies` | Manages sign-in redirection policy (e.g. federation routing) for the app. |

## Ownership

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List owners | GET | `/servicePrincipals/{id}/owners` | same | Lists users/SPs who can manage this enterprise app. |
| Add owner | POST | `/servicePrincipals/{id}/owners/$ref` | same | Assigns an owner. |
| Remove owner | DELETE | `/servicePrincipals/{id}/owners/{id}/$ref` | same | Removes an owner. |

## Common permissions required
- `Application.Read.All` / `Application.ReadWrite.All` — read/manage service principals
- `AppRoleAssignment.ReadWrite.All` — manage app role (permission) assignments
- `DelegatedPermissionGrant.ReadWrite.All` — manage delegated permission consent grants
- `Policy.ReadWrite.ApplicationConfiguration` — manage home realm discovery and related app policies

## Notes
- Deleting a service principal disables/removes the app from the tenant, but if it's a multi-tenant or your own registered app, the underlying `application` object survives (see `AppRegistrations.md`) unless deleted separately.
- To grant an app role, you need three IDs: `principalId` (the user/group/SP receiving access), `resourceId` (this service principal's ID), and `appRoleId` (the specific role/permission being granted).
- Recently deleted service principals are recoverable for 30 days via `/directory/deletedItems/{id}/restore`, same pattern as users and groups.
