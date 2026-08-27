# Security — Microsoft Graph API Endpoints

Covers the core protective controls under Entra ID's Security blade: Conditional Access, Identity Protection (risk detection), Authentication Methods/Strengths policies, and Named Locations.

Base URL: `https://graph.microsoft.com/{version}/`

## Conditional Access

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List policies | GET | `/identity/conditionalAccess/policies` | same | Lists all Conditional Access policies in the tenant. |
| Get a policy | GET | `/identity/conditionalAccess/policies/{id}` | same | Retrieves a specific policy's conditions and grant/session controls. |
| Create policy | POST | `/identity/conditionalAccess/policies` | same | Creates a new Conditional Access policy. Requires `displayName`, `state` (`enabled`/`disabled`/`enabledForReportingButNotEnforced`), `conditions`, and `grantControls`. |
| Update policy | PATCH | `/identity/conditionalAccess/policies/{id}` | same | Updates conditions, controls, or state of an existing policy. |
| Delete policy | DELETE | `/identity/conditionalAccess/policies/{id}` | same | Deletes a Conditional Access policy. |
| List named locations | GET | `/identity/conditionalAccess/namedLocations` | same | Lists IP ranges/countries defined as named locations for use in policy conditions. |
| Create named location | POST | `/identity/conditionalAccess/namedLocations` | same | Defines a new IP-based or country-based named location. |
| Evaluate ("What If") | POST | `/identity/conditionalAccess/evaluate` | same | Simulates which policies would apply to a given user/app/sign-in context, without actually enforcing anything — useful for testing changes safely. |
| Authentication context class refs | GET/POST | `/identity/conditionalAccess/authenticationContextClassReferences` | same | Manages authentication context tags used to trigger step-up authentication (e.g. from Purview or custom apps) within CA policies. |

## Identity Protection — Risky Users

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List risky users | GET | `/identityProtection/riskyUsers` | same | Lists users flagged with a risk level. Requires Entra ID P2. |
| Get a risky user | GET | `/identityProtection/riskyUsers/{id}` | same | Retrieves risk details for a specific user. |
| Get user risk history | GET | `/identityProtection/riskyUsers/{id}/history` | same | Retrieves the timeline of risk state changes for a user. |
| Confirm compromised | POST | `/identityProtection/riskyUsers/confirmCompromised` | same | Marks specified users as confirmed compromised, setting risk to high. |
| Dismiss risk | POST | `/identityProtection/riskyUsers/dismiss` | same | Clears risk state for specified users (max 60 per call), setting risk to none. |

## Identity Protection — Risk Detections

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List risk detections | GET | `/identityProtection/riskDetections` | same | Lists individual detected risk events (e.g. anonymized IP, impossible travel, leaked credentials). |
| Get a risk detection | GET | `/identityProtection/riskDetections/{id}` | same | Retrieves details of a specific risk detection event. |

## Identity Protection — Risky Service Principals & Workload Identities

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List risky service principals | GET | Not available in v1.0 | `/identityProtection/riskyServicePrincipals` | Lists service principals flagged as risky. Requires Entra Workload ID Premium license. |
| Get risky service principal history | GET | Not available in v1.0 | `/identityProtection/riskyServicePrincipals/{id}/history` | Retrieves risk history for a specific service principal. |
| Confirm compromised | POST | Not available in v1.0 | `/identityProtection/riskyServicePrincipals/confirmCompromised` | Marks service principals as compromised (sets risk to high). Requires Security Administrator role. |
| Dismiss risk | POST | Not available in v1.0 | `/identityProtection/riskyServicePrincipals/dismiss` | Clears risk state for specified service principals. |

## Authentication Methods & Strengths

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get authentication methods policy | GET | `/policies/authenticationMethodsPolicy` | same | Retrieves tenant-wide settings for which auth methods (FIDO2, Authenticator, SMS, etc.) are enabled. |
| Update authentication methods policy | PATCH | `/policies/authenticationMethodsPolicy` | same | Enables/disables/configures specific authentication methods tenant-wide. |
| List authentication strengths | GET | `/policies/authenticationStrengthPolicies` | same | Lists combinations of auth methods that can be required as a Conditional Access grant control (e.g. "Phishing-resistant MFA"). |
| Create custom authentication strength | POST | `/policies/authenticationStrengthPolicies` | same | Defines a custom combination of allowed authentication methods. |
| Get user registration details | GET | `/reports/authenticationMethods/userRegistrationDetails` | same | Reports on which auth methods each user has registered and their MFA/SSPR capability status. |

## Common permissions required
- `Policy.Read.All` / `Policy.ReadWrite.ConditionalAccess` — read/manage Conditional Access
- `IdentityRiskyUser.Read.All` / `IdentityRiskyUser.ReadWrite.All` — Identity Protection risky users
- `IdentityRiskEvent.Read.All` — risk detections
- `IdentityRiskyServicePrincipal.ReadWrite.All` — risky service principals (requires Workload ID Premium)
- `Policy.ReadWrite.AuthenticationMethod` — authentication methods and strengths policies

## Notes
- Identity Protection features (risky users, risk detections) require an **Entra ID P2** license; risky service principal detection additionally requires a **Workload ID Premium** license.
- Always test new Conditional Access policies with `state: "enabledForReportingButNotEnforced"` first, or use the `/identity/conditionalAccess/evaluate` "What If" endpoint — a misconfigured CA policy pushed live can lock out the whole tenant, including admins.
- Confirming/dismissing risky users or service principals requires the **Security Administrator** role at minimum in delegated (signed-in user) scenarios.
