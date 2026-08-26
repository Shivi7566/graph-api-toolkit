# Roles and Administrators — Microsoft Graph API Endpoints

Covers Microsoft Entra directory roles, unified RBAC role assignments, custom roles, and PIM (Privileged Identity Management) eligible/active assignments.

Base URL: `https://graph.microsoft.com/{version}/`

> **Note:** Microsoft recommends using the **unified RBAC API** (`/roleManagement/directory/...`) over the legacy `/directoryRoles` API for new development — it's more flexible and supports custom roles + PIM.

## Legacy Directory Roles (still widely used, simpler for basic tasks)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List activated roles | GET | `/directoryRoles` | `/directoryRoles` | Lists directory roles currently activated in the tenant. Not all built-in roles are active by default. |
| Get a role | GET | `/directoryRoles/{id}` | `/directoryRoles/{id}` | Retrieves a specific activated directory role. |
| Activate a role | POST | `/directoryRoles` (with `roleTemplateId`) | same | Activates a built-in role template so it can be assigned. |
| List role templates | GET | `/directoryRoleTemplates` | `/directoryRoleTemplates` | Lists all available role templates in Entra (activated or not). |
| List role members | GET | `/directoryRoles/{id}/members` | `/directoryRoles/{id}/members` | Lists users/groups/service principals assigned to a role. |
| Add member to role | POST | `/directoryRoles/{id}/members/$ref` | same | Assigns a principal to an activated directory role. |
| Remove member from role | DELETE | `/directoryRoles/{id}/members/{id}/$ref` | same | Removes a principal from a directory role. |

## Unified RBAC — Role Definitions & Assignments (recommended)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List role definitions | GET | `/roleManagement/directory/roleDefinitions` | same | Lists all built-in and custom role definitions available in the directory. |
| Get role definition | GET | `/roleManagement/directory/roleDefinitions/{id}` | same | Retrieves details (including permissions) of a specific role definition. |
| Create custom role | POST | `/roleManagement/directory/roleDefinitions` | same | Creates a custom directory role with specific `rolePermissions`. Requires Microsoft Entra ID P1/P2. |
| Update custom role | PATCH | `/roleManagement/directory/roleDefinitions/{id}` | same | Modifies a custom role's permissions or display name. |
| Delete custom role | DELETE | `/roleManagement/directory/roleDefinitions/{id}` | same | Deletes a custom role definition. |
| List role assignments | GET | `/roleManagement/directory/roleAssignments` | same | Lists active role assignments (who has what role, and scope). |
| Create role assignment | POST | `/roleManagement/directory/roleAssignments` | same | Assigns a role to a principal, optionally scoped to an administrative unit (`directoryScopeId`). |
| Get role assignment | GET | `/roleManagement/directory/roleAssignments/{id}` | same | Retrieves a specific role assignment. |
| Delete role assignment | DELETE | `/roleManagement/directory/roleAssignments/{id}` | same | Removes a permanent (active) role assignment. |

## PIM — Eligible & Time-Bound Assignments

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List eligible assignments | GET | `/roleManagement/directory/roleEligibilityScheduleInstances` | same | Lists current PIM-eligible role assignments (not yet activated). |
| Request eligible assignment | POST | `/roleManagement/directory/roleEligibilityScheduleRequests` | same | Grants a user PIM eligibility for a role (admin action, `action: "AdminAssign"`). |
| Activate eligible role (self) | POST | `/roleManagement/directory/roleAssignmentScheduleRequests` | same | User activates their own eligible role for a time-boxed period (`action: "SelfActivate"`). Requires MFA in the same session. |
| List active (scheduled) assignments | GET | `/roleManagement/directory/roleAssignmentScheduleInstances` | same | Lists currently active, time-bound role assignments (from PIM activation). |
| Get assignment schedule request | GET | `/roleManagement/directory/roleAssignmentScheduleRequests/{id}` | same | Checks status of an assignment/activation request. |
| Cancel/deactivate assignment | POST | `/roleManagement/directory/roleAssignmentScheduleRequests/{id}/cancel` | same | Cancels a pending request or deactivates an active PIM assignment. |
| Get/update PIM policy | GET / PATCH | `/policies/roleManagementPolicies/{id}` | same | Reads or updates PIM settings for a role (e.g. max activation duration, approval required). |
| Get policy assignment | GET | `/policies/roleManagementPolicyAssignments/{id}` | same | Retrieves which PIM policy applies to a given role. |

## Common permissions required
- `RoleManagement.Read.Directory` / `RoleManagement.ReadWrite.Directory` — read/manage roles and assignments
- `PrivilegedAccess.Read.AzureAD` / `PrivilegedAccess.ReadWrite.AzureAD` — PIM eligible/active assignments
- `Directory.Read.All` — read directory role templates

## Notes
- Only **Global Administrator** and **Privileged Role Administrator** (or a custom role with the right permission) can assign most privileged roles.
- Self-activating a PIM-eligible role via API (`SelfActivate`) requires the calling session to have completed MFA — a token without a recent MFA claim will be rejected.
- `directoryScopeId: "/"` means tenant-wide; use an Administrative Unit's ID here to scope a role assignment to just that unit (see `AdministrativeUnits.md`).
