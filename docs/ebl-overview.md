# Archailign EBL Architecture

**Structured Requirements. Executable Code. Seamless Traceability.**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![ANTLR](https://img.shields.io/badge/ANTLR-4-orange.svg)](https://www.antlr.org/)
[![Status](https://img.shields.io/badge/Status-Alpha-red.svg)](https://github.com/Archailign/praxibility-ebl)
[![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-brightgreen.svg)](../CONTRIBUTING.md)

---

## Overview

**Archailign EBL** is Praxibility's implementation of the Enterprise Business Language (EBL)—a domain-specific, extensible controlled language for expressing business requirements as validated, traceable, compilable artefacts.

It bridges strategy and implementation by combining:
- A curated **enterprise lexicon** (domain-specific actors, verbs, data objects)
- A formal **ANTLR grammar** with modality and temporal constructs
- A comprehensive **data/traceability model** (ERM) linking goals to code
- **Code generation pipeline** producing ArchiMate models, OPA/Rego policies, and IaC/AaC

EBL is designed for **Business Analysts, Product Owners, Developers, Architects, and CXOs**, ensuring requirements aren't static documents but living, executable specifications governed by a shared dictionary and enforced at compile time for consistency and auditability.

### What Makes Archailign EBL Different

**Archailign EBL** is Praxibility's production-ready implementation that seamlessly generates:
- **Architecture Models** - ArchiMate models with full traceability
- **Policy Bundles** - OPA/Rego policy code from business rules
- **Infrastructure as Code (IaC)** - Terraform, CloudFormation, Pulumi artifacts
- **Architecture as Code (AaC)** - Executable architecture definitions

This positions EBL as the **single source of truth** from business intent to runtime execution.

### Key Value Proposition

| Stakeholder | Challenge Solved | EBL Solution |
| :--- | :--- | :--- |
| **Business Analysts** | Ambiguity and misinterpretation of requirements. | Unified, human-readable syntax that enforces technical precision. |
| **Developers** | Manual translation of requirements into code/config. | Requirements are machine-readable and directly compilable into executable artefacts. |
| **Technical CTOs** | Lack of traceability and compliance risk. | Clear link between business policy and technical implementation, facilitating audits. |

---

## Core Capabilities

Archailign EBL is built on the principles of **Flexibility**, **Precision**, and **Executability**. Its core capabilities enable rapid domain adaptation and high-fidelity translation of business logic into running systems.

### Language Features

* **Domain Adaptability**: Customizable grammar and industry-specific dictionaries for finance, healthcare, retail, logistics, insurance, KYC, payments, IT infrastructure, and more
* **Unified Syntax**: Defines business processes, data objects, governance policies, and IT assets in a single, coherent syntax
* **ANTLR-Powered**: Robust parsing and validation using ANTLR4 grammar definitions
* **Updatable Dictionaries**: JSON/YAML-based domain vocabularies maintained by subject matter experts
* **Multi-Language Support**: Generate parsers for Java, Python, and other ANTLR-supported languages

### Archailign Integration Features

* **Executable Requirements**: Transform business requirements into validated, compilable artifacts
* **Enterprise Integration**: Built-in support for data objects, processes, rules, relationships, and IT assets
* **Traceability**: End-to-end traceability from goals → objectives → processes → requirements → capabilities → data → policies → applications
* **Policy-Aware Design**: Link requirements and capabilities to Policies and DataObjects, enabling governance and compliance checks compiled alongside functional logic
* **Architecture Alignment**: Cross-walk to enterprise models (ArchiMate) with dictionary-driven consistency
* **Domain Portability**: Lexicon annexes for banking, pharma, retail, payments/KYC, insurance, MRP, public sector grants, aviation/MRO, adtech

---

## Technical Architecture: From Requirement to Execution

Archailign EBL's architecture is designed for robust validation, traceability, and compilation, ensuring consistency between business requirements and final implementation across the enterprise.

### Architecture Layers

The Archailign compilation pipeline consists of four distinct layers:

**1. Input Layer**
- Accepts requirements from multiple sources:
  - Direct `.ebl` files (primary format)
  - Jira integration (user stories, epics, tasks)
  - API inputs from enterprise tools
  - Business analyst workbenches
- Maintains source traceability and version control

**2. Parsing & Validation Layer**
- **ANTLR4 Grammar**: Parses EBL syntax into abstract syntax trees
- **Dictionary Validation**: Validates actors, verbs, and data objects against domain dictionaries
- **Semantic Checks**:
  - Actor/verb whitelist enforcement
  - Read/write permission validation
  - Relationship type validation
  - DataRef integrity (Entity → DataObject references)
  - Enum value validation
  - Reserved keyword warnings
  - Unused actor detection

**3. Model Binding & Traceability Layer**
- **ERM Integration**: Maps EBL constructs to Enterprise Relationship Model:
  - BusinessGoal → Objective → BusinessProcess → Requirement
  - Capability → DataObject → Policy → Application
  - Project (stores compiled AaC/IaC artifacts)
- **Traceability Links**: Maintains bidirectional links via `erMap` attributes
- **Impact Analysis**: Enables change impact assessment across layers

**4. Code Generation & Output Layer**
Transforms validated EBL into multiple executable artifacts:

| Output Type | Technology | Purpose |
|------------|------------|---------|
| **Architecture Models** | ArchiMate (XML/JSON) | Enterprise architecture visualization and governance |
| **Policy Code** | OPA/Rego | Runtime policy enforcement and compliance |
| **Infrastructure as Code** | Terraform, CloudFormation, Pulumi | Cloud infrastructure provisioning |
| **Architecture as Code** | Custom DSL | Executable architecture definitions |
| **API Specifications** | OpenAPI, GraphQL | Service contract generation |
| **Data Schemas** | JSON Schema, SQL DDL | Data structure definitions |

> **File Extension**: All EBL source files use the `.ebl` extension (lowercase).

### How Archailign EBL Works (At a Glance)

**1. Dictionary & Grammar**
- A versioned Enterprise Business Lexicon defines domain-specific actors, verbs, and data objects
- Reserved keywords and temporal constructs (SHALL, MUST NOT, WITHIN, BEFORE, ON/WHEN/THEN)
- ANTLR4 grammar constrains phrasing and enforces semantic correctness

**2. Parsing & Validation**
- ANTLR parses `.ebl` files into validated abstract syntax trees
- Semantic rules check actor permissions, data access, relationships, and business logic
- Dictionary compliance ensures consistent vocabulary across the organization

**3. Model Binding**
- EBL constructs bind to the Enterprise Relationship Model (ERM)
- Traceability preserved via `erMap` attributes: Goals → Objectives → Processes → Requirements → Capabilities → DataObjects → Policies → Applications
- Stored in relational database for querying and impact analysis

**4. Code Generation**
- Compilers emit ArchiMate models, OPA/Rego policy code, and AaC/IaC artifacts
- Generated code stored in Project records with full lineage
- Artifacts deployed to target platforms (Kubernetes, AWS, Azure, etc.)

### Tool Integration

Archailign EBL seamlessly integrates with existing enterprise tools:

**Project Management (Jira, Azure DevOps)**
- Read user stories, epics, and tasks
- Convert to structured `.ebl` files using templates
- Maintain bidirectional traceability between requirements and code

**Architecture Tools (Sparx EA, Archi)**
- Import/export ArchiMate models
- Synchronize EBL definitions with architecture repository
- Generate architecture views from EBL processes

**CI/CD Pipelines (GitHub Actions, GitLab CI)**
- Validate EBL changes on commit
- Regenerate artifacts automatically
- Deploy to target environments

---

## Getting Started

For comprehensive installation and usage instructions, see:
- **[GETTING_STARTED.md](../GETTING_STARTED.md)** - Complete tutorial with examples
- **[HOWTO.md](../EBL_v0.85/HOWTO.md)** - Quick reference commands

### Quick Install

```bash
# Clone the repository
git clone https://github.com/Archailign/praxibility-ebl.git
cd praxibility-ebl/EBL_v0.85

# Build with Maven
mvn clean install

# Or build with Gradle
gradle build

# Validate an example
python ebl_validator.py adTech_Dictionary_v0.85.json examples/KYC_Onboarding.ebl
```

---

## Use Cases

Archailign EBL's adaptability makes it ideal for a wide range of enterprise applications:

### Industry Applications

**Financial Services**
- KYC onboarding workflows with regulatory compliance
- Fraud detection rules and suspicious activity reporting (SAR)
- Payment screening and sanctions compliance
- Loan approval logic with risk assessment

**Healthcare & Pharmaceuticals**
- Patient intake processes with HIPAA compliance
- Clinical trial enrollment and protocol management
- Medical device approval workflows
- Patient data management with consent tracking

**Insurance**
- Claims lifecycle management (filing → assessment → approval → payment)
- Subrogation processes and recovery workflows
- Policy underwriting rules
- Fraud detection and investigation

**Retail & E-Commerce**
- Inventory replenishment with demand forecasting
- Order fulfillment and logistics
- Customer lifecycle management
- Returns and refunds processing

**AdTech & Marketing**
- Campaign management and budget optimization
- Ad serving workflows with bidding strategies
- Audience targeting rules and segmentation
- Performance analytics and reporting

**IT & Enterprise Architecture**
- Application onboarding and lifecycle management
- System topology mapping and dependency tracking
- Infrastructure provisioning with IaC
- Service catalog and capability mapping

### Cross-Industry Capabilities

- **Business Process Automation**: Define complex workflows that compile to executable code for automation engines
- **Policy Enforcement**: Encode governance policies directly in EBL for consistent, system-wide compliance
- **Regulatory Compliance**: Built-in support for GDPR, HIPAA, SOX, PCI-DSS, and industry-specific regulations
- **Cross-Functional Collaboration**: Shared, unambiguous language bridging business analysts, legal, compliance, and development teams
- **Requirements Traceability**: End-to-end links from business goals to running code
- **Impact Analysis**: Assess change impact across processes, data, policies, and applications

---

## Core EBL Language Constructs

Archailign EBL supports the following core constructs:

### Data & Entities

- **DataObject**: Schema, policies, and resource definitions for data structures
  - Includes: Schema (fields, types, constraints), Policies (retention, privacy), Resources (Input/Output channels)
- **Entity**: Business entities with properties, rules, and data references
  - Must reference a DataObject via `dataRef`
  - Properties define business view of data
  - Rules enforce business constraints

### Processes & Workflows

- **Process**: Business process workflows with steps, actors, and events
  - Starts With / Ends With events
  - Steps with inputs, validations, actions, conditions
  - Actors perform actions via DataObject Input/Output channels
- **Rule**: Business rules with triggers, conditions, and actions (ECA pattern)
  - Event-Condition-Action structure
  - Temporal logic support (WITHIN, BEFORE, AFTER)
  - Modality keywords (SHALL, MUST NOT, SHOULD)

### Architecture & Integration

- **ITAsset**: IT infrastructure (applications, systems, platforms)
- **Relationship**: Typed relationships between entities and IT assets
  - Types: depends_on, hosted_on, supports, communicates_with, etc.
- **Integration**: External system integrations with operations and error handling
- **Report**: Reporting definitions with queries and schedules

### Example Structure

```ebl
DataObject DO_Order {
  Schema:
    OrderId: UUID, required, unique
    Status: Enum, values=["New","Processing","Shipped","Delivered"]
  Policies:
    - "Retained 7 years per regulations"
  Resources:
    Input:  { Channel: API, Protocol: HTTPS, ... }
    Output: { Channel: Stream, Protocol: Kafka, ... }
  erMap: Order
}

Entity Order {
  dataRef: DO_Order
  Properties:
    OrderId: { type: UUID, required: true }
  erMap: OrderEntity
}

Process OrderFulfillment {
  Actors: [WarehouseManager, Picker, Packer]
  erMap: FulfillmentProcess
  Starts With: Event OrderReceived(Order)

  Step Pick {
    Actions:
      - Picker Pick items via DO_Order Output
  }

  Ends With: Event OrderShipped(Order)
}
```

---

## Contributing

We welcome contributions from the community! Archailign EBL is open-source, and your input helps improve the language and tooling.

See [CONTRIBUTING.md](../CONTRIBUTING.md) for:
- Code of Conduct
- How to submit issues and feature requests
- Pull request process
- Coding standards and testing requirements

**Quick Links:**
- [GitHub Repository](https://github.com/Archailign/praxibility-ebl)
- [Issues](https://github.com/Archailign/praxibility-ebl/issues)
- [Discussions](https://github.com/Archailign/praxibility-ebl/discussions)

---

## Documentation

- **[README.md](../README.md)** - Project overview and quick start
- **[GETTING_STARTED.md](../GETTING_STARTED.md)** - Comprehensive tutorial with examples
- **[ebl-classes.md](ebl-classes.md)** - Detailed EBL class reference
- **[ebl-Lexicon.md](ebl-Lexicon.md)** - Enterprise Business Lexicon specification
- **[data_model/](data_model/)** - ERM schemas for traceability
- **[HOWTO.md](../EBL_v0.85/HOWTO.md)** - Quick reference commands
- **[CHANGELOG.md](../EBL_v0.85/CHANGELOG.md)** - Version history

---

## License

Archailign EBL is released under the **Apache License 2.0**.

See the [LICENSE](../LICENSE) file for details.

## Copyright

Copyright © 2025 **Praxibility**. All rights reserved.

Enterprise Business Language (EBL) is an open-source framework developed by Praxibility to foster collaboration in enterprise business language standardization.

---

**Transform requirements into executable reality with Archailign EBL.**