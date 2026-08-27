# Application Proxy — Microsoft Graph API Endpoints

Application Proxy lets you publish on-premises web apps for secure remote access, without a VPN — using lightweight on-prem **connectors** grouped into **connector groups**.

Base URL: `https://graph.microsoft.com/{version}/onPremisesPublishingProfiles/applicationProxy/`

> ⚠️ Most of this API surface is **beta-only** — v1.0 support is limited, mainly to connector/connectorGroup listing and the `onPremisesPublishing` property on the `application` object itself.

## Connectors

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List connectors | GET | `/onPremisesPublishingProfiles/applicationProxy/connectors` | same | Lists on-premises connector agents registered in the tenant. |
| Get a connector | GET | `/onPremisesPublishingProfiles/applicationProxy/connectors/{id}` | same | Retrieves details of a specific connector (status, version, machine name). |
| List connector's groups | GET | `/onPremisesPublishingProfiles/applicationProxy/connectors/{id}/memberOf` | same | Lists the connector group(s) this connector belongs to. |

## Connector Groups

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| List connector groups | GET | `/onPremisesPublishingProfiles/applicationProxy/connectorGroups` | same | Lists connector groups (used for HA/load-balancing and assigning connectors to apps). If none are created, all connectors sit in the default group. |
| Get a connector group | GET | `/onPremisesPublishingProfiles/applicationProxy/connectorGroups/{id}` | same | Retrieves a specific connector group's details. |
| Create connector group | POST | Not available in v1.0 | `/onPremisesPublishingProfiles/applicationProxy/connectorGroups` | Creates a new connector group. |
| Update connector group | PATCH | Not available in v1.0 | `/onPremisesPublishingProfiles/applicationProxy/connectorGroups/{id}` | Updates group name or region. |
| Delete connector group | DELETE | Not available in v1.0 | `/onPremisesPublishingProfiles/applicationProxy/connectorGroups/{id}` | Deletes a connector group. All connectors and applications must be removed from it first. |
| Add connector to group | POST | Not available in v1.0 | `/onPremisesPublishingProfiles/applicationProxy/connectorGroups/{id}/members/$ref` | Assigns a connector to this group. |
| List applications in group | GET | Not available in v1.0 | `/onPremisesPublishingProfiles/applicationProxy/connectorGroups/{id}/applications` | Lists apps published through this connector group. |
| Assign application to group | PUT | Not available in v1.0 | `/applications/{id}/connectorGroup/$ref` | Assigns a published application to a specific connector group (called on the application object, referencing the connector group). |

## Publishing an App (via the `application` object)

| Action | Method | v1.0 Endpoint | Beta Endpoint | Description |
|---|---|---|---|---|
| Configure on-prem publishing | PATCH | `/applications/{id}` (`onPremisesPublishing` property) | same | Configures `externalUrl`, `internalUrl`, `externalAuthenticationType`, header translation, and timeout settings on an app registration to publish it via Application Proxy. |

## Key `onPremisesPublishing` properties (set via PATCH on the application)
| Property | Purpose |
|---|---|
| `externalUrl` | The public-facing URL users hit from outside the network |
| `internalUrl` | The actual internal URL the connector routes traffic to |
| `externalAuthenticationType` | Pre-authentication method (e.g. Entra ID, Passthrough) |
| `isTranslateHostHeaderEnabled` | Whether host headers are rewritten between internal/external |
| `isTranslateLinksInBodyEnabled` | Whether links inside the HTML response body get rewritten |
| `applicationServerTimeout` | Backend timeout tolerance (`default` or `long`) |

## Common permissions required
- `Directory.ReadWrite.All` — required for most connector group management (create/update/delete)
- `Application.ReadWrite.All` — required to configure `onPremisesPublishing` on an app registration

## Notes
- A connector group can't be deleted while it still has connectors or applications assigned — remove/reassign those first.
- Application Proxy is one of several Azure services that share the underlying "on-premises publishing profile" model — Entra Connect Pass-through Authentication and Workday provisioning use the same connector/agent concept, just under different profile types.
- Most of the actual create/update/delete management here is beta-only; v1.0 mainly supports read (GET) operations for connectors and connector groups.
