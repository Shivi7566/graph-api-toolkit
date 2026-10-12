# Microsoft Graph API & PowerShell SDK v2 Automation Engine
### Production-Grade Enterprise Automation, Security Auditing, & Identity Governance
**Maintained by:** [Cloud Knowledge](https://cloudknowledge.in) | [YouTube: @Cloud-Knowledge](https://www.youtube.com/@Cloud-Knowledge)

[![PowerShell](https://img.shields.io/badge/PowerShell-v7.4%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![SDK](https://img.shields.io/badge/Microsoft.Graph-v2.x-0078D4.svg)](https://www.powershellgallery.com/packages/Microsoft.Graph)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Cloud-Microsoft%20Entra%20ID-orange.svg)](https://cloudknowledge.in)
[![Cheat Sheet](https://img.shields.io/badge/Download-A4%20PDF%20Cheat%20Sheet-brightgreen.svg)](./docs/Microsoft_Graph_SDK_v2_CheatSheet.pdf)

> 📄 **Instant Download:** Grab the high-resolution [1-Page Microsoft Graph SDK v2 Printable Cheat Sheet (PDF)](./docs/Microsoft_Graph_SDK_v2_CheatSheet.pdf). Laminated physical copies available via **[PrintKrlo.in](https://printkrlo.in)**.

Welcome to the **graph-api-toolkit** repository! This open-source repository provides production-tested, hardened PowerShell automation scripts built on top of the **Microsoft Graph PowerShell SDK v2** and **Microsoft Graph REST API (v1.0 & Beta)**.

Designed for Cloud Engineers, Identity Architects, and SOC Analysts operating in enterprise Microsoft Entra ID and hybrid cloud environments.

---

## ⚡ Automation Modules & Scripts

### 1. 🔑 [App & Service Principal Credential Monitoring](./AppCredentialMonitoring/)
- **[`Audit-AppSecretExpiration.ps1`](./AppCredentialMonitoring/Audit-AppSecretExpiration.ps1)**:
  - Audits all Microsoft Entra App Registrations and Enterprise Applications.
  - Detects Client Secrets and Certificates expiring within a customizable threshold (e.g. 30 days).
  - Flags expired credentials causing critical service outages and exports structured audit CSVs.

### 2. 🛡️ [Conditional Access Disaster Recovery](./ConditionalAccessBackup/)
- **[`Backup-ConditionalAccessPolicies.ps1`](./ConditionalAccessBackup/Backup-ConditionalAccessPolicies.ps1)**:
  - Extracts all tenant Conditional Access policies with full JSON depth (assignments, conditions, grant controls, session controls).
  - Creates timestamped, version-controlled backup directories with an automated `Manifest.json` index.

### 3. 👥 [User Lifecycle & Stale Account Auditing](./UserLifecycleAutomation/)
- **[`Export-StaleUsers.ps1`](./UserLifecycleAutomation/Export-StaleUsers.ps1)**:
  - Leverages Microsoft Graph `signInActivity` endpoint to track interactive and non-interactive authentication timestamps.
  - Automatically identifies dormant, departed, or orphaned cloud identities exceeding 90+ days of inactivity to enforce Zero Trust hygiene.

---

## 📂 Microsoft Graph API Endpoint Reference Index

This repository provides exhaustive mapping of Microsoft Entra ID admin categories to their underlying Microsoft Graph v1.0 and Beta REST endpoints:

| Domain | Category Documentation | Key Endpoints Covered |
| :--- | :--- | :--- |
| **Identity & Users** | [Users](./Users/Users_Graph_API_Endpoints.md) | `/users`, `/users/{id}/manager`, `/users/{id}/licenseDetails` |
| | [Groups](./Groups/Groups_Graph_API_Endpoints.md) | `/groups`, `/groups/{id}/members`, `/groups/{id}/transitiveMembers` |
| | [External Identities](./ExternalIdentities/ExternalIdentities_Graph_API_Endpoints.md) | `/invitations`, `/policies/crossTenantAccessPolicy` |
| | [Administrative Units](./AdministrativeUnits/AdministrativeUnits_Graph_API_Endpoints.md) | `/directory/administrativeUnits`, `/scopedRoleMembers` |
| | [Roles & Admins](./RolesAndAdministrators/RolesandAdministrator_Graph_API_Endpoints.md) | `/directoryRoles`, `/roleManagement/directory/roleAssignments` |
| | [Delegated Admin Partners](./DelegatedAdminPartners/DelegatedAdminPartners_Graph_API_Endpoints.md) | `/contracts`, `/tenantRelationships/delegatedAdminCustomers` |
| **Applications & Devices** | [App Registrations](./AppRegistrations/AppRegistrations_Graph_API_Endpoints.md) | `/applications`, `/applications/{id}/addPassword`, `/keyCredentials` |
| | [Enterprise Applications](./EnterpriseApplications/EnterpriseApplications_Graph_API_Endpoints.md) | `/servicePrincipals`, `/appRoleAssignedTo`, `/claimsMappingPolicies` |
| | [Devices](./Devices/Devices_Graph_API_Endpoints.md) | `/devices`, `/devices/{id}/registeredOwners`, `/registeredUsers` |
| | [Application Proxy](./ApplicationProxy/Applicationproxy_Graph_API_Endpoints.md) | `/onPremisesPublishingProfiles/applicationProxy` |
| **Governance & Security** | [Identity Governance](./IdentityGovernance/IdentityGovernance_Graph_API_Endpoints.md) | `/identityGovernance/entitlementManagement`, `/lifecycleWorkflows` |
| | [Security & Conditional Access](./Security/Security.md) | `/identity/conditionalAccess/policies`, `/security/alerts_v2` |
| | [Custom Security Attributes](./CustomSecurityAttributes/CustomSecurityAttributes_Graph_API_Endpoints.md) | `/directory/customSecurityAttributeDefinitions` |
| | [Licenses](./Licenses/Licenses.md) | `/subscribedSkus`, `/directory/deletedItems` |
| **Hybrid & Sync** | [Microsoft Entra Connect](./MicrosoftEntraConnect/MicrosoftEntraConnect_Graph_API_Endpoints.md) | `/directory/onPremisesDirectorySynchronization` |
| | [Cloud Sync](./CloudSync/CloudSync.md) | `/servicePrincipals/{id}/synchronization/jobs` |
| | [Provisioning (SCIM)](./Provisioning/Provisioning.md) | `/synchronization/jobs/{id}/schema`, `/synchronization/rules` |
| | [Cross-Tenant Sync](./CrossTenantSynchronization/CrossTenantSynchronization_Graph_API_Endpoints.md) | `/policies/crossTenantAccessPolicy/partners` |
| **Tenant Configuration** | [Custom Domain Names](./CustomDomainNames/CustomDomainNames_Graph_API_Endpoints.md) | `/domains`, `/domains/{id}/verify`, `/federationConfiguration` |
| | [Password Reset (SSPR)](./PasswordReset/PasswordReset_Graph_API_Endpoints.md) | `/policies/authenticationMethodsPolicy`, `/userRegistrationDetails` |
| | [Mobility (MDM/WIP)](./MobilityMDMWIP/MobilityMDMWIP_Graph_API_Endpoints.md) | `/policies/mobileDeviceManagementPolicies` |
| | [Company Branding](./CompanyBranding/CompanyBranding_Graph_API_Endpoints.md) | `/organization/{id}/branding/localizations` |
| | [User Settings](./UserSettings/UserSettings_Graph_API_Endpoints.md) | `/policies/authorizationPolicy`, `/policies/permissionGrantPolicies` |
| | [Tenant Properties](./Properties/TenantProperties_Graph_API_Endpoints.md) | `/organization`, `/tenantRelationships` |
| **Monitoring & Telemetry** | [Audit Logs](./AuditLogs/AuditLogs_Graph_API_Endpoints.md) | `/auditLogs/directoryAudits`, `/directory/provisioning` |
| | [Sign-In Logs](./SignInLogs/SignInLogs_Graph_API_Endpoints.md) | `/auditLogs/signIns`, `/identityProtection/riskyUsers` |

*For complete status and progress, see [ROADMAP.MD](./ROADMAP.MD).*

## 🚀 Quickstart & Prerequisites

Ensure the modern Microsoft Graph PowerShell SDK v2 is installed:
```powershell
# Install core and identity sub-modules
Install-Module Microsoft.Graph.Authentication -Scope CurrentUser -Repository PSGallery -Force
Install-Module Microsoft.Graph.Applications -Scope CurrentUser -Repository PSGallery -Force
Install-Module Microsoft.Graph.Identity.SignIns -Scope CurrentUser -Repository PSGallery -Force
Install-Module Microsoft.Graph.Users -Scope CurrentUser -Repository PSGallery -Force
```

### Unattended Automation via Service Principal
For automated CI/CD and Azure Automation Runbooks, authenticate with certificate-based client credentials:
```powershell
Connect-MgGraph -ClientId "<AppId>" -TenantId "<TenantId>" -CertificateThumbprint "<Thumbprint>" -NoWelcome
```

---

## 📚 Recommended Enterprise Architecture Guides & Interview Handbooks
Explore companion engineering deep-dives, architectural blueprints, and scenario interview banks on [CloudKnowledge.in](https://cloudknowledge.in):

- 📖 **[Microsoft Graph PowerShell SDK v2 Automation Playbook](https://cloudknowledge.in/microsoft-graph-powershell-sdk-v2-automation-guide/)** — Complete guide to unattended automation, token lifecycle, rate limiting mitigation, and least-privilege scoping.
- 🎯 **[Top 35 Microsoft Entra ID Scenario Interview Questions & Answers (2026)](https://cloudknowledge.in/top-35-microsoft-entra-id-scenario-interview-questions-and-answers/)** — Real-world enterprise troubleshooting covering Conditional Access, PIM, CAE, SSPR, and hybrid identity.
- 🔐 **[Microsoft Entra ID Governance & Lifecycle Workflows Architecture](https://cloudknowledge.in/microsoft-entra-id-governance-lifecycle-workflows/)** — Deep dive into Joiner-Mover-Leaver automation, access reviews, and Segregation of Duties (SoD).
- 🛠️ **[Top 25 Okta, SAML 2.0 & OIDC Troubleshooting Interview Questions](https://cloudknowledge.in/top-25-okta-saml-oidc-troubleshooting-interview-questions/)** — Diagnosing silent SSO failures, token claims, clock skew, and signature verification in DevTools.
- 🚀 **[Top 30 Kubernetes Troubleshooting & CNI Interview Questions](https://cloudknowledge.in/top-30-kubernetes-troubleshooting-cni-interview-questions/)** — Pod networking debugging, CoreDNS resolution, packet drops, and Cilium eBPF benchmarks.
- ⚡ **[Cilium vs Istio Ambient Mesh Benchmark & Zero Trust Guide](https://cloudknowledge.in/cilium-vs-istio-ambient-mesh-benchmark/)** — Sidecarless mutual TLS, kernel tracing, and L4/L7 latency benchmarks.

---

## 📺 Video Tutorials & Lab Demonstrations
Watch full step-by-step labs and production walkthroughs on YouTube:
👉 **[Cloud Knowledge Official Channel (@Cloud-Knowledge)](https://www.youtube.com/@Cloud-Knowledge)**

## 🖨️ Physical Desk Reference & Laminated Cheat Sheets
Need physical, laminated reference cheat sheets, architecture blueprints, or binding for study materials and lab notes?
- **Order directly via [PrintKrlo.in](https://printkrlo.in)** — Smart Cyber Cafe & Online Xerox Kiosk.
- High-quality document printing, spiral binding, and doorstep delivery for developers, cloud architects, and students.

---

## 📄 License & Community
Licensed under the [MIT License](LICENSE). Contributions, bug reports, and pull requests are welcome!
