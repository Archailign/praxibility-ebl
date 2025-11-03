**Classes** are the top-level modeling constructs that your grammar parses and your toolchain compiles into concrete artifacts. Think of them as the “nouns” of the language—each class has a specific purpose in turning controlled business language into data models, workflows, and integrations.

### What EBL Classes are used for

* **Structure the domain**
  They partition requirements into clear, compile-able blocks (e.g., `Entity`, `DataObject`, `Process`) so natural business statements can be mapped to an explicit meta-model.

* **Drive code generation**
  Each class corresponds to generator targets:

  * `DataObject` → DB schemas, JSON schemas, API contracts, storage/stream bindings
  * `Entity` → ERM/ORM models linked to `DataObject` (via `dataRef`)
  * `Process` → workflow/orchestration (BPMN, state machines), handlers, tasks
  * `Rule` → decision logic (policy/DSL → code or rules engine)
  * `Integration` → client stubs, connectors, error handling scaffolding
  * `Report` → query specs, views, scheduled jobs
  * `ITAsset`/`Relationship` → architecture inventory and dependency graphs

* **Enable validation and governance**
  Validators check semantic rules *per class*:
  e.g., `Entity` **must** reference a `DataObject`; each `DataObject` **must** define `Policies` and `Resources`; `Relationship` types must be from the allowed set; and actors/verbs on `Process` steps must satisfy domain whitelists and data-permission rules.

* **Bind business language to execution**
  Classes provide the anchors where controlled verbs, actors, policies, SLAs, and permissions attach—so phrases like “**AdServer Deliver via DO_Impression Input**” compile into the *right* write action against the *right* resource with the *right* permission.

---

### The core EBL Classes (at a glance)

| Class          | What it models                                            | Typical outputs                                         |
| -------------- | --------------------------------------------------------- | ------------------------------------------------------- |
| `DataObject`   | Canonical data (schema + policies + IO resources)         | DB tables, topics/queues, JSON Schema, API I/O bindings |
| `Entity`       | Business entity view (properties) bound to a `DataObject` | ER/ORM classes, capability to data mapping              |
| `Process`      | Steps, actors, actions, validations, IO                   | Workflow/state machine, service handlers                |
| `Rule`         | Triggers, conditions, actions                             | Rules engine artifacts, policy code                     |
| `Report`       | Queries, schedule, payload                                | Materialized views, dashboards, jobs                    |
| `Integration`  | External provider operations & error handling             | API clients, connector shims                            |
| `ITAsset`      | Applications/platforms/systems and attributes             | CMDB/architecture registry entries                      |
| `Relationship` | Typed links between assets/entities                       | Dependency diagrams, compliance checks                  |

---

### Tiny example showing how classes work together

```ebl
DataObject DO_Order {
  Schema:
    OrderId: UUID, required, unique
    CustomerId: UUID, required
    Total: Currency, min=0
  Policies:
    - "PII masked at export; 7-year retention"
  Resources:
    Input:  { Channel: API, Protocol: HTTPS, Endpoint: "https://svc/order/in",  Auth: OAuth2, Format: JSON, SLA: "P95<300ms" }
    Output: { Channel: Stream, Protocol: Kafka, Endpoint: "kafka://order/out", Auth: mTLS,  Format: JSON, SLA: "P99<100ms" }
  erMap: OrderDO
}

Entity Order {
  dataRef: DO_Order
  Properties:
    OrderId: { type: UUID, required: true, unique: true }
  erMap: Order
}

Process Fulfilment {
  Description: "Pick → Pack → Ship"
  ObjectiveID: OPS
  BusinessGoalID: SLA
  Actors: [WarehouseManager, Picker, Packer, LogisticsCoordinator]
  erMap: Fulfilment
  Starts With: Event OrderReady(Order)
  Step PickPackShip {
    Actions:
      - Picker Pick via DO_Order Output
      - Packer Pack via DO_Order Output
      - LogisticsCoordinator Ship via DO_Order Input
  }
  Ends With: Event OrderShipped(Order)
}

Relationship WMS_Hosting {
  From: WarehouseManagementSystem
  To:   CloudPlatformX
  Type: hosted_on
}
```

* `DataObject` defines **what** the data is and **how** it flows (`Resources`), with policies/SLA.
* `Entity` binds business semantics to that data (`dataRef`).
* `Process` ties **actors** and **verbs** to **data** (with Input=write, Output=read), which your validators check against the dictionary’s actor→verb and data permissions.
* `Relationship` captures runtime/platform topology for architecture and governance.

---

### Why this matters

EBL Classes give you a **strict, generative backbone**: they let you write requirements once in controlled natural language and then **compile** them into consistent data/architecture/application artifacts—with linting and governance built in.
