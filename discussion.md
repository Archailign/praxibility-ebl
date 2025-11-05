# 🚀 Introducing Archailign Business Engineering EBL v0.85 – Initial Open Source Release!

**Posted by: Praxibility Team**
**Date: 05-11-2025**

Hey everyone! 👋

We're excited to announce the **initial open source release of Archailign Business Engineering EBL v0.85** – a production-ready framework for transforming business requirements into validated, traceable, executable artifacts.

**Archailign EBL** is a domain-specific, extensible controlled language that bridges strategy and implementation. By combining a curated **Enterprise Business Lexicon** with formal **ANTLR4 grammar** and a comprehensive **Enterprise Relationship Model (ERM)**, we enable business analysts' natural statements to be parsed, validated, and compiled into executable outputs.

Whether you're modeling KYC workflows in banking, clinical trial protocols in pharma, claims processing in insurance, or inventory management in retail, Archailign EBL provides a **single source of truth** from business intent to runtime execution: **requirements → architecture models → policy code → infrastructure as code**.

---

## 🎯 Core Capabilities of v0.85

### 1. **Comprehensive Validation Engine**
Go beyond syntax checking with **8 layers of semantic validation**:
- ✅ **Actor/Verb Whitelist Enforcement** - Ensures actors only use permitted verbs from domain dictionaries
- ✅ **Read/Write Permission Validation** - Validates Input (write) vs Output (read) permissions on DataObjects
- ✅ **Relationship Type Validation** - Checks relationship types (depends_on, hosted_on, supports, etc.)
- ✅ **DataRef Integrity** - Ensures all Entity references point to valid DataObjects
- ✅ **Enum Value Validation** - Default values must exist in declared value lists
- ✅ **Reserved Keyword Detection** - Warns if reserved words appear in free text
- ✅ **Unused Actor Detection** - Identifies actors defined but never used in processes
- ✅ **Requirement Duplication Detection** - Prevents duplicate requirements via unique EBLDefinition field

### 2. **Enterprise Relationship Model (ERM) with Full Traceability**
Two comprehensive SQL schemas supporting end-to-end traceability:
- **UUID-based schema** (`entity_relationship_model.txt`) - Cloud-native, distributed systems
- **INT-based schema** (`erm_schema.txt`) - Traditional enterprise databases with extended tracking

**Traceability Flow:**
```
BusinessGoal → Objective → BusinessProcess → Requirement → Capability
    → DataObject → Policy → Application → Project (AaC/IaC artifacts)
```

Every EBL construct maps to the ERM via `erMap` attributes, enabling:
- Impact analysis across the enterprise
- Compliance reporting and audits
- Change management and dependency tracking
- Architecture visualization with ArchiMate

### 3. **Multi-Domain Enterprise Business Lexicon**
**8+ domain-specific dictionaries** with actors, verbs, and controlled vocabulary:
- 🏦 **Banking** - Borrower, Underwriter, Lender | Assess, Approve, Disburse
- 💊 **Healthcare/Pharma** - Investigator, Subject, Monitor | Consent, Screen, Randomise
- 🏥 **Insurance** - Policyholder, Adjuster, Underwriter | Assess, Approve, Disburse
- 💳 **KYC/Payments** - Customer, Analyst, Officer | Capture, Verify, Screen, Approve
- 📦 **Retail/Logistics** - InventoryManager, Picker, Packer | Pick, Pack, Ship
- 🎯 **AdTech** - MediaBuyer, AdServer, DataAnalyst | Target, Deliver, Optimize
- 💻 **IT Infrastructure** - SysAdmin, Architect, Engineer | Deploy, Monitor, Configure
- 🏢 **Governance** - Auditor, ComplianceOfficer, RiskManager | Review, Approve, Audit

**Reserved Keywords & Temporal Constructs:**
- Modality: `SHALL`, `MUST`, `MUST NOT`, `SHOULD`, `MAY`, `CAN`
- Temporal: `WITHIN`, `BEFORE`, `AFTER`, `BY`, `UNTIL`, `EVERY`, `ON/WHEN/THEN`
- ECA Pattern: Event-Condition-Action for business rules

### 4. **ANTLR4-Powered Parser Generation**
Build parsers in **Java, Python, or Go** from a single grammar:
```bash
# Generate Java parser
java -jar antlr-4.13.1-complete.jar -Dlanguage=Java -o generated-src/java EBL.g4

# Generate Python parser
java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 -o generated-src/python EBL.g4
```

Includes complete test suites in Java (JUnit) and Python (pytest) with 17 real-world examples.

### 5. **Multi-Target Code Generation**
Transform validated EBL into executable artifacts:

| Output | Technology | Use Case |
|--------|-----------|----------|
| **Architecture Models** | ArchiMate XML/JSON | EA visualization, governance |
| **Policy Code** | OPA/Rego | Runtime policy enforcement |
| **Infrastructure** | Terraform, CloudFormation | Cloud provisioning |
| **Architecture as Code** | Custom DSL | Executable architecture |
| **API Specs** | OpenAPI, GraphQL | Service contracts |
| **Data Schemas** | JSON Schema, SQL DDL | Database structures |

### 6. **17 Production-Ready Examples Across 8 Domains**
Real-world EBL files demonstrating best practices:
- `AdCampaignManagement.ebl` - Dynamic campaign optimization with predictive budgeting
- `KYC_Onboarding.ebl` - Regulatory compliance workflow
- `Insurance_ClaimLifecycle.ebl` - End-to-end claims processing
- `MortgageLoanApplication.ebl` - Banking loan approval with LTV validation
- `ClinicalTrialEnrollment.ebl` - Pharma protocol compliance
- `IT-TopologyRelationships.ebl` - Application-to-SLA traceability
- ...and 11 more covering healthcare, payments, retail, logistics, governance

Full list: [EBL_v0.85/verticals/](https://github.com/Archailign/praxibility-ebl/tree/main/EBL_v0.85/verticals)

---

## 🚀 Quick Start (5 Minutes)

### 1. Clone and Build
```bash
git clone https://github.com/Archailign/praxibility-ebl.git
cd praxibility-ebl/EBL_v0.85

# Build with Maven
mvn clean install

# Or build with Gradle
gradle build
```

### 2. Validate Your First EBL File
```bash
# Install Python dependencies
pip install antlr4-python3-runtime pytest

# Validate a KYC onboarding example
python ebl_validator.py \
  verticals/kyc_compliance/dictionary/kyc_compliance_dictionary_v0.85.json \
  verticals/kyc_compliance/examples/KYC_Onboarding.ebl
```

**Expected output:**
```
✓ Parse successful: verticals/kyc_compliance/examples/KYC_Onboarding.ebl
✓ DataObjects: DO_KYCApplication, DO_IdentityDocument
✓ Entities: Application
✓ Processes: KYCOnboarding
✓ 4 actors validated: Customer, Registrar, KYCAnalyst, ComplianceOfficer
✓ 4 actions validated with permissions
✓ No reserved keyword violations
✓ All enum defaults are valid
0 errors, 0 warnings
```

### 3. Explore Examples
```bash
# View insurance claim lifecycle
cat verticals/insurance/examples/Insurance_ClaimLifecycle.ebl

# View mortgage loan application
cat verticals/banking/examples/MortgageLoanApplication.ebl

# Run all tests
mvn test
```

### 4. Generate Parsers for Your Language
```bash
# Download ANTLR
curl -LO https://www.antlr.org/download/antlr-4.13.1-complete.jar

# Generate Python parser
java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 \
  -visitor -listener -o generated-src/python src/main/antlr4/EBL.g4

# Generate Java parser
java -jar antlr-4.13.1-complete.jar -Dlanguage=Java \
  -visitor -listener -o generated-src/java src/main/antlr4/EBL.g4
```

**Full documentation:** [GETTING_STARTED.md](https://github.com/Archailign/praxibility-ebl/blob/main/GETTING_STARTED.md)

---

## 💡 Why Archailign EBL?

### The Problem We Solve
- 📄 **Requirements in Word/Confluence** → Ambiguous, non-executable, impossible to trace
- 🔀 **Manual translation** → Developers interpret requirements differently, leading to errors
- ❌ **No validation** → Duplicates, inconsistencies, and missing requirements discovered too late
- 🚫 **No traceability** → Can't trace a deployed service back to business goals
- 🤷 **Impact analysis is guesswork** → Changes break things unexpectedly

### The Archailign EBL Solution
✅ **Human-readable, machine-verifiable** - Business-friendly syntax with developer-grade determinism
✅ **Compliance by construction** - Requirements, data, and policies linked and enforceable at compile and runtime
✅ **Architecture-aligned** - Cross-walk to ArchiMate with dictionary-driven consistency
✅ **Single source of truth** - From business goals → objectives → processes → requirements → code
✅ **Multi-domain portability** - Same language works across banking, healthcare, retail, insurance, etc.
✅ **Open source & extensible** - Apache 2.0, community-driven lexicon and grammar

---

## 📊 Real-World EBL Example

Here's a complete KYC onboarding workflow in EBL:

```ebl
DataObject DO_KYCApplication {
  Schema:
    AppId: UUID, required, unique
    CustomerId: UUID, required
    Status: Enum, values=["Pending","InReview","Approved","Rejected"]

  Policies:
    - "KYC records retained 10 years"
    - "PII encrypted at rest"

  Resources:
    Input:  { Channel: API, Protocol: HTTPS,
              Endpoint: "https://kyc.example.com/app",
              Auth: OAuth2, Format: JSON, SLA: "P95<300ms" }
    Output: { Channel: API, Protocol: HTTPS,
              Endpoint: "https://kyc.example.com/app",
              Auth: OAuth2, Format: JSON, SLA: "P95<300ms" }

  erMap: KYCApp
}

Process KYCOnboarding {
  Description: "Capture documents, verify identity, and approve"
  ObjectiveID: KYC1
  BusinessGoalID: AFC1
  Actors: [Customer, Registrar, KYCAnalyst, ComplianceOfficer]
  erMap: KYCOnboarding

  Starts With: Event ApplicationSubmitted(Application)

  Step CaptureDocs {
    Actions:
      - Registrar Capture via DO_KYCApplication Input
  }

  Step VerifyAndApprove {
    Validation:
      - Documents MUST be verified BEFORE approval
    Actions:
      - KYCAnalyst Verify via DO_KYCApplication Output
      - KYCAnalyst Screen via DO_KYCApplication Output
      - ComplianceOfficer Approve via DO_KYCApplication Input
  }

  Ends With: Event ApplicationApproved(Application)
}

Rule DataPrivacyCompliance {
  Description: "Ensures GDPR compliance for KYC data"
  Trigger: Application.Status changes to Approved
  Conditions:
    - ConsentStatus == Granted
  Actions:
    - Encrypt Application.PII
    - Log ComplianceAudit
  erMap: GDPRCompliance
}
```

**What happens next?**
1. ✅ **Validator** checks: all actors exist, verbs are permitted, DataRef is valid
2. ✅ **ERM** stores: Goal → Objective → Process → Requirement mapping
3. ✅ **Generator** emits: ArchiMate model, OPA/Rego policy, API specs, IaC
4. ✅ **Deployed** to: Kubernetes with full traceability back to business goal

---

## 🎯 Key Technical Highlights

### Validation Beyond Syntax
```bash
# This will PASS ✓
- KYCAnalyst Verify via DO_KYCApplication Output  # Read permission

# This will FAIL ✗
- KYCAnalyst Delete via DO_KYCApplication Output  # Delete not in whitelist

# This will WARN ⚠
Process Example {
  Actors: [ActorA, ActorB, ActorC]  # ActorC never used in Steps
  ...
}
```

### Requirement Duplication Detection
```sql
-- ERM Schema enforces uniqueness
CREATE TABLE Requirement (
    RequirementID INT PRIMARY KEY,
    EBLDefinition TEXT NOT NULL UNIQUE,  -- Prevents duplicates!
    ...
)
```

### Full Traceability via erMap
```ebl
DataObject DO_Order { erMap: OrderDO }      -- Maps to DataObject table
Entity Order { erMap: OrderEntity }         -- Maps to EBLClass table
Process Fulfillment { erMap: FulfillProc }  -- Maps to BusinessProcess table
```

Query the database:
```sql
-- Find all processes using a specific DataObject
SELECT bp.Name, r.Description
FROM BusinessProcess bp
JOIN Requirement r ON r.ProcessID = bp.ProcessID
JOIN DataObject do ON do.Name = 'DO_Order'
WHERE bp.erMap = 'FulfillProc';
```

### Multi-Domain Dictionary Example
```yaml
# EBL_Dictionary_v0.85_all.yaml (excerpt)
domains:
  kyc:
    actors:
      - Customer
      - Registrar
      - KYCAnalyst
      - ComplianceOfficer
    verbs:
      - Capture: { permission: write }
      - Verify: { permission: read }
      - Screen: { permission: read }
      - Approve: { permission: write }
    actorVerbs:
      Registrar: [Capture]
      KYCAnalyst: [Verify, Screen]
      ComplianceOfficer: [Approve]
```

---

## 🗺️ Roadmap for Future Releases

### v0.86+ Planned Features
- 🔧 **VS Code Extension** - Syntax highlighting, autocomplete, and inline validation
- ☁️ **Cloud Validator Service** - Web-based validation without local setup
- 🎨 **Enhanced ArchiMate Export** - Round-trip editing and diagram generation
- 🧩 **Additional Domain Packs** - Manufacturing, Energy, Telecommunications, Public Sector
- 📊 **Enhanced Semantic Validation** - Reachability analysis, Segregation of Duties (SoD) conflict detection
- 🤖 **LLM Integration** - Grammar-constrained decoding for AI-assisted EBL generation
- 🌐 **OpenAPI/GraphQL Schema Generation** - Direct API spec generation from DataObjects
- 📈 **Advanced Analytics** - Complexity metrics, dependency graphs, technical debt tracking

### Community Wishlist
What would you like to see? Let us know in the comments!

---

## 🙌 Get Involved!

We're building the future of executable business requirements, and we need your help!

### 💬 Join the Conversation
- **Questions?** Reply to this discussion or ask in [GitHub Discussions](https://github.com/Archailign/praxibility-ebl/discussions)
- **What domains should we prioritize?** Manufacturing? Energy? Government? Tell us!
- **Share your use case** - How would you use EBL in your organization?

### 🐛 Report Issues
Found a bug or have a feature request? [Open an issue](https://github.com/Archailign/praxibility-ebl/issues)

### 🤝 Contribute
We welcome contributions of all types:
- 📖 **Documentation** - Improve guides, add examples, fix typos
- 🌍 **Domain Dictionaries** - Add vocabularies for new industries
- 🧪 **Test Cases** - Add validation tests and edge cases
- 🔧 **Tooling** - Build IDE extensions, web validators, or generators
- 📝 **Examples** - Contribute real-world EBL files from your domain

**How to contribute:**
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-contribution`
3. Make your changes and add tests
4. Submit a pull request

See [CONTRIBUTING.md](https://github.com/Archailign/praxibility-ebl/blob/main/CONTRIBUTING.md) for detailed guidelines.

### ⭐ Star & Share
If you find Archailign EBL useful, please:
- ⭐ **Star the repo** on GitHub
- 🔄 **Share with colleagues** working on enterprise architecture, requirements management, or compliance
- 📱 **Post on social media** using `#EBL #EnterpriseArchitecture #RequirementsEngineering`

---

## 📚 Documentation & Resources

### Core Documentation
- **[README.md](https://github.com/Archailign/praxibility-ebl/blob/main/README.md)** - Project overview and quick start
- **[GETTING_STARTED.md](https://github.com/Archailign/praxibility-ebl/blob/main/GETTING_STARTED.md)** - Comprehensive tutorial with ANTLR basics
- **[HOWTO.md](https://github.com/Archailign/praxibility-ebl/blob/main/EBL_v0.85/HOWTO.md)** - Quick reference commands
- **[CHANGELOG.md](https://github.com/Archailign/praxibility-ebl/blob/main/EBL_v0.85/CHANGELOG.md)** - Version history

### Technical Reference
- **[ebl-overview.md](https://github.com/Archailign/praxibility-ebl/blob/main/docs/ebl-overview.md)** - Archailign architecture deep-dive
- **[ebl-classes.md](https://github.com/Archailign/praxibility-ebl/blob/main/docs/ebl-classes.md)** - EBL class reference
- **[ebl-Lexicon.md](https://github.com/Archailign/praxibility-ebl/blob/main/docs/ebl-Lexicon.md)** - Enterprise Business Lexicon specification
- **[data_model/](https://github.com/Archailign/praxibility-ebl/tree/main/docs/data_model)** - ERM schemas for traceability

### Examples
- **[Examples Directory](https://github.com/Archailign/praxibility-ebl/tree/main/EBL_v0.85/examples)** - 17 production-ready EBL files across 8 domains

---

## 🎉 Thank You!

This release represents months of work standardizing enterprise business language for the open source community. We're excited to see what you build with Archailign EBL!

Special thanks to:
- The **Praxibility team** for the vision and execution
- **ANTLR community** for the robust parsing framework
- **Early adopters** who provided feedback and use cases
- **Open source contributors** who will shape the future of EBL

**Supported by Claude and Agentic Tools**

---

## 🏷️ Tags
`#ebl` `#enterprise-business-language` `#archailign` `#enterprise-architecture` `#requirements-engineering` `#antlr4` `#domain-specific-language` `#archimate` `#compliance` `#traceability` `#open-source`

---

**Let's transform business requirements from static documents to executable reality!** 🚀

**Repository:** https://github.com/Archailign/praxibility-ebl
**License:** Apache 2.0
**Version:** 0.85 (Initial Open Source Release)
