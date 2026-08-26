# Agents (Microsoft Entra Agent ID) — Microsoft Graph API Endpoints

Microsoft Entra Agent ID manages identities for **AI agents** — giving them the same identity, security, and governance treatment (Conditional Access, Identity Protection, audit logs) as human users and apps.

> ⚠️ **Preview feature — beta only.** No v1.0 endpoint exists yet. Expect breaking changes; not recommended for production automation.

Base URL: `https://graph.microsoft.com/beta/`

## Core concepts
| Component | Purpose | Graph resource |
|---|---|---|
| Blueprint | Template defining an agent type + preauthorized permissions | `agentIdentityBlueprint` (inherits from `application`) |
| Blueprint principal | Record of a blueprint's registration in a tenant | `agentIdentityBlueprintPrincipal` |
| Agent identity | The primary identity an AI agent authenticates as | `agentIdentity` (inherits from `servicePrincipal`) |
| Agent user | Optional user-like account, for scenarios needing a full user identity | `agentUser` |

## Agent Identity Blueprints

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| List blueprints | GET | `/agentIdentityBlueprints` | Lists registered agent identity blueprint templates. |
| Create blueprint | POST | `/agentIdentityBlueprints` | Registers a new blueprint (template) that agent identities can be created from. |
| Get blueprint | GET | `/agentIdentityBlueprints/{id}` | Retrieves a specific blueprint's configuration. |
| Update blueprint | PATCH | `/agentIdentityBlueprints/{id}` | Updates a blueprint's properties. |

## Agent Identities

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| List agent identities | GET | `/agentIdentities` | Lists all agent identity objects in the tenant. |
| Create agent identity | POST | `/agentIdentities` | Creates a new agent identity, typically instantiated from a blueprint. |
| Get agent identity | GET | `/agentIdentities/{id}` | Retrieves a specific agent identity's properties. |
| Update agent identity | PATCH | `/agentIdentities/{id}` | Updates properties of an agent identity. |
| List app role assignments (assigned to) | GET | `/agentIdentities/{id}/appRoleAssignedTo` | Lists users/groups/agents granted an app role for this agent identity. |
| List app role assignments (granted) | GET | `/agentIdentities/{id}/appRoleAssignments` | Lists app roles this agent identity itself has been assigned (i.e. its permissions on other resources). |
| Create app role assignment | POST | `/agentIdentities/{id}/appRoleAssignments` | Grants this agent identity an app role/permission on a resource. |
| Delete app role assignment | DELETE | `/agentIdentities/{id}/appRoleAssignments/{id}` | Revokes an app role assignment from the agent identity. |
| List delegated permission grants | GET | `/agentIdentities/{id}/oauth2PermissionGrants` | Lists delegated permissions authorizing the agent to act on behalf of a signed-in user. |
| List deleted agent identities | GET | `/directory/deletedItems/microsoft.graph.agentIdentity` | Retrieves recently deleted agent identities (recoverable items). |
| List owners | GET | `/agentIdentities/{id}/owners` | Lists the users/groups accountable for the agent's actions and security posture. |
| List sponsors | GET | `/agentIdentities/{id}/sponsors` | Lists sponsors responsible for keeping the agent's access up to date. |

## Agent Users

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| List agent users | GET | `/agentUsers` | Lists agent user accounts (used when an agent needs a full user-style identity). |
| Create agent user | POST | `/agentUsers` | Creates a new agent user. |
| Get agent user | GET | `/agentUsers/{id}` | Retrieves a specific agent user's properties. |
| List sponsors | GET | `/agentUsers/{id}/sponsors` | Lists sponsors for the agent user. |
| List manager | GET | `/agentUsers/{id}/manager` | Gets the manager assigned to the agent user (manager applies to agentUser only, not agentIdentity). |

## Governance metadata (who's accountable)
| Metadata | Applies to | Purpose |
|---|---|---|
| `owner` | `agentIdentityBlueprint`, `agentIdentityBlueprintPrincipal`, `agentIdentity` | Accountable for actions, access, and security posture |
| `sponsor` | `agentIdentityBlueprint`, `agentIdentityBlueprintPrincipal`, `agentIdentity`, `agentUser` | Responsible for keeping access current |
| `manager` | `agentUser` only | Standard org-chart style oversight |

## Conditional Access
Conditional Access policies **do** apply when an agent identity or agent user requests a token to access a resource. They do **not** apply when a blueprint acquires a token purely to create an agent identity/user, or during intermediate token-exchange calls — those steps are inherently locked down and not user-facing resource access.
- Use the **What If evaluation API** (`/identity/conditionalAccess/evaluate`) to simulate how existing CA policies would affect a given agent identity before rolling out.

## Common permissions required
- Permissions follow the same pattern as `servicePrincipal`/`application` management (e.g. `Application.ReadWrite.All`), plus emerging agent-specific permissions — check the Microsoft Learn agent ID permissions reference before building automation, as this area is actively evolving.

## Notes
- `agentIdentity` inherits from `servicePrincipal`, and `agentIdentityBlueprint` inherits from `application` — so many standard app/service principal Graph patterns (app roles, owners) carry over directly.
- Because this is preview/beta-only, treat anything here as **subject to change without notice** — re-verify endpoint paths against Microsoft Learn before relying on them in scripts.
