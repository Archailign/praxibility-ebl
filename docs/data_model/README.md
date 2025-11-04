# EBL Enterprise Relationship Model (ERM) Schemas

This directory contains SQL schema definitions for the EBL Enterprise Relationship Model, which provides the data foundation for traceability between business goals, requirements, capabilities, and technical implementations.

## Files

### 1. `entity_relationship_model.txt`
**Purpose:** Reference ERM schema using UUID primary keys

**Characteristics:**
- UUID-based primary keys (enterprise/cloud-native approach)
- Includes core traceability entities:
  - BusinessGoal → Objective → BusinessProcess → Requirement
  - Capability → DataObject → Policy → Application
- Fields for Architecture-as-Code and IaC storage (Project table)
- Suitable for distributed systems and microservices architectures

**Use Cases:**
- Cloud-native implementations
- Distributed enterprise systems
- Cross-platform traceability
- ArchiMate model integration

### 2. `erm_schema.txt`
**Purpose:** Extended ERM schema with additional tracking and organizational hierarchy

**Characteristics:**
- INT AUTO_INCREMENT primary keys (traditional RDBMS approach)
- Additional organizational hierarchy:
  - Organisation → Domain → Project
- Extended tracking capabilities:
  - CapabilityPerformance (metrics tracking)
  - TraceLink (flexible relationship tracking)
  - ArchitecturePattern (AaaS/IaaS/PaaS patterns)
- Optimized with indexes for performance
- More comprehensive status and lifecycle tracking

**Use Cases:**
- Traditional enterprise databases (MySQL/MariaDB)
- Multi-tenant organizational structures
- Performance monitoring and analytics
- Comprehensive audit trails

## Key Entities

Both schemas implement these core ERM entities:

| Entity | Purpose |
|--------|---------|
| **BusinessGoal** | Strategic goals linked to projects |
| **Objective** | Specific measurable objectives supporting goals |
| **Actor** | Roles and stakeholders |
| **BusinessProcess** | Process workflows linking objectives to requirements |
| **Requirement** | Business requirements tied to EBL classes |
| **EBLClass** | EBL language constructs (DataObject, Entity, Process, etc.) |
| **Capability** | Business capabilities delivering outcomes |
| **DataObject** | Data structures with policies and sensitivity levels |
| **Policy** | Governance and compliance policies |
| **Application** | IT applications implementing capabilities |
| **Project** | Projects containing compiled artifacts (AaC/IaC) |

## Traceability Flow

```
BusinessGoal
    ↓
Objective (+ Actors)
    ↓
BusinessProcess (+ Process Owner)
    ↓
Requirement (+ EBLClass reference)
    ↓
Capability (+ DataObject, Policy)
    ↓
Application (+ ArchitecturePattern)
    ↓
Project (stores AaC/IaC artifacts)
```

## Implementation Guidance

### Choosing a Schema

- **Use `entity_relationship_model.txt` when:**
  - Building cloud-native applications
  - Implementing microservices architecture
  - Requiring globally unique identifiers
  - Integrating with external systems via UUIDs

- **Use `erm_schema.txt` when:**
  - Working with traditional enterprise databases
  - Needing comprehensive performance tracking
  - Requiring organizational multi-tenancy
  - Building analytics and reporting systems

### Integration with EBL

The EBL `erMap` attribute in language constructs maps to these database entities:

```ebl
DataObject DO_Campaign {
  Schema:
    CampaignId: UUID, required, unique
  Policies:
    - "Retained 2 years"
  Resources:
    Input: { Channel: API, ... }
    Output: { Channel: Stream, ... }
  erMap: CampaignDO  # ← Maps to DataObject table record
}

Entity Campaign {
  dataRef: DO_Campaign
  Properties:
    CampaignId: { type: UUID, required: true }
  erMap: Campaign  # ← Maps to EBLClass table record
}

Process CampaignManagement {
  Description: "Manage ad campaigns"
  ObjectiveID: OBJ-ADTECH-001  # ← Links to Objective table
  BusinessGoalID: BG-ADTECH-001  # ← Links to BusinessGoal table
  Actors: [MediaBuyer, DataAnalyst]  # ← Links to Actor table
  erMap: CampaignMgmt  # ← Maps to BusinessProcess table record
  ...
}
```

## Extending the Schema

To add custom domain-specific entities:

1. Extend from core entities (BusinessProcess, DataObject, etc.)
2. Maintain foreign key relationships for traceability
3. Add appropriate indexes for query performance
4. Document custom tables in this README
5. Update EBL dictionary and grammar as needed

## Version Alignment

These schemas are aligned with **EBL v0.85**. When updating EBL grammar or dictionary:

1. Review schema impact
2. Add/modify tables as needed
3. Update migration scripts
4. Version the schema files appropriately
5. Update this README with changes

---

**Note:** These schemas represent the data model foundation that enables EBL's core value proposition: **end-to-end traceability from business goals to executable code**.
