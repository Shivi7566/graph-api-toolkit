# Password Reset (SSPR) — Microsoft Graph API Endpoints

Covers Self-Service Password Reset (SSPR): resetting a specific user's password, managing the authentication methods used for SSPR, and reporting on SSPR usage/registration.

Base URL: `https://graph.microsoft.com/{version}/`

## Resetting a User's Password (admin action)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List password methods | GET | `/users/{id}/authentication/passwordMethods` | same | Returns exactly one object (a user has only one password). The password value itself is **never** returned — always `null`. |
| Reset password | POST | `/users/{id}/authentication/passwordMethods/{id}/resetPassword` | same | Resets the user's password in the cloud, and on-premises too if the user is synced (via Entra Connect/Cloud Sync writeback). |

## SSPR-Related Authentication Methods (what users register for self-service reset)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List email auth methods | GET | `/users/{id}/authentication/emailMethods` | same | Lists the email address(es) a user has registered for SSPR. |
| Add email auth method | POST | `/users/{id}/authentication/emailMethods` | same | Registers an email address for SSPR use on behalf of the user. |
| Remove email auth method | DELETE | `/users/{id}/authentication/emailMethods/{id}` | same | Removes a registered SSPR email address. |
| List phone auth methods | GET | `/users/{id}/authentication/phoneMethods` | same | Lists phone numbers registered for SMS/voice — usable for both MFA and SSPR. |
| Add phone auth method | POST | `/users/{id}/authentication/phoneMethods` | same | Registers a phone number for the user. |
| Remove phone auth method | DELETE | `/users/{id}/authentication/phoneMethods/{id}` | same | Removes a registered phone number. |

## Tenant-Wide SSPR/Authorization Settings

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get authorization policy | GET | `/policies/authorizationPolicy` | same | Retrieves tenant authorization settings, including `allowedToUseSSPR` (whether SSPR is permitted at the tenant level, older/broader toggle). |
| Update authorization policy | PATCH | `/policies/authorizationPolicy/{id}` | same | Updates `allowedToUseSSPR` and related tenant-wide authorization flags. |
| Get authentication methods policy | GET | `/policies/authenticationMethodsPolicy` | same | Retrieves the modern unified policy governing which methods are usable, including `policyMigrationState` — tracks whether the tenant has migrated legacy MFA/SSPR policies into this unified model. |

> ⚠️ **Known gap:** The granular admin-portal setting "Self-service password reset enabled: None / Selected / All" (with group scoping) does **not** have a confirmed direct Graph read/write endpoint distinct from `allowedToUseSSPR` — that flag is broader/binary. If you need to confirm the exact portal-displayed SSPR scope, check the Entra admin center directly rather than relying solely on this API property.

## Reporting

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get SSPR usage summary | GET | Not available in v1.0 | `/reports/getCredentialUsageSummary` | Reports how many users in the org have actually used SSPR capabilities. |
| List credential user registration details | GET | `/reports/authenticationMethods/userRegistrationDetails` | same | Per-user report of which auth methods are registered and whether the user is SSPR/MFA capable. Also documented in `Security.md`. |
| List credential usage details | GET | Not available in v1.0 | `/reports/userCredentialUsageDetails` | Detailed per-user SSPR usage events, including reset outcome and failure reason. |

## Common permissions required
- `UserAuthenticationMethod.ReadWrite.All` — manage password reset and SSPR-related methods for users
- `Policy.ReadWrite.Authorization` — update `allowedToUseSSPR` and related tenant authorization policy
- `Policy.ReadWrite.AuthenticationMethod` — manage the unified authentication methods policy
- `Reports.Read.All` — read SSPR usage/registration reports

## Notes
- Resetting a password via Graph for a hybrid (synced) user writes back to on-premises AD automatically — no separate on-prem step needed, as long as password writeback is enabled on the sync configuration (see `MicrosoftEntraConnect.md` / `CloudSync.md`).
- `policyMigrationState` on the authentication methods policy matters: while a tenant is still in `premigration` or `migrationInProgress`, legacy SSPR/MFA policies are still partially respected alongside the newer unified policy — good to check before assuming only one policy object controls behavior.
- Same as the MDM Authority gap noted in `MobilityMDMWIP.md` — some admin-portal toggles simply don't have a clean, dedicated Graph property; always verify against the portal if a script's read-back doesn't match what you configured.
