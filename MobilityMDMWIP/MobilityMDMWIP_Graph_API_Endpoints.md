# Mobility (MDM and WIP) — Microsoft Graph API Endpoints

Covers **autoenrollment policies** that automatically enroll Windows 10+ devices into a chosen Mobile Device Management (MDM) or Mobile Application Management (MAM/WIP) provider during Microsoft Entra join/register.

> ⚠️ This entire area is **beta-only** — no v1.0 support for reading or managing these policies via Graph.

Base URL: `https://graph.microsoft.com/beta/policies/`

## Mobile Device Management (MDM) Policies

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| List MDM policies | GET | `/policies/mobileDeviceManagementPolicies` | Lists configured MDM autoenrollment policies (e.g. Intune, or a third-party MDM). |
| Get an MDM policy | GET | `/policies/mobileDeviceManagementPolicies/{id}` | Retrieves details: `appliesTo`, `discoveryUrl`, `complianceUrl`, `termsOfUseUrl`, `includedGroups`. |
| List included groups | GET | `/policies/mobileDeviceManagementPolicies/{id}/includedGroups` | Lists which groups have autoenrollment enabled under this policy. |
| Add included group | POST | `/policies/mobileDeviceManagementPolicies/{id}/includedGroups/$ref` | Adds a group to be autoenrolled under this MDM policy. |
| Remove included group | DELETE | `/policies/mobileDeviceManagementPolicies/{id}/includedGroups/{id}/$ref` | Removes a group from autoenrollment scope. |

## Mobile Application Management (MAM/WIP) Policies

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| List MAM policies | GET | `/policies/mobileAppManagementPolicies` | Lists configured MAM policies (used for Windows Information Protection / app-level management without full device enrollment). |
| Get a MAM policy | GET | `/policies/mobileAppManagementPolicies/{id}` | Retrieves policy details, same shape as MDM policy (`appliesTo`, URLs, `includedGroups`). |
| List included groups | GET | `/policies/mobileAppManagementPolicies/{id}/includedGroups` | Lists groups scoped into this MAM policy. |
| Add included group | POST | `/policies/mobileAppManagementPolicies/{id}/includedGroups/$ref` | Adds a group to MAM policy scope. |
| Remove included group | DELETE | `/policies/mobileAppManagementPolicies/{id}/includedGroups/{id}/$ref` | Removes a group from MAM policy scope. |

## `appliesTo` values
| Value | Meaning |
|---|---|
| `all` | Policy applies to all users. |
| `none` | Policy currently applies to no one (disabled in effect). |
| `selected` | Policy applies only to users in `includedGroups`. |

## MDM Authority (tenant-wide, separate setting)

| Action | Method | Notes |
|---|---|---|
| Set MDM authority | — | No direct Graph endpoint — set via the **Microsoft Graph PowerShell SDK** cmdlet `Set-MgOrganizationMobileDeviceManagementAuthority`, which wraps an internal call. |
| Get MDM authority | — | **No working Graph read path exists** as of writing — the property doesn't reliably appear via `/organization` in either v1.0 or beta, despite `Get-MgOrganization` exposing the field in the SDK. Confirmed as a known gap by Microsoft's own Q&A community. |

## Common permissions required
- `Policy.Read.All` — read MDM/MAM policies
- `Policy.ReadWrite.MobilityManagement` — manage policies and included groups (create/update not exposed for the policies themselves via Graph — mainly `includedGroups` management is scriptable)

## Notes
- These autoenrollment policies apply specifically to **Windows 10 and derivatives** (Surface Hub, HoloLens) — not iOS/Android, which enroll through different flows (typically triggered by the Company Portal app itself, not this policy object).
- If you need to confirm the tenant's current MDM authority setting, the reliable path today is checking the **Entra admin center UI** (Mobility → MDM/MAM) rather than relying on Graph — worth noting in your script's error handling if you ever try to automate around this.
- This is a genuinely thin, mostly-read API — there's no create/delete for the policies themselves via documented Graph calls; policy creation happens by configuring the corresponding MDM/MAM app (e.g. Intune) in the portal, and Graph mainly lets you read/adjust group scoping afterward.
