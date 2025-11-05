# Archailign EBL Architecture & Lexicon

**Structured Requirements. Executable Code. Seamless Traceability.**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![ANTLR](https://img.shields.io/badge/ANTLR-4.13.1-orange.svg)](https://www.antlr.org/)
[![Status](https://img.shields.io/badge/Status-Production--Ready-green.svg)](https://github.com/Archailign/praxibility-ebl)
[![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-brightgreen.svg)](../CONTRIBUTING.md)

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Enterprise Business Lexicon](#enterprise-business-lexicon)
4. [Core Language Constructs](#core-language-constructs)
5. [Domain Annexes](#domain-annexes)
6. [Getting Started](#getting-started)
7. [Use Cases](#use-cases)

---

## Overview

**Archailign EBL** is Praxibility's implementation of the Enterprise Business Language (EBL)—a domain-specific, extensible controlled language for expressing business requirements as validated, traceable, compilable artifacts.

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
| **Developers** | Manual translation of requirements into code/config. | Requirements are machine-readable and directly compilable into executable artifacts. |
| **Technical CTOs** | Lack of traceability and compliance risk. | Clear link between business policy and technical implementation, facilitating audits. |

---

## Architecture

### Core Capabilities

Archailign EBL is built on the principles of **Flexibility**, **Precision**, and **Executability**. Its core capabilities enable rapid domain adaptation and high-fidelity translation of business logic into running systems.

#### Language Features

* **Domain Adaptability**: Customizable grammar and industry-specific dictionaries for finance, healthcare, retail, logistics, insurance, KYC, payments, IT infrastructure, and more
* **Unified Syntax**: Defines business processes, data objects, governance policies, and IT assets in a single, coherent syntax
* **ANTLR-Powered**: Robust parsing and validation using ANTLR 4.13.1 grammar definitions
* **Vertical Independence**: Each industry vertical has its own grammar, dictionary, validators, and tests
* **Multi-Language Support**: Generate parsers for Java, Python, and other ANTLR-supported languages
* **Updatable Dictionaries**: JSON-based domain vocabularies maintained by subject matter experts

#### Archailign Integration Features

* **Executable Requirements**: Transform business requirements into validated, compilable artifacts
* **Enterprise Integration**: Built-in support for data objects, processes, rules, relationships, and IT assets
* **Traceability**: End-to-end traceability from goals → objectives → processes → requirements → capabilities → data → policies → applications
* **Policy-Aware Design**: Link requirements and capabilities to Policies and DataObjects, enabling governance and compliance checks compiled alongside functional logic
* **Architecture Alignment**: Cross-walk to enterprise models (ArchiMate) with dictionary-driven consistency
* **Domain Portability**: Lexicon annexes for banking, healthcare, retail, insurance, KYC/compliance, adtech, logistics, IT infrastructure

---

### Technical Architecture: From Requirement to Execution

Archailign EBL's architecture is designed for robust validation, traceability, and compilation, ensuring consistency between business requirements and final implementation across the enterprise.

#### Architecture Layers

The Archailign compilation pipeline consists of four distinct layers:

**1. Input Layer**
- Accepts requirements from multiple sources:
  - Direct `.ebl` files (primary format)
  - Jira integration (user stories, epics, tasks)
  - API inputs from enterprise tools
  - Business analyst workbenches
- Maintains source traceability and version control

**2. Parsing & Validation Layer**
- **ANTLR 4.13.1 Grammar**: Parses EBL syntax into abstract syntax trees using vertical-specific grammars
- **Vertical-Specific Parsers**: Each industry vertical generates its own ANTLR parsers from domain-specific grammars
- **Dictionary Validation**: Validates actors, verbs, and data objects against vertical dictionaries
- **Semantic Checks**:
  - Actor/verb whitelist enforcement
  - Read/write permission validation
  - Relationship type validation
  - DataRef integrity (Entity → DataObject references)
  - Enum value validation
  - Reserved keyword warnings
  - Unused actor detection
  - Domain-specific compliance rules (PCI-DSS, HIPAA, SOX, etc.)

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

---

### ANTLR-Based Vertical Independence

**Version 0.85** introduces a completely vertical-independent architecture:

#### Vertical Structure
Each vertical is completely self-contained:

```
verticals/[vertical]/
├── grammar/
│   └── [Vertical]_v0_85.g4          # ANTLR grammar with domain keywords
├── generated/
│   ├── python/                       # Generated Python parsers
│   └── java/                         # Generated Java parsers
├── validators/
│   ├── python/
│   │   ├── dictionary_validator.py  # ANTLR-based dictionary validation
│   │   └── semantic_validator.py    # Domain-specific compliance rules
│   └── java/                         # Java validators
├── tests/
│   ├── python/                       # Python test suites
│   └── java/                         # Java test suites
├── dictionary/
│   └── [vertical]_dictionary_v0.85.json  # Independent vocabulary
├── examples/                         # .ebl example files
└── data_model/                       # ERM schemas
```

#### Key Principles

1. **No Central Dependencies**: Each vertical operates independently without shared centralized files
2. **ANTLR-Only Validation**: All validation uses ANTLR-generated parsers (no regex/string parsing)
3. **Domain-Specific Keywords**: Each grammar includes vertical-specific keywords (e.g., SWIFT, IBAN for Banking)
4. **Independent Dictionaries**: Each vertical maintains its own complete dictionary
5. **Automated Parser Generation**: Utility script generates all parsers: `./utilities/generate_vertical_parsers.sh`

---

### How Archailign EBL Works

**1. Dictionary & Grammar**
- Each vertical has a versioned dictionary defining domain-specific actors, verbs, and data objects
- Reserved keywords and temporal constructs (SHALL, MUST NOT, WITHIN, BEFORE, ON/WHEN/THEN)
- ANTLR 4.13.1 grammar constrains phrasing and enforces semantic correctness

**2. Parsing & Validation**
- ANTLR parses `.ebl` files into validated abstract syntax trees using vertical-specific parsers
- Semantic rules check actor permissions, data access, relationships, and business logic
- Dictionary compliance ensures consistent vocabulary across the organization
- Domain-specific compliance validators (PCI-DSS for Banking, HIPAA for Healthcare, etc.)

**3. Model Binding**
- EBL constructs bind to the Enterprise Relationship Model (ERM)
- Traceability preserved via `erMap` attributes: Goals → Objectives → Processes → Requirements → Capabilities → DataObjects → Policies → Applications
- Stored in relational database for querying and impact analysis

**4. Code Generation**
- Compilers emit ArchiMate models, OPA/Rego policy code, and AaC/IaC artifacts
- Generated code stored in Project records with full lineage
- Artifacts deployed to target platforms (Kubernetes, AWS, Azure, etc.)

---

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

## Enterprise Business Lexicon

*A standardized dictionary of business-requirements terms designed to support ANTLR grammars for the Enterprise Business Language (EBL).*

### Purpose & Scope

The EBL dictionary standardizes business terminology—actors, events, processes, data, rules, metrics—so natural business sentences can be parsed, compiled or interpreted into data and architectural models. It is domain-agnostic with vertical-specific extensions for different industries. The dictionary aligns to common architecture meta-models (e.g., ArchiMate) and serves as the authoritative lexicon for EBL grammar construction.

**Intended uses:**
- Constrain vocabulary for controlled natural language
- Map business statements to tokens/nonterminals in ANTLR grammars
- Generate enterprise models (capabilities, processes, data, services, policies)
- Drive code/artifact generation (schemas, APIs, workflows, IaC)

**Vertical Dictionary Structure:**
Each vertical maintains its own dictionary in JSON format:

```json
{
  "version": "0.85",
  "domain": "banking",
  "actors": ["PaymentProcessor", "FraudAnalyst", "ComplianceOfficer"],
  "verbs": ["Verify", "Approve", "Screen", "Disburse"],
  "actorVerbs": {
    "PaymentProcessor": ["Verify", "Disburse"],
    "FraudAnalyst": ["Screen", "Investigate"],
    "ComplianceOfficer": ["Approve", "Reject"]
  },
  "dataObjects": ["DO_Payment", "DO_Account", "DO_Transaction"],
  "relationshipTypes": ["debits_from", "credits_to", "depends_on"],
  "entities": ["Payment", "Account", "Customer"]
}
```

---

### Foundational Modeling Concepts

- **Universe of Discourse** *(Scope)* — the bounded domain the model covers
- **Canonical Term** — the single, preferred label used in EBL; aliases map to it
- **Identity vs. State** — attributes that uniquely identify an entity vs. mutable properties that can change over time
- **Event-Condition-Action (ECA)** — rule form: *ON <Event> WHEN <Condition> THEN <Action>*
- **Modality** — requirement force: *SHALL, MUST NOT, SHOULD, MAY, CAN*
- **Determinism** — avoid ambiguity; quantify thresholds, units, and time windows

---

### Controlled Language Building Blocks

#### Modality Keywords
Define requirement strength and obligation:
- **SHALL** - Mandatory requirement
- **MUST NOT** - Prohibited action
- **SHOULD** - Recommended but not required
- **MAY** - Optional capability
- **CAN** - Permitted action

#### Temporal Expressions
Define time-based constraints:
- **BY** - Completion deadline
- **BEFORE** - Precedence constraint
- **AFTER** - Succession constraint
- **WITHIN** - Duration limit
- **UNTIL** - Termination condition
- **EVERY** - Recurrence pattern
- **ON** - Event trigger

#### Quantifiers & Comparators
- **ALL** - Universal quantification
- **EXISTS** - Existential quantification
- **FORALL** - Universal condition
- **AND, OR, NOT** - Logical operators
- **IN, BETWEEN** - Set membership and ranges
- **≥, ≤, =, ≠, >, <** - Numeric comparisons

#### Literals & Types
- **DATE** - YYYY-MM-DD format
- **TIME** - HH:MM:SS format
- **DURATION** - Time spans (e.g., 24h, 30 days)
- **CURRENCY** - Monetary values with units
- **PERCENT** - Ratio values
- **UUID** - Unique identifiers
- **Enum** - Enumerated types with values

---

### Reserved Keywords

Core reserved keywords across all verticals:

```
ACTOR, ROLE, SYSTEM, PROCESS, ACTIVITY, ACTION, EVENT, STATE,
ENTITY, ATTRIBUTE, IDENTIFIER, RELATES_TO, DEFINE, MEASURE,
RULE, POLICY, CONSTRAINT, REQUIREMENT, RISK, CONTROL, KPI,
SLA, METRIC, UNIT, LOCATION, CHANNEL, INTERFACE, ON, WHEN,
THEN, ELSE, WITHIN, BEFORE, AFTER, BY, UNTIL, SINCE, EVERY,
SHALL, MUST, MUST NOT, SHOULD, MAY, CAN, TRUE, FALSE, AND,
OR, NOT, IN, BETWEEN, EXISTS, FORALL, THEREEXISTS, DataObject
```

---

### Notation & Style Guide

- **Singular nouns** for canonical terms; plural only for sets (*e.g.,* *ALL Payments*)
- **Capitalize** defined terms and keywords; use quotes for multi-word identifiers
- **Avoid vague words**: *quickly, soon, appropriate*; replace with quantified metrics
- **Always include** units and time windows
- **Provide source/authority** for Compliance Requirements
- **File naming**: Use `.ebl` extension (lowercase) for all source files

---

### ArchiMate Crosswalk

Mapping EBL constructs to ArchiMate for model generation:

| EBL Construct | ArchiMate Element |
|--------------|-------------------|
| Actor/Role | Business Actor, Business Role |
| Process/Activity/Workflow | Business Process, Business Function |
| Event | Business Event |
| Entity/Data | Business Object / Data Object |
| System/Interface | Application Component / Application Service / Interface |
| Rule/Policy/Constraint | Business Rule (Motivation), Constraint |
| SLA/KPI/Metric | Assessment / Goal |
| Risk/Control | Risk / Control (extension or Motivation mapping) |

---

## Core Language Constructs

Archailign EBL supports the following core constructs. For detailed class reference, see [ebl-classes.md](ebl-classes.md).

### Data & Entities

**DataObject**: Schema, policies, and resource definitions for data structures
- **Schema**: Fields, types, constraints (required, unique, min/max)
- **Policies**: Retention rules, privacy requirements, compliance mandates
- **Resources**: Input/Output channels with protocols, endpoints, authentication, SLAs
- **erMap**: Traceability link to ERM

**Entity**: Business entities with properties, rules, and data references
- **dataRef**: Must reference a DataObject
- **Properties**: Business view of data with types and constraints
- **Rules**: Business logic and validation constraints
- **erMap**: Traceability link to ERM

### Processes & Workflows

**Process**: Business process workflows with steps, actors, and events
- **Description**: Human-readable process description
- **Actors**: Roles that participate in the process
- **Starts With / Ends With**: Event boundaries
- **Steps**: Sequential or conditional steps with:
  - **Inputs**: Data inputs for the step
  - **Validations**: Business rules that must be satisfied
  - **Actions**: Actor-verb-DataObject triples (e.g., `Analyst Screen via DO_Transaction Output`)
  - **Conditions**: Branching logic
- **erMap**: Traceability to ERM Process

**Rule**: Business rules with triggers, conditions, and actions (ECA pattern)
- **ON** clause: Event trigger
- **WHEN** clause: Condition evaluation
- **THEN** clause: Action to execute
- Temporal logic support (WITHIN, BEFORE, AFTER)
- Modality keywords (SHALL, MUST NOT, SHOULD)

### Architecture & Integration

**ITAsset**: IT infrastructure (applications, systems, platforms)
- Application metadata and attributes
- Platform characteristics
- System configurations

**Relationship**: Typed relationships between entities and IT assets
- Types: `depends_on`, `hosted_on`, `supports`, `communicates_with`, `accesses`, etc.
- From/To endpoints
- Relationship metadata

**Integration**: External system integrations
- Operations and endpoints
- Error handling and retry logic
- Authentication and authorization

**Report**: Reporting definitions
- Queries and data sources
- Schedules and triggers
- Output formats and destinations

---

### Example Structure

```ebl
Metadata:
  Domain: banking
  Owner: Payments
  Version: 0.85

DataObject DO_Payment {
  Schema:
    PaymentId: UUID, required, unique
    Amount: Currency, required, min=0
    Status: Enum, values=["Pending","Approved","Rejected","Settled"]
    AccountNumber: String, encrypted

  Policies:
    - "PCI-DSS: Card data must be encrypted"
    - "SOX: Dual authorization required for amounts > $10,000"
    - "Retained 7 years per regulations"

  Resources:
    Input:  { Channel: API, Protocol: HTTPS, Endpoint: "https://pay.example.com/v1/payment",
              Auth: OAuth2, Format: JSON, SLA: "P95<300ms" }
    Output: { Channel: Stream, Protocol: Kafka, Endpoint: "kafka://payments/processed",
              Auth: mTLS, Format: JSON, SLA: "P99<100ms" }

  erMap: PaymentDO
}

Entity Payment {
  dataRef: DO_Payment
  Properties:
    PaymentId: { type: UUID, required: true, unique: true }
    Amount: { type: Currency, required: true, min: 0 }
    Status: { type: Enum, values: ["Pending","Approved","Rejected","Settled"], default: "Pending" }
  Rules:
    - "Amount > 10000 requires dual authorization"
  erMap: PaymentEntity
}

Process PaymentProcessing {
  Description: "Screen, approve, and settle payments"
  ObjectiveID: PAY1
  BusinessGoalID: COMPLIANCE1
  Actors: [PaymentProcessor, FraudAnalyst, ComplianceOfficer, SettlementSpecialist]
  erMap: PaymentProcess

  Starts With: Event PaymentReceived(Payment)

  Step ScreenAndVerify {
    Validation:
      - Payment amount MUST be validated
      - Counterparty MUST be screened against sanctions
    Actions:
      - FraudAnalyst Screen via DO_Payment Output
      - PaymentProcessor Verify via DO_Payment Output
  }

  Step Approve {
    Validation:
      - Screening MUST be complete BEFORE approval
    Actions:
      - ComplianceOfficer Approve via DO_Payment Input
  }

  Step Settle {
    Actions:
      - SettlementSpecialist Settle via DO_Payment Input
  }

  Ends With: Event PaymentSettled(Payment)
}

ITAsset PaymentGateway {
  Type: Application
  Platform: AWS
  Attributes:
    - Version: 2.1.0
    - Region: us-east-1
}

Relationship PaymentGateway_Dependency {
  From: PaymentProcessingService
  To: PaymentGateway
  Type: depends_on
}
```

---

## Domain Annexes

EBL v0.85 includes comprehensive domain annexes for 8 industry verticals. Each vertical has its own complete dictionary, grammar, validators, tests, and examples.

### Available Verticals

#### 1. Banking - Financial Services
**Location**: `verticals/banking/`
**Status**: ✅ Production-Ready

**Core Entities**: Account, Payment, Transaction, Customer, Beneficiary, MortgageApplication, CreditReport

**Actors**: PaymentProcessor, FraudAnalyst, ComplianceOfficer, LoanOfficer, Underwriter, TreasuryOfficer

**Domain Keywords**: SWIFT, IBAN, ABA, BIC, PCI_DSS, SOX, WIRE, ACH

**Compliance Rules**:
- **PCI-DSS**: Card encryption, CVV non-storage, sensitive authentication data protection
- **SOX**: Dual authorization for wire transfers, audit trail requirements
- **AML/KYC**: Sanctions screening, enhanced due diligence, SAR filing
- **Data Security**: SSN encryption, account number protection, PII safeguards

**Example Use Cases**:
- Mortgage loan application processing
- Payment screening and fraud detection
- Wire transfer authorization
- Suspicious activity reporting (SAR)

---

#### 2. Healthcare - Pharmaceuticals & Clinical Trials
**Location**: `verticals/healthcare/`
**Status**: 📝 Template Ready

**Core Entities**: Patient, Subject, InformedConsent, Screening, Visit, Dose, AdverseEvent, Protocol, Site, Investigator

**Actors**: Patient, Physician, Nurse, PrincipalInvestigator, ClinicalResearchAssociate, Sponsor, IRB

**Domain Keywords**: HIPAA, PHI, FDA, HL7, FHIR, ICF, SAE, AE

**Compliance Rules**:
- **HIPAA**: PHI encryption, access controls, breach notification
- **FDA**: Clinical trial protocols, adverse event reporting, GCP compliance
- **ICH-GCP**: Informed consent, protocol deviations, safety reporting

**Example Use Cases**:
- Patient intake and consent
- Clinical trial enrollment
- Adverse event reporting
- Protocol compliance monitoring

---

#### 3. Insurance - Claims & Underwriting
**Location**: `verticals/insurance/`
**Status**: 📝 Template Ready

**Core Entities**: Claim, Policy, Policyholder, Beneficiary, ClaimAssessment, Payment, UnderwritingDecision

**Actors**: Policyholder, ClaimsAdjuster, Underwriter, FraudInvestigator, ActuarialAnalyst

**Domain Keywords**: NAIC, SLA, Subrogation, Coverage, Deductible, Premium

**Compliance Rules**:
- **NAIC**: State insurance regulations, rate filing requirements
- **Claims Processing**: SLA compliance, fraud detection thresholds
- **Reserve Requirements**: Actuarial standards, capital adequacy

**Example Use Cases**:
- Claims lifecycle management
- Subrogation and recovery workflows
- Policy underwriting decisions
- Fraud investigation

---

#### 4. Retail - E-Commerce & Inventory
**Location**: `verticals/retail/`
**Status**: 📝 Template Ready

**Core Entities**: SKU, Product, Order, Customer, Inventory, Warehouse, Forecast

**Actors**: InventoryPlanner, Buyer, Supplier, WarehouseOperative, StoreManager

**Domain Keywords**: ROP, SafetyStock, LeadTime, FillRate, Backorder

**Rules**:
- Reorder point triggers
- Service level targets
- Inventory optimization
- Omnichannel fulfillment

**Example Use Cases**:
- Inventory replenishment
- Order fulfillment
- Demand forecasting
- Returns processing

---

#### 5. KYC/Compliance - Identity Verification
**Location**: `verticals/kyc_compliance/`
**Status**: 📝 Template Ready

**Core Entities**: Application, Customer, IdentityDocument, RiskProfile, ScreeningResult, ComplianceReport

**Actors**: Customer, Registrar, KYCAnalyst, ComplianceOfficer, RiskManager

**Domain Keywords**: AML, KYC, PEP, Sanctions, CDD, EDD, SAR

**Compliance Rules**:
- **AML**: Transaction monitoring, sanctions screening, SAR filing
- **KYC**: Identity verification, risk profiling, ongoing monitoring
- **Segregation of Duties**: Multi-actor approval workflows

**Example Use Cases**:
- Customer onboarding
- Ongoing KYC monitoring
- Sanctions screening
- Suspicious activity detection

---

#### 6. AdTech - Advertising Technology
**Location**: `verticals/adtech/`
**Status**: 📝 Template Ready

**Core Entities**: Campaign, Ad, Impression, Click, Conversion, Audience, Bid

**Actors**: Advertiser, Publisher, AdServer, DSP, SSP, AdExchange

**Domain Keywords**: RTB, CPM, CPC, CTR, Viewability, GDPR

**Compliance Rules**:
- **GDPR**: Consent management, data privacy, right to deletion
- **Viewability Standards**: MRC compliance, fraud prevention
- **Brand Safety**: Content categorization, blacklist enforcement

**Example Use Cases**:
- Campaign management
- Real-time bidding
- Audience targeting
- Performance analytics

---

#### 7. Logistics - Supply Chain Management
**Location**: `verticals/logistics/`
**Status**: 📝 Template Ready

**Core Entities**: Shipment, Package, Warehouse, Route, Carrier, TrackingEvent

**Actors**: WarehouseManager, Dispatcher, Carrier, CustomsOfficer, Receiver

**Domain Keywords**: Incoterms, BOL, AWB, Customs, Hazmat

**Rules**:
- Route optimization
- Delivery SLAs
- Customs compliance
- Hazardous materials handling

**Example Use Cases**:
- Shipment tracking
- Warehouse management
- Cross-border logistics
- Last-mile delivery

---

#### 8. IT Infrastructure - Operations
**Location**: `verticals/it_infrastructure/`
**Status**: 📝 Template Ready

**Core Entities**: Application, System, Platform, Service, Incident, ChangeRequest

**Actors**: SystemAdministrator, DevOpsEngineer, SecurityOfficer, ChangeManager

**Domain Keywords**: SLO, MTBF, MTTR, ITSM, CMDB, CI/CD

**Rules**:
- SLO compliance monitoring
- Change management approval
- Incident response procedures
- Security control validation

**Example Use Cases**:
- Application onboarding
- System topology mapping
- Incident management
- Change control

---

### Domain Lexicon Examples

#### Banking — Payments & KYC

```ebl
Process InternationalPayment {
  Actors: [PaymentProcessor, ComplianceOfficer, TreasuryOfficer]

  Step ScreenCounterparty {
    Actions:
      - ComplianceOfficer Screen via DO_Payment Output
    Validation:
      - "Counterparty MUST NOT be on sanctions list"
  }

  Step ApproveTransfer {
    Actions:
      - TreasuryOfficer Approve via DO_Payment Input
      - ComplianceOfficer Approve via DO_Payment Input
    Validation:
      - "Wire transfers > $10,000 require dual authorization per SOX"
  }
}

Rule AML_Screening {
  ON PaymentInitiated
  WHEN Amount > 10000 AND Country IN ["High-Risk-List"]
  THEN Screen via SanctionsDatabase AND Escalate to ComplianceOfficer
}
```

#### Healthcare — Clinical Trials

```ebl
Process ClinicalTrialEnrollment {
  Actors: [Subject, PrincipalInvestigator, ClinicalResearchAssociate]

  Step ObtainConsent {
    Actions:
      - PrincipalInvestigator Obtain via DO_InformedConsent Input
    Validation:
      - "Informed consent MUST be obtained BEFORE any study procedures"
      - "Consent form version MUST match current IRB-approved version"
  }

  Step ScreenEligibility {
    Actions:
      - ClinicalResearchAssociate Screen via DO_Subject Output
    Validation:
      - "ALL inclusion criteria MUST be met"
      - "NO exclusion criteria MUST be present"
  }
}

Rule SAE_Reporting {
  ON SeriousAdverseEvent
  WHEN Severity IN ["Life-Threatening", "Death", "Hospitalization"]
  THEN Report WITHIN 24h TO Sponsor AND IRB
}
```

#### Retail — Inventory Replenishment

```ebl
Process InventoryReplenishment {
  Actors: [InventoryPlanner, Buyer, Supplier]

  Step CalculateReorderPoint {
    Actions:
      - InventoryPlanner Calculate via DO_Forecast Output
    Validation:
      - "ROP = (AverageDailyDemand × LeadTime) + SafetyStock"
  }

  Step PlaceOrder {
    Actions:
      - Buyer Order via DO_PurchaseOrder Input
    Validation:
      - "Order WHEN OnHand + OnOrder - Allocated ≤ ROP"
  }
}

Rule ServiceLevel_Target {
  ON WeekEnd
  WHEN FillRate < 95%
  THEN Alert InventoryPlanner AND Increase SafetyStock BY 10%
}
```

---

## Getting Started

For comprehensive installation and usage instructions, see:
- **[GETTING_STARTED.md](../GETTING_STARTED.md)** - Complete tutorial with examples
- **[HOWTO.md](../EBL_v0.85/HOWTO.md)** - Quick reference commands
- **[ebl-classes.md](ebl-classes.md)** - Detailed EBL class reference

### Quick Install

```bash
# Clone the repository
git clone https://github.com/Archailign/praxibility-ebl.git
cd praxibility-ebl/EBL_v0.85

# Install Python dependencies
pip install antlr4-python3-runtime pytest

# Generate ANTLR parsers for all verticals
./utilities/generate_vertical_parsers.sh

# Validate a Banking example using ANTLR-based validator
cd verticals/banking
python3 validators/python/dictionary_validator.py \
  examples/MortgageLoanApplication.ebl \
  dictionary/banking_dictionary_v0.85.json
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
- Wire transfer dual authorization (SOX compliance)

**Healthcare & Pharmaceuticals**
- Patient intake processes with HIPAA compliance
- Clinical trial enrollment and protocol management
- Medical device approval workflows
- Adverse event reporting (FDA compliance)
- Patient data management with consent tracking

**Insurance**
- Claims lifecycle management (filing → assessment → approval → payment)
- Subrogation processes and recovery workflows
- Policy underwriting rules
- Fraud detection and investigation
- NAIC compliance and state regulations

**Retail & E-Commerce**
- Inventory replenishment with demand forecasting
- Order fulfillment and logistics
- Customer lifecycle management
- Returns and refunds processing
- Omnichannel inventory optimization

**AdTech & Marketing**
- Campaign management and budget optimization
- Ad serving workflows with bidding strategies
- Audience targeting rules and segmentation
- Performance analytics and reporting
- GDPR consent management

**IT & Enterprise Architecture**
- Application onboarding and lifecycle management
- System topology mapping and dependency tracking
- Infrastructure provisioning with IaC
- Service catalog and capability mapping
- SLO monitoring and incident response

### Cross-Industry Capabilities

- **Business Process Automation**: Define complex workflows that compile to executable code for automation engines
- **Policy Enforcement**: Encode governance policies directly in EBL for consistent, system-wide compliance
- **Regulatory Compliance**: Built-in support for GDPR, HIPAA, SOX, PCI-DSS, and industry-specific regulations
- **Cross-Functional Collaboration**: Shared, unambiguous language bridging business analysts, legal, compliance, and development teams
- **Requirements Traceability**: End-to-end links from business goals to running code
- **Impact Analysis**: Assess change impact across processes, data, policies, and applications

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
- **[data_model/](data_model/)** - ERM schemas for traceability
- **[HOWTO.md](../EBL_v0.85/HOWTO.md)** - Quick reference commands
- **[TESTING.md](../EBL_v0.85/TESTING.md)** - Testing strategy and test suites
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

*Version 0.85 | ANTLR-Based Vertical Independence | 2025-11-05*
