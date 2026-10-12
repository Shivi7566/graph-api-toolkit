# Graph API Toolkit — Complete Reference Roadmap

Tracks documentation coverage across Microsoft Entra ID Graph API endpoints (v1.0 & Beta) and production PowerShell automation modules.

## 👤 Identity & Access
- [x] [Users](./Users/Users_Graph_API_Endpoints.md) — User CRUD, profile management, license assignments, and manager relationships.
- [x] [Groups](./Groups/Groups_Graph_API_Endpoints.md) — Security groups, Microsoft 365 dynamic membership, and owners.
- [x] [External Identities](./ExternalIdentities/ExternalIdentities_Graph_API_Endpoints.md) — B2B invitation managers, guest lifecycle, and cross-tenant policies.
- [x] [Roles & Administrators](./RolesAndAdministrators/RolesandAdministrator_Graph_API_Endpoints.md) — Directory roles, role templates, and eligible assignments.
- [x] [Administrative Units](./AdministrativeUnits/AdministrativeUnits_Graph_API_Endpoints.md) — Scoped administration boundaries and membership management.
- [x] [Delegated Admin Partners](./DelegatedAdminPartners/DelegatedAdminPartners_Graph_API_Endpoints.md) — Partner relationships and indirect reseller access.
- [x] [Agents](./Agents/Agents_Graph_API_Endpoints.md) — Hybrid identity agent status and machine pools.

## 📱 Applications & Devices
- [x] [Enterprise Applications](./EnterpriseApplications/EnterpriseApplications_Graph_API_Endpoints.md) — Service principals, app role assignments, and SAML SSO SSO config.
- [x] [Devices](./Devices/Devices_Graph_API_Endpoints.md) — Registered and Entra joined devices, BitLocker keys, and compliance states.
- [x] [App Registrations](./AppRegistrations/AppRegistrations_Graph_API_Endpoints.md) — OAuth 2.0 app definitions, API permissions, secrets, and certificates.
- [x] [Application Proxy](./ApplicationProxy/Applicationproxy_Graph_API_Endpoints.md) — On-premises app publishing, connectors, and routing groups.

## 🛡️ Governance & Security
- [x] [Identity Governance](./IdentityGovernance/IdentityGovernance_Graph_API_Endpoints.md) — Entitlement management, access packages, catalogs, and lifecycle workflows.
- [x] [Custom Security Attributes](./CustomSecurityAttributes/CustomSecurityAttributes_Graph_API_Endpoints.md) — Attribute definitions, attribute sets, and assignment filters.
- [x] [Security](./Security/Security.md) — Conditional Access policies, named locations, alerts, and risk detections.
- [x] [Licenses](./Licenses/Licenses.md) — Subscribed SKUs, service plans, and usage telemetry.

## 🔄 Synchronization & Hybrid
- [x] [Cross-Tenant Synchronization](./CrossTenantSynchronization/CrossTenantSynchronization_Graph_API_Endpoints.md) — Multi-tenant sync topology and outbound trust.
- [x] [Microsoft Entra Connect](./MicrosoftEntraConnect/MicrosoftEntraConnect_Graph_API_Endpoints.md) — Directory synchronization status, sync errors, and anchors.
- [x] [Provisioning](./Provisioning/Provisioning.md) — SCIM user sync jobs, synchronization schema, and agent logs.
- [x] [Cloud Sync](./CloudSync/CloudSync.md) — Lightweight sync agent configurations and scoping filters.

## ⚙️ Tenant Configuration
- [x] [Custom Domain Names](./CustomDomainNames/CustomDomainNames_Graph_API_Endpoints.md) — Domain verification, DNS TXT/MX records, and federation configurations.
- [x] [Mobility (MDM/WIP)](./MobilityMDMWIP/MobilityMDMWIP_Graph_API_Endpoints.md) — MDM authority, Intune registration, and enrollment URLs.
- [x] [Password Reset](./PasswordReset/PasswordReset_Graph_API_Endpoints.md) — SSPR policies, authentication methods, and gating conditions.
- [x] [Company Branding](./CompanyBranding/CompanyBranding_Graph_API_Endpoints.md) — Custom login branding, banners, and localized themes.
- [x] [User Settings](./UserSettings/UserSettings_Graph_API_Endpoints.md) — Self-service app access, LinkedIn connection, and user consent settings.
- [x] [Properties](./Properties/TenantProperties_Graph_API_Endpoints.md) — Tenant organizational metadata, technical contacts, and country codes.

## 📊 Monitoring & Logs
- [x] [Audit Logs](./AuditLogs/AuditLogs_Graph_API_Endpoints.md) — Directory management events, role activations, and change tracking.
- [x] [Sign-In Logs](./SignInLogs/SignInLogs_Graph_API_Endpoints.md) — Interactive, non-interactive, service principal, and managed identity sign-ins.

## ⚡ Production Automation Scripts
- [x] [App Secret Expiration Monitor](./AppCredentialMonitoring/Audit-AppSecretExpiration.ps1) — Proactive credential auditing with CSV alerts.
- [x] [Conditional Access Disaster Recovery](./ConditionalAccessBackup/Backup-ConditionalAccessPolicies.ps1) — Full JSON policy backup with auto-manifest.
- [x] [Stale User Account Remediation](./UserLifecycleAutomation/Export-StaleUsers.ps1) — Inactive account detection using `signInActivity`.

---
*Maintained by [Cloud Knowledge](https://cloudknowledge.in) · Updated: October 2026*
