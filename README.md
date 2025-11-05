# Enterprise Business Language (EBL)

**Transform Business Requirements into Executable Reality**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![ANTLR](https://img.shields.io/badge/ANTLR-4.13.1-orange.svg)](https://www.antlr.org/)
[![Version](https://img.shields.io/badge/Version-0.85-green.svg)](https://github.com/Archailign/praxibility-ebl)
[![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## What is EBL?

**Archailign Business Engineering EBL** is a domain-specific language that bridges the gap between business requirements and technical implementation. It combines:

- 📝 **Controlled Natural Language** - Business-friendly syntax with developer-grade precision
- 🎯 **ANTLR-Based Parsing** - Formal grammar-based validation (no regex, no ambiguity)
- 🔗 **End-to-End Traceability** - From business goals → processes → data → policies → code
- ✅ **Compliance by Construction** - Industry-specific validation (PCI-DSS, HIPAA, SOX, FDA)
- 🏗️ **Multi-Target Generation** - Compile to ArchiMate, OPA/Rego, OpenAPI, Terraform, and more

### The Problem

Traditional requirements management:
- 📄 **Static Documents** → Word/Confluence files that quickly become outdated
- 🤷 **Ambiguous Language** → "Should", "might", "hopefully" lead to misinterpretation
- ❌ **No Validation** → Duplicates, conflicts, and missing requirements discovered late
- 🚫 **No Traceability** → Can't link deployed services back to business goals
- 🔀 **Manual Translation** → Developers interpret requirements differently

### The EBL Solution

```
Business Requirements (EBL)
 ↓ (Parse & Validate)
 ANTLR Parser
 ↓ (Semantic Validation)
 Compliance Checks
 ↓ (Generate)
┌────────┬────────┬─────────┬──────────┐
│ArchiMate│ OPA/Rego│ OpenAPI │ Terraform│
│ Models  │ Policies│  Specs  │   IaC    │
└────────┴────────┴─────────┴──────────┘
 ↓
 Deployed Systems with Full Traceability
```

---

## ✨ NEW in v0.85: ANTLR-Based Vertical Independence

Version 0.85 represents a **major architectural shift**:

### 🎯 Key Changes

✅ **Complete Vertical Independence**
- Each Domain (Banking, Healthcare, Insurance, etc.) is self-contained
- Own ANTLR grammar with domain-specific keywords (SWIFT, IBAN, HIPAA, GCP, etc.)
- Own validators (dictionary + semantic + compliance)
- Own test suites (Python + Java)
- Own examples and data models

✅ **Banking Vertical Production-Ready**
- Full test coverage (13 tests, 100% passing)
- PCI-DSS, SOX, AML compliance validators
- Real-world examples: Mortgage lending, fraud detection, payments screening
- Serves as a template for other verticals

✅ **Automated Tooling**
- `./utilities/generate_vertical_parsers.sh` - Generate parsers for all verticals
- No more centralised dependencies or master dictionaries
- Clean separation between domains

**Migration from centralised architecture completed** ✅

---

## 🚀 Quick Start (5 Minutes)

### Prerequisites

- Java 11+ (for ANTLR parser generation)
- Python 3.8+ with `antlr4-python3-runtime`
- Git

### Installation & First Validation

```bash
# 1. Clone the repository
git clone https://github.com/Archailign/praxibility-ebl.git
cd praxibility-ebl/EBL_v0.85

# 2. Install Python dependencies
pip install antlr4-python3-runtime pytest

# 3. Generate ANTLR parsers (optional - Banking already has generated parsers)
./utilities/generate_vertical_parsers.sh

# 4. Validate your first EBL file (Banking vertical)
cd verticals/banking
python3 validators/python/dictionary_validator.py \
 examples/MortgageLoanApplication.ebl \
  dictionary/banking_dictionary_v0.85.json

# ✅ Expected output: VALIDATION PASSED

# 5. Run Banking test suite
cd tests/python
python3 test_banking_validator.py

# 6. Explore other examples
ls ../examples/
# MortgageLoanApplication.ebl
# AFC_Fraud_SAR.ebl
# Payments_Screening.ebl
```

**New to EBL?** → See [**GETTING_STARTED.md**](GETTING_STARTED.md) for comprehensive tutorial!

---

## 🎯 Key Features

### For Business Analysts
- ✅ **Human-Readable Syntax** - Natural language with controlled vocabulary
- ✅ **Domain-Specific Dictionaries** - Industry-specific actors, verbs, and entities
- ✅ **Modality & Temporal Logic** - SHALL, MUST, WITHIN, BEFORE, AFTER
- ✅ **No Code Required** - Focus on business logic, not implementation

### For Developers
- ✅ **ANTLR-Parsed** - Formal grammar, not regex or string matching
- ✅ **Multi-Language Parsers** - Generate Python, Java, or other ANTLR targets
- ✅ **Semantic Validation** - Actor/verb permissions, data type checking, relationship validation
- ✅ **Code Generation** - Compile to ArchiMate, OPA/Rego, OpenAPI, IaC

### For Architects
- ✅ **End-to-End Traceability** - Business goals → processes → data → applications → projects
- ✅ **ArchiMate Integration** - Generate architecture models automatically
- ✅ **ERM Schema** - Comprehensive entity-relationship model for traceability
- ✅ **Impact Analysis** - Understand dependencies across the enterprise

### For Compliance Officers
- ✅ **Domain-Specific Compliance** - PCI-DSS, HIPAA, SOX, FDA, GDPR, AML/KYC
- ✅ **Policy Enforcement** - Link requirements to policies at compile time
- ✅ **Audit Trails** - Full lineage from requirement to deployment
- ✅ **Regulatory Reporting** - Generate compliance reports automatically

---

## 📦 Supported Domains (Verticals)

| Vertical | Status | Key Features | Examples |
|----------|--------|--------------|----------|
| **🏦 Banking** | ✅ Production-Ready | PCI-DSS, SOX, AML/KYC | Mortgage lending, fraud detection, payments |
| **💊 Healthcare** | Template-Ready | HIPAA, FDA, GCP | Clinical trials, adverse events, protocols |
| **🏥 Insurance** | Template-Ready | NAIC, claims validation | Claims processing, underwriting |
| **💳 KYC/Compliance** | Template-Ready | Identity verification | Customer onboarding, screening |
| **📦 Retail** | Template-Ready | Inventory, orders | E-commerce workflows, fulfilment |
| **🎯 AdTech** | Template-Ready | Campaigns, audiences | Campaign optimisation, bidding |
| **🚚 Logistics** | Template-Ready | Shipments, routes | Supply chain, warehouse management |
| **💻 IT Infrastructure** | Template-Ready | Applications, systems | Topology, SLA management |

**Copy Banking vertical as template** to create your own domain-specific EBL!

---

## 📂 Project Structure

```
praxibility-ebl/
├── README.md                                    # 👈 You are here
├── GETTING_STARTED.md                           # 📘 Comprehensive tutorial
├── CONTRIBUTING.md                              # Contribution guidelines
├── LICENSE                                      # Apache 2.0
│
├── docs/                                        # Reference Documentation
│   ├── ebl-overview.md                         # Architecture + Lexicon
│   ├── ebl-classes.md                          # Class reference
│   └── data_model/                             # ERM schemas
│
└── EBL_v0.85/                                  # Current Version
 ├── CHANGELOG.md                            # Version history
 ├── CLEANUP_SUMMARY.md                      # v0.85 migration guide
 ├── HOWTO.md                                # Quick reference
 ├── TESTING.md                              # Testing strategy
 │
 ├── utilities/                              # ✨ Utility Scripts
 │   ├── README.md
 │   └── generate_vertical_parsers.sh       # Generate ANTLR parsers
 │
 └── verticals/                              # ✨ Self-Contained Verticals
 ├── README.md
 │
 ├── banking/                            # ✅ PRODUCTION-READY TEMPLATE
 │   ├── grammar/Banking_v0_85.g4       # ANTLR grammar with domain keywords
 │   ├── generated/                      # ANTLR-generated parsers
 │   │   ├── python/                    # Banking_v0_85Lexer.py, Parser.py
 │   │   └── java/                      # Java parsers (future)
 │   ├── validators/                     # ANTLR-based validators
 │   │   ├── python/
 │   │   │   ├── dictionary_validator.py   # Actor/verb/dataRef validation
 │   │   │   └── semantic_validator.py     # PCI-DSS, SOX, AML compliance
 │   │   └── java/
 │   │       └── BankingDictionaryValidator.java
 │   ├── tests/                          # Comprehensive test suites
 │   │   ├── python/test_banking_validator.py
 │   │   └── java/BankingValidatorTest.java
 │   ├── dictionary/
 │   │   └── banking_dictionary_v0.85.json
 │   ├── examples/                       # Real-world EBL files
 │   │   ├── MortgageLoanApplication.ebl
 │   │   ├── AFC_Fraud_SAR.ebl
 │   │   └── Payments_Screening.ebl
 │   └── data_model/                     # Banking schemas
 │
 ├── healthcare/                         # Template-ready
 ├── insurance/                          # Template-ready
 ├── kyc_compliance/                     # Template-ready
 ├── retail/                             # Template-ready
 ├── adtech/                             # Template-ready
 ├── logistics/                          # Template-ready
 └── it_infrastructure/                  # Template-ready
 [Each with the same structure: grammar/, validators/, tests/, etc.]
```

### Architecture Benefits

- ✅ **No Centralized Dependencies** - Verticals evolve independently
- ✅ **Domain-Specific Keywords** - SWIFT, IBAN (Banking), HL7, FHIR (Healthcare)
- ✅ **Isolated Testing** - Test one vertical without affecting others
- ✅ **Easy Onboarding** - Copy Banking vertical, customise dictionary/grammar
- ✅ **Multi-Language** - Same grammar → Python + Java + Go parsers

---

## 🏗️ EBL Language Constructs

### Core Classes

| Class | Purpose | Generates |
|-------|---------|-----------|
| **DataObject** | Canonical data schema + policies + I/O resources | DB schemas, JSON Schema, API contracts |
| **Entity** | Business entity with properties linked to DataObject | ERM/ORM classes, GraphQL types |
| **Process** | Workflow with actors, steps, events | BPMN, state machines, orchestration |
| **Rule** | Event-Condition-Action business logic | OPA/Rego policies, decision tables |
| **ITAsset** | Applications, systems, platforms | CMDB entries, architecture diagrams |
| **Relationship** | Typed links (depends_on, hosted_on, etc.) | Dependency graphs, compliance reports |
| **Integration** | External system connectors | API clients, error handlers |
| **Report** | Query specifications and schedules | SQL views, dashboards, jobs |

### Example: Banking DataObject

```ebl
DataObject DO_Payment {
 Schema:
 PaymentId: UUID, required, unique
 Amount: Currency, required, min=0
 Status: Enum, values=["Pending","Approved","Settled"]
 AccountNumber: String, encrypted

 Policies:
 - "PCI-DSS: Card data must be encrypted"
 - "SOX: Retained 7 years per regulations"

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

**Permission Model**: `Input` = Write, `Output` = Read

For complete syntax and validation rules, see [**ebl-classes.md**](docs/ebl-classes.md).

---

## 📚 Documentation

### Getting Started
- **[GETTING_STARTED.md](GETTING_STARTED.md)** - 📘 Complete tutorial with ANTLR basics
- **[HOWTO.md](EBL_v0.85/HOWTO.md)** - Quick reference commands
- **[TESTING.md](EBL_v0.85/TESTING.md)** - Testing strategy for all verticals

### Technical Reference
- **[ebl-overview.md](docs/ebl-overview.md)** - Architecture, lexicon, and ArchiMate mapping
- **[ebl-classes.md](docs/ebl-classes.md)** - Detailed class specifications and validation rules
- **[data_model/](docs/data_model/)** - ERM schemas (UUID-based and INT-based)

### Vertical Documentation
- **[verticals/README.md](EBL_v0.85/verticals/README.md)** - Overview of all verticals
- **[verticals/banking/README.md](EBL_v0.85/verticals/banking/README.md)** - Banking vertical guide
- **[CHANGELOG.md](EBL_v0.85/CHANGELOG.md)** - Version history

---

## 🎯 Use Cases

### Business Process Automation
Model KYC onboarding, loan approval, and claims processing workflows that compile to executable BPMN and orchestration code.

### Regulatory Compliance
Encode PCI-DSS card encryption rules, HIPAA data access policies, and SOX audit trails with compile-time validation.

### Enterprise Architecture
Define business capabilities and IT assets, and automatically generate ArchiMate diagrams of their relationships.

### Requirements Traceability
Link business goals → objectives → processes → requirements → capabilities → applications with complete lineage.

### Policy-as-Code
Transform compliance policies into OPA/Rego that enforces rules at runtime across microservices.

### API Contract Generation
Generate OpenAPI specs and GraphQL schemas directly from DataObject definitions.

---

## 🔧 Extending EBL

### Create Your Own Vertical

Banking vertical serves as a production-ready template. To create your own:

```bash
# 1. Copy Banking vertical structure
cp -r EBL_v0.85/verticals/banking EBL_v0.85/verticals/my_vertical

# 2. Customise the grammar
# Edit: verticals/my_vertical/grammar/MyVertical_v0_85.g4
# Add domain-specific keywords, types, lexer rules

# 3. Update the dictionary
# Edit: verticals/my_vertical/dictionary/my_vertical_dictionary_v0.85.json
# Define actors, verbs, dataObjects, relationshipTypes

# 4. Generate parsers
cd EBL_v0.85
java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 \
 -visitor -listener -o verticals/my_vertical/generated/python \
  verticals/my_vertical/grammar/MyVertical_v0_85.g4

# 5. Update validators
# Edit: verticals/my_vertical/validators/python/semantic_validator.py
# Add domain-specific compliance checks

# 6. Create examples
# Add .ebl files to: verticals/my_vertical/examples/

# 7. Write tests
# Edit: verticals/my_vertical/tests/python/test_my_vertical_validator.py

# 8. Validate!
cd verticals/my_vertical
python3 validators/python/dictionary_validator.py \
 examples/MyWorkflow.ebl \
  dictionary/my_vertical_dictionary_v0.85.json
```

See **[verticals/README.md](EBL_v0.85/verticals/README.md)** for detailed guidelines.

---

## 🤝 Contributing

We welcome contributions of all types! Here's how you can help:

### 📖 Documentation
- Improve guides, tutorials, and examples
- Fix typos and clarify confusing sections
- Add translations

### 🌍 Domain Dictionaries
- Create new verticals (Manufacturing, Energy, Telecom, Government)
- Enhance existing dictionaries with more actors/verbs
- Add compliance rules for new regulations

### 🧪 Testing
- Add test cases for edge cases
- Create integration tests
- Improve test coverage

### 🔧 Tooling
- VS Code extension for syntax highlighting
- Web-based validator
- ArchiMate diagram generator
- OpenAPI/GraphQL code generators

### 📝 Examples
- Contribute real-world EBL files from your Domain
- Add walkthroughs and tutorials
- Create video demonstrations

**How to contribute:**
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-contribution`
3. Make your changes and add tests
4. Run tests: `pytest` (Python) or `./run_tests.sh` (Java)
5. Submit a pull request

See [**CONTRIBUTING.md**](CONTRIBUTING.md) for detailed guidelines.

---

## 🗺️ Roadmap

### ✅ Completed in v0.85
- ✅ ANTLR-Based Vertical Independence
- ✅ Banking Vertical Production-Ready
- ✅ Automated Parser Generation
- ✅ Comprehensive Test Infrastructure
- ✅ Consolidated Documentation

### 🔮 Planned for v0.86+
- 🔧 **VS Code Extension** - Syntax highlighting, autocomplete, inline validation
- ☁️ **Cloud Validator Service** - Web-based validation without local setup
- 🎨 **Enhanced ArchiMate Export** - Round-trip editing and diagram generation
- 🧩 **Additional Verticals** - Manufacturing, Energy, Telecom, Public Sector
- 📊 **Advanced Analytics** - Complexity metrics, dependency graphs, technical debt
- 🤖 **LLM Integration** - Grammar-constrained decoding for AI-assisted EBL generation
- 🌐 **OpenAPI/GraphQL Generation** - Direct API spec generation from DataObjects
- 🔍 **Enhanced Semantic Validation** - Reachability analysis, SoD conflict detection

### 🌟 Community Wishlist
What would you like to see? [**Join the discussion**](https://github.com/Archailign/praxibility-ebl/discussions)!

---

## 📄 License

Enterprise Business Language (EBL) is released under the **Apache License 2.0**.

See the [LICENSE](LICENSE) file for details.

Copyright © 2025 **Praxibility**. All rights reserved.

---

## 💬 Community & Support

- **📖 Documentation**: [Getting Started Guide](GETTING_STARTED.md)
- **💬 Discussions**: [GitHub Discussions](https://github.com/Archailign/praxibility-ebl/discussions)
- **🐛 Issues**: [GitHub Issues](https://github.com/Archailign/praxibility-ebl/issues)
- **📧 Email**: [info@praxibility.com](mailto:info@praxibility.com)

---

## 🙏 Acknowledgments

Built with:
- **[ANTLR4](https://www.antlr.org/)** - Parser generator framework
- **Community Contributors** - Domain experts and open source developers
- **Praxibility Team** - Vision, architecture, and execution

**Supported by Claude and Agentic Tools**

---

## 🎉 Get Started Now!

```bash
git clone https://github.com/Archailign/praxibility-ebl.git
cd praxibility-ebl/EBL_v0.85/verticals/banking
python3 validators/python/dictionary_validator.py \
 examples/MortgageLoanApplication.ebl \
  dictionary/banking_dictionary_v0.85.json
```

**Transform requirements into executable reality with EBL.** 🚀

**Repository**: https://github.com/Archailign/praxibility-ebl
**Version**: 0.85 (ANTLR-Based Vertical Independence)
**License**: Apache 2.0