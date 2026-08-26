# Identity Governance — Microsoft Graph API Endpoints

Microsoft Entra ID Governance covers 5 capability areas. **PIM** is documented separately in `RolesAndAdministrators.md`. This file covers the other four: Entitlement Management, Access Reviews, Lifecycle Workflows, and Terms of Use.

Base URL: `https://graph.microsoft.com/{version}/identityGovernance/`

## Entitlement Management (Access Packages)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List access packages | GET | `/identityGovernance/entitlementManagement/accessPackages` | same | Lists bundles of resources (groups, apps, sites) users can request access to. |
| Create access package | POST | `/identityGovernance/entitlementManagement/accessPackages` | same | Creates a new access package within a catalog. |
| List catalogs | GET | `/identityGovernance/entitlementManagement/accessPackageCatalogs` | same | Lists containers that group related access packages and resources. |
| Create catalog | POST | `/identityGovernance/entitlementManagement/accessPackageCatalogs` | same | Creates a new catalog. |
| List assignment policies | GET | `/identityGovernance/entitlementManagement/accessPackageAssignmentPolicies` | same | Lists policies defining who can request a package, approval flow, and expiration. |
| List assignments | GET | `/identityGovernance/entitlementManagement/accessPackageAssignments` | same | Lists current user assignments to access packages. |
| Request access package assignment | POST | `/identityGovernance/entitlementManagement/accessPackageAssignmentRequests` | same | Submits a request for a user to be assigned an access package (self-request or admin-direct-assign). |
| List approvals | GET | Not directly in v1.0 | `/identityGovernance/entitlementManagement/accessPackageAssignmentApprovals` | Lists pending/completed approval decisions for access requests. |
| Filter approvals by current user | GET | — | `/identityGovernance/entitlementManagement/accessPackageAssignmentApprovals/filterByCurrentUser(on='...')` | Gets approvals relevant to the calling user (as approver or requestor). |
| Update subject lifecycle | PATCH | Not available in v1.0 | `/identityGovernance/entitlementManagement/subjects/{objectId}` | Updates whether a subject (user) is `governed` or not by entitlement management. |
| Custom workflow extensions | POST | Not available in v1.0 | `/identityGovernance/entitlementManagement/accessPackageCatalogs/{id}/customAccessPackageWorkflowExtensions` | Adds a Logic App-based custom extension to run during access package request stages. |

## Access Reviews

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List review definitions | GET | `/identityGovernance/accessReviews/definitions` | same | Lists configured recurring/one-time access review campaigns. |
| Create review definition | POST | `/identityGovernance/accessReviews/definitions` | same | Creates a new access review (e.g. review group membership every 3 months). |
| List review instances | GET | `/identityGovernance/accessReviews/definitions/{id}/instances` | same | Lists individual occurrences of a recurring review. |
| List decisions | GET | `/identityGovernance/accessReviews/definitions/{id}/instances/{id}/decisions` | same | Lists approve/deny decisions made during the review. |
| Record a decision | PATCH | `/identityGovernance/accessReviews/definitions/{id}/instances/{id}/decisions/{id}` | same | Approves or denies a specific reviewee's continued access. |
| Stop a review | POST | `/identityGovernance/accessReviews/definitions/{id}/instances/{id}/stop` | same | Ends an in-progress review instance early. |

## Lifecycle Workflows

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List workflows | GET | `/identityGovernance/lifecycleWorkflows/workflows` | same | Lists automated workflows for joiner/mover/leaver scenarios. |
| Create workflow | POST | `/identityGovernance/lifecycleWorkflows/workflows` | same | Creates a new workflow with trigger conditions and tasks. |
| Activate workflow (on-demand) | POST | `/identityGovernance/lifecycleWorkflows/workflows/{id}/activate` | same | Manually triggers a workflow run for specified users, outside its normal schedule. |
| List workflow runs | GET | `/identityGovernance/lifecycleWorkflows/workflows/{id}/runs` | same | Lists execution history/runs for a workflow. |
| Get lifecycle management settings | GET / PATCH | Not available in v1.0 | `/identityGovernance/lifecycleWorkflows/settings` | Tenant-wide settings for lifecycle workflows (e.g. notification email templates). |
| Custom task extensions | POST | Not available in v1.0 | `/identityGovernance/lifecycleWorkflows/customTaskExtensions` | Registers a Logic App as a custom task callable from within a workflow (e.g. "grant manager access to mailbox"). |

## Terms of Use

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List agreements | GET | `/identityGovernance/termsOfUse/agreements` | same | Lists terms-of-use agreements users must accept. |
| Create agreement | POST | `/identityGovernance/termsOfUse/agreements` | same | Creates a new terms-of-use agreement (with a PDF file per language). |
| List acceptance statuses | GET | `/identityGovernance/termsOfUse/agreements/{id}/acceptances` | same | Lists which users have accepted/declined the agreement. |

## Common permissions required
- `EntitlementManagement.ReadWrite.All` — manage access packages, catalogs, assignments
- `AccessReview.ReadWrite.All` — manage access reviews
- `LifecycleWorkflows.ReadWrite.All` — manage lifecycle workflows
- `Agreement.ReadWrite.All` — manage terms of use agreements

## Notes
- Custom task/workflow extensions (both in Lifecycle Workflows and Entitlement Management) hook into **Azure Logic Apps** — the calling principal also needs an Azure RBAC role (Logic App Contributor, Contributor, or Owner) on that Logic App resource, not just the Graph permission.
- Lifecycle Workflows requires the **Lifecycle Workflows Administrator** role (or equivalent) as the least-privileged supported role for most write operations.
- PIM (Privileged Identity Management) is technically part of Identity Governance but is documented separately in `RolesAndAdministrators.md` since it's role-assignment-centric.
