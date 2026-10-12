# Sign-In Logs — Microsoft Graph API Endpoints

Covers Entra ID's sign-in activity logs — every authentication attempt against the tenant, including risk, Conditional Access outcome, device, and location detail. For admin/system actions (not authentication events), see `AuditLogs.md`.

Base URL: `https://graph.microsoft.com/{version}/auditLogs/signIns`

## Core

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List sign-ins | GET | `/auditLogs/signIns` | `/auditLogs/signIns` | Lists interactive sign-in events. Requires Entra ID P1/P2 for full history (Free tier gets limited retention). |
| Get a sign-in | GET | `/auditLogs/signIns/{id}` | `/auditLogs/signIns/{id}` | Retrieves full detail of one sign-in event. |
| Filter by Conditional Access outcome | GET | `/auditLogs/signIns?$filter=conditionalAccessStatus eq 'failure'` | same | Finds sign-ins blocked or failed due to Conditional Access. |
| Filter by app | GET | `/auditLogs/signIns?$filter=appId eq '{appId}'` | same | Scopes to sign-ins against a specific application. |
| Filter by date range | GET | `/auditLogs/signIns?$filter=createdDateTime ge 2026-08-01T00:00:00Z and createdDateTime le 2026-08-28T00:00:00Z` | same | Scopes results to a specific time window. |
| Filter non-interactive sign-ins | GET | Not available in v1.0 | `/auditLogs/signIns?$filter=signInEventTypes/any(t: t eq 'nonInteractiveUser')` | Retrieves token-refresh/background sign-ins rather than user-initiated ones. |
| Filter service principal sign-ins | GET | Not available in v1.0 | `/auditLogs/signIns?$filter=signInEventTypes/any(t: t eq 'servicePrincipal')` | Retrieves app-only (client credential) sign-in activity. |
| Filter managed identity sign-ins | GET | Not available in v1.0 | `/auditLogs/signIns?$filter=signInEventTypes/any(t: t eq 'managedIdentity')` | Retrieves sign-ins from Azure managed identities. |
| Mark sign-in as compromised | POST | Not available in v1.0 | `/auditLogs/signIns/{id}/confirmCompromised` | Admin flags a sign-in event as risky, immediately setting it to high risk in Identity Protection — overrides any previous automated risk assessment. |

## Key `signIn` properties
| Property | Type | Description |
|---|---|---|
| `createdDateTime` | DateTimeOffset | When the sign-in was initiated (UTC). Supports `$orderby`, `$filter` (`eq`, `le`, `ge`). |
| `userDisplayName` / `userPrincipalName` / `userId` | String | Who signed in. |
| `appDisplayName` / `appId` | String | Which application was targeted. Supports `$filter` (`eq`, `startsWith`). |
| `ipAddress` | String | Source IP of the sign-in attempt. |
| `clientAppUsed` | String | Modern (`Browser`, `Mobile Apps and Desktop clients`) vs. legacy (`Exchange ActiveSync`, `IMAP`, `POP`, `SMTP`) authentication client. |
| `conditionalAccessStatus` | Enum | `success`, `failure`, `notApplied`, `unknownFutureValue`. |
| `appliedConditionalAccessPolicies` | Collection | Which specific CA policies were evaluated and their individual result. Requires extra CA-related privileges to read in full detail. |
| `status` | Object | Sign-in error code and description if it failed. |
| `riskLevelDuringSignIn` / `riskLevelAggregated` / `riskState` / `riskDetail` | String | Identity Protection risk assessment for this specific sign-in. |
| `deviceDetail` | Object | Device OS, browser, compliance/managed/trusted status. |
| `location` | Object | Geo-location derived from IP (city, state, country). |
| `authenticationRequirement` | String | `singleFactorAuthentication` or `multiFactorAuthentication`. |
| `correlationId` | String | Ties related log entries together — useful when troubleshooting with Microsoft support. |
| `isInteractive` | Boolean | Whether the user was directly present (vs. a background/silent token refresh). |

## Summary & Reporting Endpoints

| Action | Method | v1.0 Endpoint | Description |
|---|---|---|---|
| Application sign-in summary | GET | `/reports/applicationSignInDetailedSummary` | Aggregated sign-in counts and success/failure rates per application — useful for a dashboard view without pulling every raw event. |
| User registration details | GET | `/reports/authenticationMethods/userRegistrationDetails` | Per-user MFA/SSPR registration and capability status (also referenced in `Security.md` and `PasswordReset.md`). |
| CA compliance metrics | GET | `/reports/getMetricsForConditionalAccessCompliantDevicesSignInSuccess` | Reports how many sign-ins satisfied a device-compliance-requiring CA policy over a given period. |

## Common permissions required
- `AuditLog.Read.All` — read sign-in logs (paired with `Directory.Read.All` for full user/app context)
- `IdentityRiskyUser.ReadWrite.All` — required for `confirmCompromised`
- `Reports.Read.All` — access summary/reporting endpoints
- `Policy.Read.All` — needed alongside `AuditLog.Read.All` to see full detail in `appliedConditionalAccessPolicies`

## Notes
- **Free/no-license tenants get very limited sign-in log retention** (often just a few days) — Entra ID P1/P2 extends this significantly; plan external export (e.g. to a SIEM or Log Analytics) if longer history matters.
- Legacy authentication protocols (`IMAP`, `POP`, `SMTP`, `Exchange ActiveSync`) showing up in `clientAppUsed` are a common security red flag — these don't support modern Conditional Access/MFA enforcement well and are frequently the target of brute-force/spray attacks.
- Distinguish sign-in **event types**: interactive (default, user physically signing in), non-interactive (silent token refreshes), service principal (app-only), and managed identity — each needs a different `$filter` and tells a very different story when investigating an incident.
- This completes the full Graph API toolkit roadmap — see `ROADMAP.md` at the repo root for the finished checklist.
