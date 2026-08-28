# App Registrations — Microsoft Graph API Endpoints

"App Registrations" represent the **application object** — the global definition of an app (its identity across all tenants for multi-tenant apps). Compare with `EnterpriseApplications.md`, which covers the tenant-local `servicePrincipal` instance created from this app.

Base URL: `https://graph.microsoft.com/{version}/applications`

> 💡 Apps can be addressed two ways: `/applications/{id}` using the **Object ID**, or `/applications(appId='{appId}')` using the **Application (Client) ID** — both shown in the Entra admin center's app overview page.

## Core CRUD

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List applications | GET | `/applications` | `/applications` | Lists all app registrations owned/visible in the tenant. |
| Get an application | GET | `/applications/{id}` | `/applications/{id}` | Retrieves a specific app registration's manifest properties. |
| Create application | POST | `/applications` | `/applications` | Registers a new application. Requires `displayName` at minimum. |
| Update application | PATCH | `/applications/{id}` | `/applications/{id}` | Updates manifest properties (redirect URIs, API permissions, sign-in audience, etc.). |
| Delete application | DELETE | `/applications/{id}` | `/applications/{id}` | Deletes the app registration. Moves to a 30-day recoverable state. |
| Restore deleted application | POST | `/directory/deletedItems/{id}/restore` | same | Restores a soft-deleted app registration. |
| Permanently delete application | DELETE | `/directory/deletedItems/{id}` | same | Permanently removes a soft-deleted app (cannot be undone). |

## Credentials (Certificates & Secrets)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Add password (client secret) | POST | `/applications/{id}/addPassword` | same | Generates a new client secret. Returns the secret value **only once** — store it immediately. |
| Remove password | POST | `/applications/{id}/removePassword` | same | Revokes a client secret by `keyId`. |
| Add key (certificate) | POST | `/applications/{id}/addKey` | same | Adds a certificate credential for the app. |
| Remove key | POST | `/applications/{id}/removeKey` | same | Removes a certificate credential. |

## Ownership

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List owners | GET | `/applications/{id}/owners` | `/applications/{id}/owners` | Lists users who can manage this app registration. |
| Add owner | POST | `/applications/{id}/owners/$ref` | same | Assigns an owner. Only individual users are supported as owners (not groups). |
| Remove owner | DELETE | `/applications/{id}/owners/{id}/$ref` | same | Removes an owner. |

## API Permissions & App Roles (defined on the app)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get required resource access | GET / PATCH via `/applications/{id}` | `requiredResourceAccess` property | same | Defines which delegated/application permissions this app requests from other APIs (e.g. Microsoft Graph). Managed as part of the app manifest, not a separate endpoint. |
| Define app roles | PATCH via `/applications/{id}` | `appRoles` property | same | Defines custom app roles that can later be assigned to users/groups/SPs via the corresponding service principal. |

## Federated Identity Credentials (for workload identity federation, e.g. GitHub Actions/CI)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List federated credentials | GET | `/applications/{id}/federatedIdentityCredentials` | same | Lists federated identity credentials (allows external workloads to authenticate without secrets). |
| Create federated credential | POST | `/applications/{id}/federatedIdentityCredentials` | same | Adds a new federated credential (e.g. for GitHub Actions OIDC). |
| Delete federated credential | DELETE | `/applications/{id}/federatedIdentityCredentials/{id}` | same | Removes a federated credential. |

## Common permissions required
- `Application.Read.All` / `Application.ReadWrite.All` — read/manage app registrations
- `Application.ReadWrite.OwnedBy` — manage only apps the caller owns
- `Directory.Read.All` — required alongside `Application.ReadWrite.All` for some owner-management calls

## Notes
- Client secret values are shown **once** at creation time and never retrievable again — if lost, you must add a new one and remove the old.
- Best practice from Microsoft: give each app **at least two owners**, so access isn't lost if one owner leaves the org.
- Federated Identity Credentials are the modern, secretless alternative for CI/CD pipelines (GitHub Actions, Azure DevOps) — worth using instead of long-lived client secrets where possible.
