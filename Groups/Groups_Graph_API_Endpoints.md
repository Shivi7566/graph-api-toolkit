# Groups — Microsoft Graph API Endpoints

Base URL: `https://graph.microsoft.com/{version}/groups`

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List groups | GET | `/groups` | `/groups` | Retrieves a list of all groups in the tenant. |
| Get a group | GET | `/groups/{id}` | `/groups/{id}` | Retrieves the profile of a specific group by ID. |
| Create group | POST | `/groups` | `/groups` | Creates a new group. Requires `displayName`, `mailNickname`, `mailEnabled`, `securityEnabled`, and `groupTypes` in the request body. |
| Update group | PATCH | `/groups/{id}` | `/groups/{id}` | Modifies properties of an existing group (e.g. `displayName`, `description`, `visibility`). |
| Delete group | DELETE | `/groups/{id}` | `/groups/{id}` | Deletes a group. Microsoft 365 groups move to a 30-day recoverable "deleted items" state; security groups are deleted immediately. |
| Restore deleted group | POST | `/directory/deletedItems/{id}/restore` | `/directory/deletedItems/{id}/restore` | Restores a soft-deleted Microsoft 365 group within the 30-day window. |
| List members | GET | `/groups/{id}/members` | `/groups/{id}/members` | Lists direct members (users, groups, devices, service principals) of a group. |
| Add member | POST | `/groups/{id}/members/$ref` | `/groups/{id}/members/$ref` | Adds a member to a security or Microsoft 365 group. Up to 20 members can be added per request. Not applicable to dynamic groups. |
| Remove member | DELETE | `/groups/{id}/members/{id}/$ref` | `/groups/{id}/members/{id}/$ref` | Removes a member from a group. Can't be used on groups with dynamic membership. |
| List owners | GET | `/groups/{id}/owners` | `/groups/{id}/owners` | Lists the owners of a group. |
| Add owner | POST | `/groups/{id}/owners/$ref` | `/groups/{id}/owners/$ref` | Assigns a user as an owner of the group. |
| Remove owner | DELETE | `/groups/{id}/owners/{id}/$ref` | `/groups/{id}/owners/{id}/$ref` | Removes an owner from the group. |
| Check membership | POST | `/groups/{id}/checkMemberGroups` | `/groups/{id}/checkMemberGroups` | Checks whether the group is a member of a specified list of other groups. |
| Get member groups | POST | `/groups/{id}/getMemberGroups` | `/groups/{id}/getMemberGroups` | Returns all groups this group is a nested member of (transitive). |
| Evaluate dynamic membership | POST | Not available in v1.0 | `/groups/{id}/evaluateDynamicMembership` | Evaluates whether a given user/device is or would be a member based on the dynamic membership rule. |
| Renew group | POST | `/groups/{id}/renew` | `/groups/{id}/renew` | Renews a Microsoft 365 group's expiration (extends by the group's configured lifecycle period). |
| List group's apps/licenses | GET | `/groups/{id}/assignedLicenses` | `/groups/{id}/assignedLicenses` | Lists licenses assigned directly to the group (for group-based licensing). |

## Group types (for reference when creating)
| Type | `groupTypes` value | `mailEnabled` | `securityEnabled` |
|---|---|---|---|
| Security group | `[]` | `false` | `true` |
| Microsoft 365 group | `["Unified"]` | `true` | `false` |
| Mail-enabled security group | `[]` | `true` | `true` (created via Exchange, not directly via Graph) |
| Dynamic group | `["DynamicMembership"]` (+ `"Unified"` if M365) | depends | depends |

## Common permissions required
- `Group.Read.All` / `Group.ReadWrite.All` — read/write group profiles and membership
- `GroupMember.ReadWrite.All` — manage members/owners without full group edit rights
- `Directory.ReadWrite.All` — broader directory-level access

## Notes
- You can't add/remove members directly on **dynamic** groups — membership is calculated automatically from the rule.
- Deleting a Microsoft 365 group is recoverable for 30 days; deleting a plain security group is **not** recoverable — double-check before running delete calls in scripts.
- Beta endpoints (e.g. `evaluateDynamicMembership`) are useful for testing rule logic before deploying it.
