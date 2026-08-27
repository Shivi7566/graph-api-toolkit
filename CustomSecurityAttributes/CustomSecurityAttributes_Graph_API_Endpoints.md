# Custom Security Attributes — Microsoft Graph API Endpoints

Custom security attributes are business-specific key-value pairs you define and assign to Entra objects (users, service principals, etc.) — useful for categorization and fine-grained Azure ABAC (attribute-based access control).

Base URL: `https://graph.microsoft.com/{version}/directory/`

> ⚠️ This entire API is **beta-only** — no v1.0 support yet, despite being a stable, widely-used feature in the admin portal.

## The model (three layers)
1. **Attribute Set** — a named grouping/category (e.g. "Engineering"). Can't be renamed or deleted once created.
2. **Custom Security Attribute Definition** — the actual attribute schema within a set (e.g. "ProjectDate", type String). Can't be renamed/deleted, only deactivated.
3. **Allowed Value** — a predefined value option for a definition (e.g. "ProjectStatus" could allow "Active"/"OnHold"/"Complete"). Can't be renamed/deleted, only deactivated.

## Attribute Sets

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| List attribute sets | GET | `/directory/attributeSets` | Lists all attribute sets (up to 500 per tenant). |
| Get an attribute set | GET | `/directory/attributeSets/{id}` | Retrieves a specific attribute set. |
| Create attribute set | POST | `/directory/attributeSets` | Creates a new attribute set. Name can't include spaces or special characters, and can't be changed after creation. |
| Update attribute set | PATCH | `/directory/attributeSets/{id}` | Updates the description (name itself is immutable). |

## Custom Security Attribute Definitions

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| List definitions | GET | `/directory/customSecurityAttributeDefinitions` | Lists all attribute definitions across all sets. |
| Get a definition | GET | `/directory/customSecurityAttributeDefinitions/{id}` | Retrieves a specific attribute definition. |
| Create definition | POST | `/directory/customSecurityAttributeDefinitions` | Creates a new attribute within an existing set. Requires `attributeSet`, `name`, `type` (Boolean/Integer/String), `status`, and `usePreDefinedValuesOnly`. |
| Update definition | PATCH | `/directory/customSecurityAttributeDefinitions/{id}` | Can update `description` and `status` (Available/Deprecated). Can flip `usePreDefinedValuesOnly` from `true` → `false` but never the reverse. |

## Allowed Values

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| List allowed values | GET | `/directory/customSecurityAttributeDefinitions/{id}/allowedValues` | Lists predefined values for a definition (up to 100 per definition). |
| Get an allowed value | GET | `/directory/customSecurityAttributeDefinitions/{id}/allowedValues/{id}` | Retrieves a specific allowed value. |
| Create allowed value | POST | `/directory/customSecurityAttributeDefinitions/{id}/allowedValues` | Adds a new predefined value option. |
| Update allowed value | PATCH | `/directory/customSecurityAttributeDefinitions/{id}/allowedValues/{id}` | Deactivates/reactivates a value (values can't be renamed or deleted). |

## Assigning Values to Objects (e.g. Users)

| Action | Method | Beta Endpoint | Description |
|---|---|---|---|
| Read a user's attribute values | GET | `/users/{id}?$select=customSecurityAttributes` | Retrieves custom security attribute values assigned to a specific user. Must query by specific ID — `/me` with this `$select` returns null. |
| Assign/update attribute values | PATCH | `/users/{id}` (`customSecurityAttributes` property) | Sets values for the user's custom security attributes. Same pattern applies to service principals. |

## Data types & rules
| Type | Notes |
|---|---|
| `Boolean` | Can't use `usePreDefinedValuesOnly: true` for Boolean types. |
| `Integer` | Whole numbers only. |
| `String` | Can be single-value or a collection (`isCollection: true`), free-form or restricted to allowed values. |

## Common permissions required
- `CustomSecAttributeDefinition.ReadWrite.All` — create/manage attribute sets and definitions
- `CustomSecAttributeAssignment.ReadWrite.All` — assign/update/remove values on objects (users, service principals)
- Plus the resource object's own read permission (e.g. `User.Read.All`) is needed alongside the above when reading assignments

## Notes
- By default, **even Global Administrator does not have permission** to read, define, or assign custom security attributes — a dedicated role (e.g. Attribute Definition Administrator, Attribute Assignment Administrator) must be explicitly assigned.
- Attribute sets, definitions, and allowed values are all designed to be permanent once created — plan naming carefully, since you can only deactivate, never rename or delete.
- This is a different mechanism from the older `extensionProperties` / "directory extensions" (used for custom user attributes via app registrations) — don't confuse the two; they're separate features with separate endpoints.
