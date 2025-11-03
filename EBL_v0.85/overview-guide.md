
# What you get at a glance

* **React app** with a **Hierarchy Explorer** (Org → Domain → Department → Project) featuring collapsible nodes, right-click context menus, and role-based permissions.
* **Dictionary Studio** to manage capabilities, objectives, processes, apps/systems—auto-versioned into the **Enterprise Business Language (EBL)** dictionary/grammar.
* **Requirements Console** to import from Jira/ServiceNow, convert to EBL, dedupe, and validate against grammar + dictionary.
* **Model Builder** to generate, view, and export **ArchiMate** models (including Archi Open Exchange).
* **Go services** for hierarchy, dictionary, requirements, EBL parsing/conversion, validation, and ArchiMate export; plus Jira/ServiceNow connectors, LLM/SLM inference gateway, and OPA-backed permissions.

---

## Frontend (React)

**Tech:** React + TypeScript, React Router, React Query (server state), Zustand (local app state), shadcn/ui + Tailwind, Radix for menus, Monaco Editor for EBL, Recharts (optional metrics), XState (task orchestration UI), WebSocket for job progress.

### Core Screens & Components

1. **Hierarchy Explorer**

   * **Tree**: Organisation ▸ Domain ▸ Department ▸ Project
   * **Features**: collapsible nodes, lazy loading, right-click context menus (Create, Rename, Delete), drag-and-drop reorder (with policy guard), search & filter.
   * **Permissions badge**: owner / editor / viewer; inline request-access flow.
   * **Component sketch**

     * `<HierarchyTree />`
       └─ `<TreeNode />` (context menu, inline rename)
       └─ `<PermissionChip />`
       └─ `<NodeToolbar />` (Create child / Import / Settings)

2. **Dictionary Studio**

   * **Tabs**: Capabilities | Objectives | Process Activities | Applications | Systems | Data Objects
   * **Grid + Detail** pattern: left list/grid; right side panel editor.
   * **Versioning**: “Proposed” → “Approved” (with diff & audit trail).
   * **Grammar sync**: save triggers EBL dictionary/grammar update; shows compile status.

3. **Requirements Console**

   * **Import wizard**: Jira/ServiceNow—map fields → preview → transform rules → import.
   * **EBL conversion queue**: per requirement → “Converted”, “Needs Review”, “Conflicted”.
   * **Duplicate finder**: near-duplicate clustering (embedding similarity) with merge suggestions.
   * **Validation panel**: grammar parse tree, dictionary lookups, policy hits, fix-it suggestions.

4. **Model Builder (ArchiMate)**

   * **From EBL → ArchiMate**: generate Business / Application layers.
   * **Viewer/Editor**: lightweight canvas for small edits, or export to **Archi Open Exchange** for full editing in Archi.
   * **Traceability**: click an EBL element to highlight mapped ArchiMate elements; back-links to requirements.

### Cross-cutting UI

* **Right-click Context Menus** on tree nodes:

  * Create (Domain/Department/Project), Rename, Delete, Manage Permissions.
* **Role-aware UI**: actions greyed or hidden based on owner/editor/viewer.
* **Jobs Drawer** (WebSocket updates): imports, conversions, validations, model generation.

---

## Backend (Go)

**Tech:** Go 1.22+, Gin/Fiber (HTTP), gRPC (service mesh), PostgreSQL (+ pgvector), Redis (queue/cache), MinIO/S3 (artifacts), OPA (authZ), OpenAPI spec, Wire for DI, Temporal/Asynq for jobs, OTel for tracing.

### Services (clean, modular)

1. **Identity & AuthZ**

   * OIDC/OAuth2 (e.g., Auth0/Azure AD).
   * **OPA** sidecar for policy decisions (RBAC + hierarchy inheritance + object ACLs).
2. **Hierarchy Service**

   * CRUD for Organisation/Domain/Department/Project.
   * Permission model with inheritance + overrides.
3. **Dictionary Service**

   * Entities: Capability, Objective, ProcessActivity, Application, System, DataObject.
   * Versioning/state: Draft/Proposed/Approved; change sets; audit trail.
   * **Grammar sync**: regenerates dictionary bundles (JSON) for the EBL parser.
4. **Requirements Service**

   * Importers: Jira/ServiceNow (webhooks + on-demand sync).
   * Canonical schema for requirements; attachments & provenance.
   * Duplicate detection (pgvector cosine similarity).
5. **EBL Service**

   * **LLM/SLM gateway** (conversion prompts + RAG from Dictionary).
   * ANTLR-based EBL grammar parser for compile/validate.
   * Lint rules (naming, cardinality, policy tags).
6. **Validation Service**

   * Grammar validation, dictionary references, **dup checks**, and policy pre-checks.
7. **Model Service (ArchiMate)**

   * EBL → ArchiMate element mapping; relationship synthesis.
   * Export **ArchiMate Open Exchange (.xml)** and JSON.
8. **Integration Service**

   * Jira/ServiceNow connectors (OAuth, field mapping, pagination).
   * Webhooks → events → job orchestrations (Temporal/Asynq).
9. **Jobs/Events**

   * Queued pipelines for import → convert → validate → model-gen; idempotent, resumable.
10. **Audit & Observability**

* Structured audit logs (who/what/when/where).
* OTel traces across API and jobs.

---

## Permissions Model (Owner / Editor / Viewer)

* **Scopes**: assigned at any level (Org/Domain/Department/Project).
* **Inheritance**: lower levels inherit parent grants; explicit denies override.
* **Object ACLs**: dictionary objects and requirements can have more restrictive ACLs than their parent project.
* **OPA Policies** (illustrative):

  * `allow_create(node, actor)` if `role in {owner, editor}` at node or ancestor.
  * `allow_delete(node)` only if `owner` at node and **no protected children**.
  * `allow_view(object)` if viewer+ at project or object ACL grants viewer.

---

## Data Model (simplified)

```sql
-- hierarchy
organisations(id, name, ...)
domains(id, organisation_id, name, ...)
departments(id, domain_id, name, ...)
projects(id, department_id, name, ...)

-- permissions
roles(actor_id, scope_type, scope_id, role) -- owner|editor|viewer

-- dictionary
dictionary_objects(id, project_id, type, name, state, version, metadata_jsonb)
-- type: capability|objective|process_activity|application|system|data_object

-- requirements
requirements(id, external_ref, project_id, title, body_jsonb, embeddings vector)
requirement_links(requirement_id, dict_object_id)

-- ebl artifacts
ebl_modules(id, requirement_id, text, status, diagnostics_jsonb)

-- models
archimate_models(id, project_id, layer, payload_xml, created_at)
```

---

## Key REST/gRPC Endpoints (sample)

* `POST /api/hierarchy/{level}` create node (OPA-guarded)
* `PATCH /api/hierarchy/{level}/{id}` rename/move
* `DELETE /api/hierarchy/{level}/{id}`
* `POST /api/permissions/grant` (actor, scope, role)
* `GET /api/dictionary?projectId=...&type=...`
* `POST /api/dictionary/{type}` create/update (triggers grammar sync)
* `POST /api/requirements/import/jira` (mapping config)
* `POST /api/requirements/{id}/convert-ebl` → job id (WebSocket progress)
* `POST /api/requirements/{id}/validate` → diagnostics
* `GET /api/requirements/duplicates?projectId=...`
* `POST /api/models/archimate/generate?projectId=...`
* `GET /api/models/archimate/{id}/export` (Archi Open Exchange XML)

*WebSocket*: `/ws/jobs/{jobId}` for streaming status (queued → running → success/error, with logs).

---

## How the 4 Required Capabilities Flow

1. **Create Objects/Entities (Dictionary Studio)**

* Create/edit capabilities, objectives, process activities, applications, systems within the selected **Project**.
* Save triggers **dictionary versioning** and **grammar bundle** update; downstream EBL conversions use the latest approved dictionary.
* Auto-link created entities to the Project in the hierarchy; policies enforced by OPA.

2. **Requirement Input & EBL Conversion (Requirements Console)**

* Import from Jira/ServiceNow; map fields (summary/description/ACs/labels).
* Conversion pipeline: RAG (dictionary), LLM/SLM prompts → EBL draft → human-in-the-loop quick fixes → finalize.
* Provenance stored; changes re-convert incrementally.

3. **Requirement Validation (Grammar + Dictionary + Duplicates)**

* ANTLR parse + semantic checks against dictionary; missing or ambiguous entities flagged with fix-its.
* Duplicate detection via embeddings with threshold & reviewer merge action.

4. **ArchiMate Models (Generate/View/Edit/Export)**

* EBL → ArchiMate mapping (business processes, actors, application services, data objects).
* Inline viewer for quick edits; export **Open Exchange** XML to refine in **Archi**; maintain round-trip by keeping stable IDs.

---

## Developer Notes & Non-functional

* **Security**: OIDC, OPA, audit logs, least-privilege; PII redaction on ingest.
* **Scalability**: stateless API pods, job workers with concurrency controls; Postgres read replicas.
* **Resilience**: idempotent jobs, retry/backoff, circuit breakers to LLM gateway and Jira APIs.
* **Versioning**: dictionary + grammar are immutable artifacts; requirements and models record lineage.
* **Testing**: contract tests for integrations; golden files for EBL/ArchiMate exports; load tests for imports.
