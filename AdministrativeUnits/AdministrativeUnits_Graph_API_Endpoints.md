# Administrative Units — Microsoft Graph API Endpoints

Administrative units let you delegate admin permissions over a subset of users/groups/devices (e.g. by region or department), instead of granting tenant-wide roles.

Base URL: `https://graph.microsoft.com/{version}/administrativeUnits`

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List administrative units | GET | `/administrativeUnits` | `/administrativeUnits` | Lists all administrative units in the tenant. |
| Get an administrative unit | GET | `/administrativeUnits/{id}` | `/administrativeUnits/{id}` | Retrieves details of a specific administrative unit. |
| Create administrative unit | POST | `/administrativeUnits` | `/administrativeUnits` | Creates a new administrative unit. Can be `Assigned` (static) or `Dynamic` membership (with a `membershipRule`, users only). |
| Update administrative unit | PATCH | `/administrativeUnits/{id}` | `/administrativeUnits/{id}` | Updates `displayName`, `description`, or membership rule. |
| Delete administrative unit | DELETE | `/administrativeUnits/{id}` | `/administrativeUnits/{id}` | Deletes an administrative unit (does not delete the members themselves). |
| List members | GET | `/administrativeUnits/{id}/members` | `/administrativeUnits/{id}/members` | Lists users, groups, and devices that belong to the administrative unit. |
| Add member | POST | `/administrativeUnits/{id}/members/$ref` | same | Adds an existing user, group, or device to the administrative unit. Only one member can be added per request. |
| Create group within AU | POST | `/administrativeUnits/{id}/members` | same | Creates a brand-new group directly inside the administrative unit. |
| Remove member | DELETE | `/administrativeUnits/{id}/members/{id}/$ref` | same | Removes a member from the administrative unit (member itself isn't deleted). |
| List scoped role members | GET | `/administrativeUnits/{id}/scopedRoleMembers` | same | Lists role assignments that are scoped to just this administrative unit. |
| Get a scoped role member | GET | `/administrativeUnits/{id}/scopedRoleMembers/{id}` | same | Retrieves a specific AU-scoped role assignment. |
| Add scoped role member | POST | `/administrativeUnits/{id}/scopedRoleMembers` | same | Assigns a directory role to a principal, scoped only to this administrative unit (delegated admin). Requires `roleId` and `roleMemberInfo`. |
| Remove scoped role member | DELETE | `/administrativeUnits/{id}/scopedRoleMembers/{id}` | same | Removes an AU-scoped role assignment. |

## Membership types
| Type | How it works |
|---|---|
| **Assigned** | Manually add/remove members one at a time via `$ref`. |
| **Dynamic** | Set `membershipType: "Dynamic"` + a `membershipRule` (e.g. `user.country -eq "United States"`). Users only — dynamic AUs can't include groups or devices. |
| **Restricted management** | Set `isMemberManagementRestricted: true` at creation (immutable after creation) — protects members inside from being modified by admins outside the AU's scope, even Global Admins in some cases. |

## Common permissions required
- `AdministrativeUnit.Read.All` / `AdministrativeUnit.ReadWrite.All` — manage AUs and their membership
- `RoleManagement.ReadWrite.Directory` — required to assign scoped roles within an AU
- `Directory.Read.All` — needed for app-only scenarios reading directory context

## Notes
- Use `directoryScopeId` (from the Roles doc) referencing an AU's ID when creating a role assignment via `/roleManagement/directory/roleAssignments` — that's the modern equivalent of `scopedRoleMembers`, and Microsoft recommends it over the legacy endpoint for new work.
- Only one member can be added to an AU per API call — for bulk onboarding, loop through members in a script rather than expecting a batch endpoint.
- Restricted management AUs are useful for genuinely sensitive groups (e.g. executive accounts) where you want to block even broad admin roles from touching them.
