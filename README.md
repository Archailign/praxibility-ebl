# Enterprise Business Language (EBL)

**Structured Requirements. Executable Code. Seamless Traceability.**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![ANTLR](https://img.shields.io/badge/ANTLR-4-orange.svg)](https://www.antlr.org/)
[![Status](https://img.shields.io/badge/Status-Alpha-red.svg)](https://github.com/Archailign/praxibility-ebl)
[![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-brightgreen.svg)](CONTRIBUTING.md)

## Overview
**Archailign EBL**
The Enterprise Business Language (EBL)— is a domain-specific-language, extensible controlled language for expressing business requirements as validated, traceable, compilable artefacts. It bridges strategy and implementation by combining a curated enterprise lexicon with a formal grammar and a data/traceability model, enabling a Business analyst's natural business statements to be parsed and compiled into executable outputs.

EBL is designed for Business Analysts, Product Owners, Developers, Architects, and CXOs, ensuring requirements aren't static documents but living, executable specifications governed by a shared dictionary and modality/temporal constructs (e.g., SHALL, MUST NOT, WITHIN, ON/WHEN/THEN). These are curated by SMEs and enforced at compile time for consistency and auditability.

# What EBL enables #
Structured, unambiguous requirements using a controlled vocabulary, sentence frames, and modalities—ready for ANTLR-based parsing and semantic checks. 

End-to-end traceability from goals → objectives → processes → requirements → capabilities → data → policies → applications, that can be modeled into an Enterprise ERM to supports audits and impact analysis. 

- **Executable outputs:** when used with Archailign, it seemlessly generates architecture models (ArchiMate), policy bundles (e.g., OPA/Rego), APIs/config, and Architecture-as-Code / Infrastructure-as-Code artefacts attached to projects.

Policy-aware design by linking requirements and capabilities to Policies and DataObjects, enabling governance and compliance checks to be compiled alongside functional logic.

Domain portability via lexicon annexes (banking, pharma, retail, payments/KYC, insurance, MRP, public sector grants, aviation/MRO, adtech), each with actors, entities, verbs, and example rules.

# How it works (at a glance) #
- **Dictionary & Grammar:** A versioned Enterprise Business Lexicon and reserved keywords/verbs constrain phrasing and semantics (e.g., ECA: ON… WHEN… THEN…; temporal: BEFORE/WITHIN/BY).

- **Parsing & Validation:** ANTLR parses EBL; semantic rules (units, undefined symbols, modality) ensure the creation of compliant, compilable, and consistent EBL DSL.

- **Model Binding:** Statements bind to the ERM (Goals, Objectives, Processes, Requirements, Capabilities, DataObjects, Policies, Applications, Platforms), preserving links for traceability and reporting. 

- **Code Generation:** Compilers emit ArchiMate models, policy code, and AaC/IaC artefacts for each Project (fields are provided to store outputs).

# What's different #
- **Human-readable, machine-verifiable:** business-friendly syntax with developer-grade determinism. 

- **Compliance by construction**: requirements, data, and policies are linked and enforceable at compile and runtime. 

- **Architecture-aligned:** cross-walk to enterprise models (e.g., ArchiMate) with dictionary-driven consistency. Fits comfortably alongside TOGAF/Zachman practice.

- **In summary:** EBL turns human-written requirements into standardised, validated EBL that compiles to policy-aware architecture and infrastructure artefacts—closing the loop between intent and implementation.

### Key Features

- **Domain Adaptability**: Customizable grammar and industry-specific dictionaries for finance, healthcare, retail, logistics, and more
- **ANTLR-Powered**: Robust parsing and validation using ANTLR4 grammar definitions
- **Updatable Dictionaries**: JSON/YAML-based domain vocabularies maintained by subject matter experts
- **Multi-Language Support**: Generate parsers for Java, Python, and other ANTLR-supported languages
- **Executable Requirements**: Transform business requirements into validated, compilable artifacts
- **Enterprise Integration**: Built-in support for data objects, processes, rules, relationships, and IT assets
- **Traceability**: Maintain clear links between business policies and technical implementations

### Value Proposition

| Stakeholder | Challenge Solved | EBL Solution |
|:---|:---|:---|
| **Business Analysts** | Ambiguity and misinterpretation of requirements | Unified, human-readable syntax that enforces technical precision |
| **Developers** | Manual translation of requirements into code/config | Machine-readable requirements directly compilable into executable artifacts |
| **Architects** | Lack of traceability and compliance risk | Clear link between business policy and technical implementation |
| **Domain Experts** | Limited ability to customize business language | Extensible dictionary system tailored to industry terminology |

## Quick Start

**New to EBL?** → See the [**Getting Started Guide**](GETTING_STARTED.md) for a comprehensive tutorial with examples!

### Prerequisites

- Java Development Kit (JDK) 11 or higher
- Maven 3.6+ or Gradle 7+
- Python 3.8+ (for Python tooling)
- ANTLR4 (included in dependencies)

### Installation

```bash
# Clone the repository
git clone https://github.com/Archailign/praxibility-ebl.git
cd praxibility-ebl

# Build with Maven
cd EBL_v0.85
mvn clean install

# Or build with Gradle
gradle build

# Generate ANTLR parsers
mvn antlr4:antlr4
```

### Running Examples

```bash
# Validate an EBL file from a vertical
cd EBL_v0.85
python ebl_validator.py \
  verticals/banking/dictionary/banking_dictionary_v0.85.json \
  verticals/banking/examples/MortgageLoanApplication.ebl

# Explore verticals
ls verticals/

# Run all tests
mvn test
```

## Project Structure

```
praxibility-ebl/
├── README.md                          # Project overview and documentation
├── GETTING_STARTED.md                 # 📘 Comprehensive tutorial with examples
├── LICENSE                            # Apache 2.0 License
├── CONTRIBUTING.md                    # Contribution guidelines
├── CODE_OF_CONDUCT.md                 # Code of Conduct
├── .gitignore                         # Git ignore rules
│
├── docs/                              # Reference Documentation
│   ├── ebl-overview.md               # EBL architecture overview
│   ├── ebl-classes.md                # EBL class reference
│   ├── ebl-Lexicon.md                # Enterprise Business Lexicon specification
│   └── data_model/                   # Base data model schemas
│       ├── README.md                 # Data model documentation
│       ├── entity_relationship_model.txt  # UUID-based ERM schema
│       └── erm_schema.txt            # INT-based ERM schema
│
└── EBL_v0.85/                        # Current version (v0.85)
    │
    ├── CHANGELOG.md                  # Version history and release notes
    ├── HOWTO.md                      # Quick reference for commands
    │
    ├── .github/
    │   └── workflows/
    │       └── build-ebl.yml         # GitHub Actions CI/CD workflow
    │
    ├── src/
    │   ├── main/
    │   │   ├── antlr4/
    │   │   │   └── EBL.g4           # ANTLR4 grammar definition
    │   │   └── java/
    │   │       └── org/example/ebl/
    │   │           ├── EBLSemanticValidator.java
    │   │           └── EBLDictionarySymbols.java
    │   └── test/
    │       └── java/
    │           └── org/example/ebl/
    │               ├── SemanticValidatorTest.java
    │               ├── AdTechValidatorTest.java
    │               ├── BankingValidatorTest.java
    │               └── ... (all vertical tests)
    │
    ├── verticals/                    # 🎯 Industry-specific implementations
    │   ├── README.md                 # Verticals overview
    │   │
    │   ├── adtech/                   # Advertising Technology
    │   │   ├── README.md
    │   │   ├── examples/             # 2 AdTech examples
    │   │   ├── dictionary/           # AdTech vocabulary
    │   │   └── data_model/           # AdTech schemas
    │   │
    │   ├── banking/                  # Financial Services
    │   │   ├── README.md
    │   │   ├── examples/             # 3 Banking examples
    │   │   ├── dictionary/           # Banking vocabulary
    │   │   └── data_model/           # Banking schemas
    │   │
    │   ├── healthcare/               # Healthcare & Pharma
    │   │   ├── README.md
    │   │   ├── examples/             # 2 Healthcare examples
    │   │   ├── dictionary/           # Healthcare vocabulary
    │   │   └── data_model/           # Healthcare schemas
    │   │
    │   ├── insurance/                # Insurance & Risk
    │   │   ├── README.md
    │   │   ├── examples/             # 2 Insurance examples
    │   │   ├── dictionary/           # Insurance vocabulary
    │   │   └── data_model/           # Insurance schemas
    │   │
    │   ├── kyc_compliance/           # KYC & Governance
    │   │   ├── README.md
    │   │   ├── examples/             # 3 KYC examples
    │   │   ├── dictionary/           # KYC vocabulary
    │   │   └── data_model/           # KYC schemas
    │   │
    │   ├── retail/                   # Retail & E-Commerce
    │   │   ├── README.md
    │   │   ├── examples/             # 2 Retail examples
    │   │   ├── dictionary/           # Retail vocabulary
    │   │   └── data_model/           # Retail schemas
    │   │
    │   ├── logistics/                # Logistics & Supply Chain
    │   │   ├── README.md
    │   │   ├── examples/             # 1 Logistics example
    │   │   ├── dictionary/           # Logistics vocabulary
    │   │   └── data_model/           # Logistics schemas
    │   │
    │   └── it_infrastructure/        # IT Operations
    │       ├── README.md
    │       ├── examples/             # 2 IT examples
    │       ├── dictionary/           # IT vocabulary
    │       └── data_model/           # IT schemas
    │
    ├── tests/                        # Python test suites
    │   ├── test_semantic_validation.py
    │   ├── test_adtech_full.py
    │   ├── test_banking.py
    │   └── ... (all vertical tests)
    │
    ├── generated-src/                # ANTLR-generated parsers (post-build)
    │   ├── java/                     # Java parser output
    │   └── python/                   # Python parser output
    │
    ├── EBL_Dictionary_v0.85_all.json # Master multi-domain dictionary
    ├── EBL_Dictionary_v0.85_all.yaml # Master multi-domain dictionary (YAML)
    ├── ebl_validator.py              # Python validator script
    ├── pom.xml                       # Maven build configuration
    └── build.gradle.kts              # Gradle build configuration
```

### Key Directories

| Directory | Purpose |
|-----------|---------|
| `src/main/antlr4/` | ANTLR4 grammar file (EBL.g4) |
| `src/main/java/` | Java semantic validators and symbol loaders |
| `src/test/java/` | Java unit tests for validators |
| `verticals/` | Industry-specific implementations with examples, dictionaries, and data models |
| `tests/` | Python test suites using pytest |
| `generated-src/` | ANTLR-generated parsers (created during build) |
| `docs/` | Architecture documentation and lexicon specs |
| `.github/workflows/` | CI/CD automation with GitHub Actions |

## Language Features

EBL supports the following core constructs:

### Core Types

- **DataObject**: Schema, policies, and resource definitions for data structures
- **Entity**: Business entities with properties, rules, and data references
- **Process**: Business process workflows with steps, actors, and events
- **Rule**: Business rules with triggers, conditions, and actions
- **ITAsset**: IT infrastructure (applications, systems, platforms)
- **Relationship**: Relationships between entities and IT assets
- **Report**: Reporting definitions with queries and schedules
- **Integration**: External system integrations

### Domain Dictionary

The EBL dictionary system includes:

- **Core Types**: UUID, String, Integer, Currency, Ratio, Date, Enum, JSON, Boolean
- **Actors**: Domain-specific roles and actors
- **Verbs**: Actions with read/write permissions
- **Relationship Types**: consists_of, depends_on, hosted_on, supports, communicates_with, etc.
- **Vertical-Specific Dictionaries**: Pre-built vocabularies organized by industry vertical:
  - **AdTech** (`verticals/adtech/dictionary/`) - Campaigns, audiences, bidding
  - **Banking** (`verticals/banking/dictionary/`) - Payments, accounts, transactions, lending
  - **Healthcare** (`verticals/healthcare/dictionary/`) - Trials, patients, protocols
  - **Insurance** (`verticals/insurance/dictionary/`) - Policies, claims, underwriting
  - **KYC/Compliance** (`verticals/kyc_compliance/dictionary/`) - Identity verification, compliance
  - **Retail** (`verticals/retail/dictionary/`) - Inventory, orders, customers
  - **Logistics** (`verticals/logistics/dictionary/`) - Shipments, warehouses, routes
  - **IT Infrastructure** (`verticals/it_infrastructure/dictionary/`) - Applications, systems, platforms

Each vertical includes its own dictionary, examples, and data model for isolated, domain-focused development.

### Example EBL Snippet

```ebl
DataObject LoanApplication {
    Schema:
        loanId: UUID, required
        applicantName: String, required
        amount: Currency, required
        status: Enum, values=[Pending,Approved,Rejected]

    Policies:
        - Must comply with lending regulations
        - PII data encrypted at rest

    Resources:
        Input: { Channel: API, Protocol: HTTPS, ... }
        Output: { Channel: Database, Protocol: SQL, ... }

    erMap: ER_LoanApplication
}

Entity Applicant {
    dataRef: LoanApplication
    Properties:
        creditScore: { type: Integer, required: true }
        income: { type: Currency, required: true }
    Rules:
        - "Credit score must be above 600"
    erMap: ER_Applicant
}
```

## Documentation

### Getting Started
- **[GETTING_STARTED.md](GETTING_STARTED.md)** - 📘 Comprehensive tutorial with real examples
- [HOWTO.md](EBL_v0.85/HOWTO.md) - Quick reference for commands and tools

### Reference Documentation
- [CHANGELOG.md](EBL_v0.85/CHANGELOG.md) - Version history and updates
- [ebl-overview.md](docs/ebl-overview.md) - EBL architecture and design overview
- [ebl-classes.md](docs/ebl-classes.md) - EBL class reference
- [ebl-Lexicon.md](docs/ebl-Lexicon.md) - Enterprise Business Lexicon specification
- [data_model/](docs/data_model/) - ERM schemas for traceability

## Use Cases

EBL is ideal for:

- **Business Process Automation**: Define workflows that compile to executable code
- **Regulatory Compliance**: Encode governance policies with built-in validation
- **Cross-Functional Collaboration**: Shared language between business and technical teams
- **Domain-Specific Solutions**: Customize for regulated industries (finance, healthcare, insurance)
- **Requirements Traceability**: Link business requirements to technical implementations
- **Enterprise Architecture**: Model business capabilities, IT assets, and relationships

## Extending EBL

### Adding Custom Domains

**Option 1: Create a New Vertical**

1. Create vertical directory structure:
   ```bash
   mkdir -p verticals/my_vertical/{examples,dictionary,data_model}
   ```

2. Create vertical-specific dictionary in `verticals/my_vertical/dictionary/my_vertical_dictionary_v0.85.json`:
   - Define domain-specific actors (roles)
   - Define verbs (actions with permissions)
   - Define data objects and entities
   - Define relationship types

3. Add example EBL files to `verticals/my_vertical/examples/`

4. Create data model schemas in `verticals/my_vertical/data_model/`

5. Validate against your vertical dictionary:
   ```bash
   python ebl_validator.py \
     verticals/my_vertical/dictionary/my_vertical_dictionary_v0.85.json \
     verticals/my_vertical/examples/MyWorkflow.ebl
   ```

See [verticals/README.md](EBL_v0.85/verticals/README.md) for detailed guidelines.

**Option 2: Extend Existing Dictionary**

1. Edit an existing vertical dictionary or `EBL_Dictionary_v0.85_all.json` to add domain-specific elements

2. Update dictionary version and validate against grammar

3. Run validators to ensure consistency

### Modifying Grammar

1. Edit `src/main/antlr4/EBL.g4` to extend grammar rules
2. Regenerate parsers: `mvn antlr4:antlr4`
3. Update validators to handle new constructs
4. Add examples and test cases

## Contributing

We welcome contributions from the community! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Code of Conduct
- How to submit issues and feature requests
- Pull request process
- Coding standards
- Testing requirements

## Versioning

EBL follows semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking grammar changes
- **MINOR**: New features, backward-compatible
- **PATCH**: Bug fixes, documentation updates

Current version: **0.85**

## License

Enterprise Business Language (EBL) is released under the **Apache License 2.0**.

See the [LICENSE](LICENSE) file for details.

## Copyright

Copyright © 2025 **Praxibility**. All rights reserved.

EBL is an open-source framework developed by Praxibility to foster collaboration in enterprise business language standardization.

## Community & Support

- **Issues**: [GitHub Issues](https://github.com/Archailign/praxibility-ebl/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Archailign/praxibility-ebl/discussions)
- **Email**: [Contact Praxibility](mailto:info@praxibility.com)

## Roadmap

- [ ] VS Code extension for EBL syntax highlighting
- [ ] Cloud-hosted EBL validator service
- [ ] ArchiMate model generation from EBL
- [ ] Additional domain packs (manufacturing, energy, telco)
- [ ] EBL to OpenAPI/GraphQL schema generation
- [ ] Enhanced tooling for dictionary management

## Acknowledgments

Built with:
- [ANTLR4](https://www.antlr.org/) - Parser generator
- Community contributors and domain experts

---

**Transform requirements into executable reality with EBL.**
