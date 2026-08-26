# Devices — Microsoft Graph API Endpoints

Covers device objects registered/joined to Microsoft Entra ID (Azure AD Joined, Hybrid Joined, Registered), plus BitLocker recovery key retrieval.

Base URL: `https://graph.microsoft.com/{version}/devices`

## Core CRUD

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List devices | GET | `/devices` | `/devices` | Retrieves a list of devices registered in the directory. |
| Get a device | GET | `/devices/{id}` | `/devices/{id}` | Retrieves details of a specific device object. |
| Update device | PATCH | `/devices/{id}` | `/devices/{id}` | Updates properties like `accountEnabled` (enable/disable device sign-in). |
| Delete device | DELETE | `/devices/{id}` | `/devices/{id}` | Removes a registered device from the directory. |
| Restore deleted device | POST | `/directory/deletedItems/{id}/restore` | same | Restores a soft-deleted device within the 30-day recovery window. |

## Ownership & Registration

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List registered owners | GET | `/devices/{id}/registeredOwners` | `/devices/{id}/registeredOwners` | Lists the user who cloud-joined or registered the device. Only one owner is possible per device. |
| Add registered owner | POST | `/devices/{id}/registeredOwners/$ref` | same | Assigns a registered owner to the device. |
| Remove registered owner | DELETE | `/devices/{id}/registeredOwners/{id}/$ref` | same | Removes the registered owner. |
| List registered users | GET | `/devices/{id}/registeredUsers` | `/devices/{id}/registeredUsers` | Lists all users who have registered/signed into the device (can be more than one). |

## BitLocker Recovery Keys

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List recovery keys | GET | `/informationProtection/bitlocker/recoveryKeys` | same | Lists BitLocker keys across the tenant. Supports `$filter` by `deviceId`. Does not return the actual key by default. |
| Get a recovery key | GET | `/informationProtection/bitlocker/recoveryKeys/{id}` | same | Retrieves a specific key's metadata. Add `?$select=key` to retrieve the actual recovery key — **this triggers a mandatory Entra audit log entry** under the `KeyManagement` category. |

## Common permissions required
- `Device.Read.All` / `Device.ReadWrite.All` — read/manage device objects
- `Directory.AccessAsUser.All` — required (delegated) for device delete
- `BitlockerKey.ReadBasic.All` — list keys without exposing the actual key value
- `BitlockerKey.Read.All` — required to retrieve the actual key via `$select=key`

## Roles that can list devices (delegated, least privileged)
Users, Directory Readers, Directory Writers, Compliance Administrator, Device Managers, Application Administrator, Security Reader, Security Administrator, Privileged Role Administrator

## Notes
- Retrieving the **actual** BitLocker key value is intentionally noisy — it always generates an audit log entry, by design, so this can't be done silently even with full permissions. Good to know before scripting any bulk recovery-key exports.
- For delegated (signed-in user) BitLocker key reads, the caller must either be the device's registered owner or hold one of: Cloud Device Administrator, Helpdesk Administrator, Intune Service Administrator, Security Administrator, Security Reader, Global Reader.
- Device delete/disable via Graph doesn't wipe or unenroll the device from Intune — that's a separate Intune/MDM action, not covered by this basic device object API.
