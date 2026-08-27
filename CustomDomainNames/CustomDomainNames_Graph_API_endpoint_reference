# Custom Domain Names — Microsoft Graph API Endpoints

Covers adding, verifying, and managing custom domains (e.g. `contoso.com`) in a tenant, plus federation configuration for domains handled by an external identity provider (e.g. AD FS).

Base URL: `https://graph.microsoft.com/{version}/domains`

## Core CRUD

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List domains | GET | `/domains` | `/domains` | Lists all domains (verified and unverified) associated with the tenant. |
| Get a domain | GET | `/domains/{domainName}` | `/domains/{domainName}` | Retrieves details of a specific domain, addressed by its name (e.g. `contoso.com`), not a GUID. |
| Add domain | POST | `/domains` | `/domains` | Registers a new custom domain to the tenant (starts as unverified). |
| Update domain | PATCH | `/domains/{domainName}` | `/domains/{domainName}` | Updates properties like `isDefault` (sets it as the tenant's default domain for new users). |
| Delete domain | DELETE | `/domains/{domainName}` | `/domains/{domainName}` | Removes a domain. Fails if the domain still has objects (users, groups) using it. |

## Verification

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get DNS verification records | GET | `/domains/{domainName}/verificationDnsRecords` | same | Retrieves the TXT/MX records you must add to your DNS provider to prove ownership. |
| Verify domain | POST | `/domains/{domainName}/verify` | same | Checks DNS for the verification record and marks the domain verified if found. Only applies to unverified domains. Doesn't configure the domain for Exchange/other M365 services — that requires additional setup outside Graph. |
| Get service configuration records | GET | `/domains/{domainName}/serviceConfigurationRecords` | same | Retrieves DNS records needed to enable specific services (e.g. Exchange MX/CNAME records) on the domain, once verified. |

## Federation Configuration

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Get federation configuration | GET | `/domains/{domainName}/federationConfiguration` | same | Retrieves federation settings if this domain is federated with an external IdP (e.g. AD FS) instead of using cloud/managed authentication. |
| Create federation configuration | POST | `/domains/{domainName}/federationConfiguration` | same | Sets up federation for the domain — requires `issuerUri`, `signOutUri`, signing certificate, and related SAML/WS-Fed settings. |
| Update federation configuration | PATCH | `/domains/{domainName}/federationConfiguration/{id}` | same | Updates federation settings, e.g. `federatedIdpMfaBehavior` (whether to trust or reject MFA claims from the federated IdP). |
| Delete federation configuration | DELETE | `/domains/{domainName}/federationConfiguration/{id}` | same | Converts the domain from federated back to managed (cloud) authentication. |
| Internal domain federation (newer model) | GET/POST | Not in v1.0 | `/domains/{domainName}/federationConfiguration` (as `internalDomainFederation`) | The modern resource type for internally-federated domains — inherits from the general federation configuration model. |
| External domain federation config | GET | Not in v1.0 | `/directory/federationConfigurations` (filter by domain) | Looks up federation config across all configured external domains, filterable by domain name. |

## Common permissions required
- `Domain.Read.All` — list/read domains and DNS records
- `Domain.ReadWrite.All` — add, verify, delete domains, and manage federation configuration
- Directory role: **External Identity Provider Administrator** — least-privileged role for managing federation configuration

## Notes
- Domains are addressed by **name**, not by object ID (e.g. `/domains/contoso.com`, not a GUID) — different from most other resources in Graph.
- A domain can't be deleted while any user, group, or other object still references it (e.g. as part of a UPN or email address) — clean those up first.
- Verifying via Graph only confirms domain **ownership**; it does not automatically configure the domain for Exchange Online or other Microsoft 365 workloads — check `serviceConfigurationRecords` and complete any additional setup separately.
- Setting up federation incorrectly (wrong `issuerUri`/certificate) can lock out sign-in for every user on that domain — test carefully, ideally on a non-primary domain first.
