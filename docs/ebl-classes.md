# EBL Classes - Technical Reference

**Core modeling constructs for the Enterprise Business Language**

---

## Purpose

**Classes** are the top-level modeling constructs that your ANTLR grammar parses and your toolchain compiles into concrete artifacts. Think of them as the "nouns" of the language—each class has a specific purpose in turning controlled business language into data models, workflows, and integrations.

### What EBL Classes are used for

**1. Structure the domain**

They partition requirements into clear, compile-able blocks (e.g., `Entity`, `DataObject`, `Process`) so natural business statements can be mapped to an explicit meta-model.

**2. Drive code generation**

Each class corresponds to generator targets:

| Class | Generates |
|-------|-----------|
| `DataObject` | DB schemas, JSON schemas, API contracts, storage/stream bindings |
| `Entity` | ERM/ORM models linked to `DataObject` (via `dataRef`) |
| `Process` | Workflow/orchestration (BPMN, state machines), handlers, tasks |
| `Rule` | Decision logic (policy/DSL → code or rules engine) |
| `Integration` | Client stubs, connectors, error handling scaffolding |
| `Report` | Query specs, views, scheduled jobs |
| `ITAsset`/`Relationship` | Architecture inventory and dependency graphs |

**3. Enable validation and governance**

Validators check semantic rules *per class*:
- `Entity` **must** reference a `DataObject` via `dataRef`
- Each `DataObject` **must** define `Policies` and `Resources`
- `Relationship` types must be from the allowed set
- Actors/verbs on `Process` steps must satisfy domain whitelists and data-permission rules

**4. Bind business language to execution**

Classes provide the anchors where controlled verbs, actors, policies, SLAs, and permissions attach—so phrases like "**PaymentProcessor Verify via DO_Payment Output**" compile into the *right* read action against the *right* resource with the *right* permission.

---

## Core EBL Classes

### Quick Reference Table

| Class | What it models | Typical outputs |
| --- | --- | --- |
| **DataObject** | Canonical data (schema + policies + IO resources) | DB tables, topics/queues, JSON Schema, API I/O bindings |
| **Entity** | Business entity view (properties) bound to a `DataObject` | ER/ORM classes, capability to data mapping |
| **Process** | Steps, actors, actions, validations, IO | Workflow/state machine, service handlers |
| **Rule** | Triggers, conditions, actions (ECA pattern) | Rules engine artifacts, policy code (OPA/Rego) |
| **Report** | Queries, schedule, payload | Materialized views, dashboards, jobs |
| **Integration** | External provider operations & error handling | API clients, connector shims |
| **ITAsset** | Applications/platforms/systems and attributes | CMDB/architecture registry entries |
| **Relationship** | Typed links between assets/entities | Dependency diagrams, compliance checks |

---

## Detailed Class Specifications

### DataObject

**Purpose**: Define canonical data structures with schema, policies, and I/O resources.

**Required Sections**:
- **Schema**: Field definitions with types and constraints
  - Types: `UUID`, `String`, `Integer`, `Currency`, `Enum`, `Date`, `Boolean`, `JSON`
  - Constraints: `required`, `unique`, `min`, `max`, `encrypted`
- **Policies**: Compliance and governance rules
  - Retention policies
  - Privacy requirements (PII, HIPAA, GDPR)
  - Regulatory compliance (PCI-DSS, SOX, etc.)
- **Resources**: Input/Output channel definitions
  - Channel: `API`, `Stream`, `Database`, `File`
  - Protocol: `HTTPS`, `Kafka`, `SQL`, `S3`
  - Endpoint: URL or connection string
  - Auth: `OAuth2`, `mTLS`, `APIKey`, `JWT`
  - Format: `JSON`, `XML`, `Avro`, `Protobuf`
  - SLA: Performance targets (e.g., `P95<300ms`)
- **erMap**: Traceability link to ERM

**Permission Model**:
- **Input** = Write permission (actor can create/update data)
- **Output** = Read permission (actor can read/query data)

**Example**:
```ebl
DataObject DO_Payment {
  Schema:
    PaymentId: UUID, required, unique
    Amount: Currency, required, min=0
    Status: Enum, values=["Pending","Approved","Settled"]
    AccountNumber: String, encrypted

  Policies:
    - "PCI-DSS: Card data must be encrypted"
    - "Retained 7 years per regulations"

  Resources:
    Input:  { Channel: API, Protocol: HTTPS,
              Endpoint: "https://api.example.com/payment",
              Auth: OAuth2, Format: JSON, SLA: "P95<300ms" }
    Output: { Channel: Stream, Protocol: Kafka,
              Endpoint: "kafka://payments/processed",
              Auth: mTLS, Format: JSON, SLA: "P99<100ms" }

  erMap: PaymentDO
}
```

---

### Entity

**Purpose**: Define business entities that reference DataObjects and add business logic.

**Required Sections**:
- **dataRef**: Must reference a `DataObject`
- **Properties**: Business view of data with types and constraints
- **Rules** (optional): Business validation constraints
- **erMap**: Traceability link to ERM

**Validation**:
- DataRef must point to a defined DataObject
- Properties should align with DataObject schema

**Example**:
```ebl
Entity Payment {
  dataRef: DO_Payment
  Properties:
    PaymentId: { type: UUID, required: true, unique: true }
    Amount: { type: Currency, required: true, min: 0 }
    Status: { type: Enum, values: ["Pending","Approved","Settled"],
              default: "Pending" }
  Rules:
    - "Amount > 10000 requires dual authorization"
  erMap: PaymentEntity
}
```

---

### Process

**Purpose**: Define business process workflows with actors, steps, and events.

**Required Sections**:
- **Description**: Human-readable process description
- **ObjectiveID**: Link to business objective
- **BusinessGoalID**: Link to business goal
- **Actors**: List of roles participating in the process
- **erMap**: Traceability link to ERM Process
- **Starts With**: Initial event
- **Ends With**: Terminal event
- **Steps**: Process steps with actions and validations

**Step Structure**:
- **Inputs** (optional): Data inputs for the step
- **Validation** (optional): Business rules that must be satisfied
- **Actions**: Actor-verb-DataObject triples
  - Format: `[Actor] [Verb] via [DataObject] [Input|Output]`
  - Input = write permission
  - Output = read permission
- **Conditions** (optional): Branching logic

**Example**:
```ebl
Process PaymentProcessing {
  Description: "Screen, approve, and settle payments"
  ObjectiveID: PAY1
  BusinessGoalID: COMPLIANCE1
  Actors: [PaymentProcessor, FraudAnalyst, ComplianceOfficer]
  erMap: PaymentProcess

  Starts With: Event PaymentReceived(Payment)

  Step ScreenPayment {
    Validation:
      - Amount MUST be validated
      - Counterparty MUST be screened
    Actions:
      - FraudAnalyst Screen via DO_Payment Output
      - PaymentProcessor Verify via DO_Payment Output
  }

  Step ApprovePayment {
    Validation:
      - Screening MUST be complete BEFORE approval
    Actions:
      - ComplianceOfficer Approve via DO_Payment Input
  }

  Ends With: Event PaymentSettled(Payment)
}
```

---

### Rule

**Purpose**: Define business rules using Event-Condition-Action (ECA) pattern.

**Structure**:
- **ON** clause: Event trigger
- **WHEN** clause: Condition evaluation
- **THEN** clause: Action to execute
- **ELSE** clause (optional): Alternative action

**Temporal Keywords**:
- **WITHIN**: Duration limit (e.g., `WITHIN 24h`)
- **BEFORE**: Precedence constraint
- **AFTER**: Succession constraint
- **BY**: Deadline

**Modality Keywords**:
- **SHALL**: Mandatory requirement
- **MUST NOT**: Prohibited action
- **SHOULD**: Recommended action
- **MAY**: Optional action

**Example**:
```ebl
Rule AML_Screening {
  ON PaymentInitiated
  WHEN Amount > 10000 AND Country IN ["High-Risk-List"]
  THEN Screen via SanctionsDatabase
       AND Escalate to ComplianceOfficer
}

Rule SAE_Reporting {
  ON SeriousAdverseEvent
  WHEN Severity IN ["Life-Threatening", "Death"]
  THEN Report WITHIN 24h TO Sponsor AND IRB
}
```

---

### ITAsset

**Purpose**: Define IT infrastructure components (applications, systems, platforms).

**Attributes**:
- **Type**: Application, System, Platform
- **Platform**: Deployment platform (AWS, Azure, On-Premise)
- **Attributes**: Key-value pairs for metadata

**Example**:
```ebl
ITAsset PaymentGateway {
  Type: Application
  Platform: AWS
  Attributes:
    - Version: 2.1.0
    - Region: us-east-1
    - SLO: 99.95%
}
```

---

### Relationship

**Purpose**: Define typed relationships between entities, processes, or IT assets.

**Relationship Types**:
- **depends_on**: Dependency relationship
- **hosted_on**: Hosting/deployment relationship
- **supports**: Support relationship
- **communicates_with**: Communication relationship
- **accesses**: Data access relationship
- **debits_from** / **credits_to**: Financial relationships

**Example**:
```ebl
Relationship PaymentService_Dependency {
  From: PaymentProcessingService
  To: PaymentGateway
  Type: depends_on
}

Relationship Payment_Account {
  From: Payment
  To: Account
  Type: debits_from
}
```

---

### Integration

**Purpose**: Define external system integrations with operations and error handling.

**Sections**:
- **Provider**: External system name
- **Operations**: Available operations/endpoints
- **ErrorHandling**: Retry logic and failure handling
- **Authentication**: Auth mechanism

**Example**:
```ebl
Integration SanctionsScreening {
  Provider: OFAC_API
  Operations:
    - Screen: POST /screen
    - Batch: POST /batch-screen
  ErrorHandling:
    - Retry: 3 attempts with exponential backoff
    - Timeout: 5s
  Authentication: APIKey
}
```

---

### Report

**Purpose**: Define reporting requirements with queries and schedules.

**Sections**:
- **Query**: Data query specification
- **Schedule**: Execution schedule
- **Format**: Output format
- **Destination**: Where to send/store the report

**Example**:
```ebl
Report DailyTransactionSummary {
  Query:
    SELECT Date, SUM(Amount), COUNT(*)
    FROM Payments
    WHERE Status = 'Settled'
    GROUP BY Date
  Schedule: EVERY 1 day AT 09:00 UTC
  Format: CSV
  Destination: s3://reports/daily/
}
```

---

## Example: Classes Working Together

This comprehensive example shows how all classes integrate:

```ebl
Metadata:
  Domain: banking
  Owner: Payments
  Version: 0.85

// 1. Define the data structure
DataObject DO_Payment {
  Schema:
    PaymentId: UUID, required, unique
    Amount: Currency, required, min=0
    Status: Enum, values=["Pending","Approved","Settled"]

  Policies:
    - "PCI-DSS: Encrypted in transit and at rest"
    - "SOX: Dual authorization for amounts > $10,000"

  Resources:
    Input:  { Channel: API, Protocol: HTTPS, ... }
    Output: { Channel: Stream, Protocol: Kafka, ... }

  erMap: PaymentDO
}

// 2. Define the business entity
Entity Payment {
  dataRef: DO_Payment
  Properties:
    PaymentId: { type: UUID, required: true }
    Amount: { type: Currency, required: true }
  Rules:
    - "High-value payments require enhanced screening"
  erMap: PaymentEntity
}

// 3. Define the business process
Process PaymentProcessing {
  Description: "End-to-end payment processing"
  Actors: [PaymentProcessor, FraudAnalyst, ComplianceOfficer]
  erMap: PaymentProcess

  Starts With: Event PaymentReceived(Payment)

  Step Screen {
    Actions:
      - FraudAnalyst Screen via DO_Payment Output
  }

  Step Approve {
    Actions:
      - ComplianceOfficer Approve via DO_Payment Input
  }

  Ends With: Event PaymentSettled(Payment)
}

// 4. Define business rules
Rule HighValueScreening {
  ON PaymentReceived
  WHEN Amount > 10000
  THEN Screen via FraudEngine AND Notify ComplianceOfficer
}

// 5. Define IT assets
ITAsset PaymentGateway {
  Type: Application
  Platform: AWS
  Attributes:
    - SLO: 99.95%
}

// 6. Define relationships
Relationship Service_Gateway {
  From: PaymentService
  To: PaymentGateway
  Type: depends_on
}

// 7. Define integrations
Integration FraudScreening {
  Provider: FraudEngine_API
  Operations:
    - Screen: POST /fraud/screen
  ErrorHandling:
    - Retry: 3 attempts
}

// 8. Define reports
Report DailyPayments {
  Query: SELECT Date, SUM(Amount) FROM Payments GROUP BY Date
  Schedule: EVERY 1 day AT 09:00 UTC
  Format: CSV
}
```

---

## Validation Rules

### Cross-Class Validation

1. **Entity → DataObject**: Every Entity must reference a defined DataObject via `dataRef`

2. **Process Actions**: Actor-verb-DataObject triples must satisfy:
   - Actor exists in vertical dictionary
   - Verb is permitted for that actor
   - DataObject exists
   - Permission aligns (Input=write, Output=read)

3. **Relationships**: Both endpoints (From/To) must reference defined entities or IT assets

4. **Integration Operations**: Must reference valid external endpoints

### Compliance Validation

Different verticals enforce domain-specific compliance rules:

**Banking**:
- PCI-DSS: Card data encryption, CVV non-storage
- SOX: Dual authorization for wire transfers
- AML: Sanctions screening for international payments

**Healthcare**:
- HIPAA: PHI encryption and access controls
- FDA: Adverse event reporting timelines
- GCP: Informed consent requirements

**Retail**:
- Service level targets
- Inventory thresholds
- Fulfillment SLAs

---

## Code Generation

Each class maps to specific generated artifacts:

| Class | Generated Artifacts |
|-------|-------------------|
| DataObject | Database schemas (SQL DDL), JSON Schema, OpenAPI specs, Kafka topics |
| Entity | ORM classes (Java/Python), GraphQL types, Domain models |
| Process | BPMN workflows, State machines, Service handlers, Orchestration code |
| Rule | OPA/Rego policies, Decision tables, Rules engine config |
| ITAsset | CMDB entries, Architecture diagrams (ArchiMate) |
| Relationship | Dependency graphs, Compliance reports |
| Integration | API clients, Connector code, Error handlers |
| Report | SQL views, BI dashboards, Scheduled jobs |

---

## Why This Matters

EBL Classes give you a **strict, generative backbone**: they let you write requirements once in controlled natural language and then **compile** them into consistent data/architecture/application artifacts—with linting and governance built in.

**Key Benefits**:

1. **Single Source of Truth**: Business requirements directly generate executable artifacts
2. **Consistency**: Dictionary-driven validation ensures uniform vocabulary
3. **Traceability**: `erMap` attributes link requirements to implementations
4. **Compliance**: Domain-specific validators enforce regulatory rules
5. **Automation**: Generate schemas, APIs, workflows, and policies automatically

---

**For more information**:
- **[ebl-overview.md](ebl-overview.md)** - Architecture and lexicon reference
- **[GETTING_STARTED.md](../GETTING_STARTED.md)** - Tutorial with examples
- **[data_model/](data_model/)** - ERM schemas and traceability models

---

*Version 0.85 | ANTLR-Based Vertical Independence | 2025-11-05*
