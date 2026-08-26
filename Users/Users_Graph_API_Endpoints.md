# Users — Microsoft Graph API Endpoints

Base URL: `https://graph.microsoft.com/{version}/users`

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List users | GET | `/users` | `/users` | Retrieves a list of all users in the tenant. Beta returns additional properties not exposed in v1.0. |
| Get a user | GET | `/users/{id \| userPrincipalName}` | `/users/{id \| userPrincipalName}` | Retrieves the profile of a specific user by ID or UPN. |
| Create user | POST | `/users` | `/users` | Creates a new user account. Requires `accountEnabled`, `displayName`, `mailNickname`, `userPrincipalName`, and `passwordProfile` in the request body. |
| Update user | PATCH | `/users/{id}` | `/users/{id}` | Modifies properties of an existing user (e.g. `jobTitle`, `department`, `mobilePhone`). |
| Delete user | DELETE | `/users/{id}` | `/users/{id}` | Deletes a user. The account moves to a 30-day recoverable "deleted items" state before permanent removal. |
| Restore deleted user | POST | `/directory/deletedItems/{id}/restore` | `/directory/deletedItems/{id}/restore` | Restores a soft-deleted user within the 30-day retention window. |
| Permanently delete user | DELETE | `/directory/deletedItems/{id}` | `/directory/deletedItems/{id}` | Permanently removes a soft-deleted user (cannot be undone). |
| Get user's manager | GET | `/users/{id}/manager` | `/users/{id}/manager` | Retrieves the manager assigned to a user. |
| Assign manager | PUT | `/users/{id}/manager/$ref` | `/users/{id}/manager/$ref` | Sets or changes a user's manager. |
| List direct reports | GET | `/users/{id}/directReports` | `/users/{id}/directReports` | Lists users who report to this user. |
| Reset password | POST | `/users/{id}/authentication/passwordMethods/{id}/resetPassword` | same | Resets a user's password (requires appropriate admin role). |
| Get user's group memberships | GET | `/users/{id}/memberOf` | `/users/{id}/memberOf` | Lists all groups/roles/admin units the user is a direct member of. |
| Get sign-in activity | GET | Not available in v1.0 for most detail | `/users/{id}?$select=signInActivity` | Retrieves last sign-in timestamps for the user (beta has richer detail). |
| Assign license | POST | `/users/{id}/assignLicense` | `/users/{id}/assignLicense` | Adds or removes licenses/SKUs assigned to the user. |
| Revoke sign-in sessions | POST | `/users/{id}/revokeSignInSessions` | `/users/{id}/revokeSignInSessions` | Invalidates all refresh tokens issued to the user, forcing re-authentication. |

## Common permissions required
- `User.Read.All` / `User.ReadWrite.All` — read/write user profiles
- `Directory.Read.All` / `Directory.ReadWrite.All` — broader directory access
- `User-PasswordProfile.ReadWrite.All` — required for password resets on some tenants

## Notes
- Beta endpoints are subject to change and not recommended for production automation — use for evaluation/testing only.
- Always check required permission scopes on [Microsoft Learn](https://learn.microsoft.com/en-us/graph/api/overview) before calling in production.
