# Enterprise Business Language (EBL)

**Structured Requirements. Executable Code. Seamless Traceability.**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![ANTLR](https://img.shields.io/badge/ANTLR-4-orange.svg)](https://www.antlr.org/)
[![Status](https://img.shields.io/badge/Status-Alpha-red.svg)](https://github.com/Archailign/praxibility-ebl)
[![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-brightgreen.svg)](CONTRIBUTING.md)

## Overview

**Enterprise Business Language (EBL)** is a domain-specific language (DSL) framework built on ANTLR that enables organizations to define complex business requirements in a structured, machine-readable format. EBL bridges the gap between business strategy and technical implementation through an extensible dictionary and grammar system that can be customized for any industry or enterprise focus.

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
# Validate an EBL file
python ebl_validator.py examples/MortgageLoanApplication.ebl

# View example files
ls examples/
```

## Project Structure

```
praxibility-ebl/
├── README.md                          # This file
├── LICENSE                            # Apache 2.0 License
├── CONTRIBUTING.md                    # Contribution guidelines
├── CODE_OF_CONDUCT.md                 # Code of Conduct
├── .gitignore                         # Git ignore rules
├── docs/                              # Documentation
│   ├── business_lexicon_ebl_requirements.md
│   ├── business-req-sample.md
│   ├── EBL_ERM_Documentation.markdown
│   ├── ebl-classes.md                # EBL class documentation
│   ├── entity_relationship_model.txt # ERM documentation
│   ├── ERM_Schema.txt                # Entity relationship schema
│   ├── BimL_ The Enterprise Business Language (EBL).md
│   └── prompt-studio.md
└── EBL_v0.85/                        # Current version
    ├── src/main/antlr4/
    │   └── EBL.g4                    # ANTLR grammar definition
    ├── src/main/java/                # Java source code
    │   └── org/example/ebl/
    │       ├── EBLSemanticValidator.java
    │       └── EBLDictionarySymbols.java
    ├── src/test/java/                # Java tests
    │   └── org/example/ebl/
    │       ├── ValidatorV130Test.java
    │       └── AdTechValidatorTest.java
    ├── EBL_Dictionary_v0.85.json     # Core domain dictionary
    ├── EBL_Dictionary_v0.85_all.json # Extended multi-domain dictionary
    ├── EBL_Dictionary_v0.85.yaml     # YAML format dictionaries
    ├── EBL_Dictionary_v0.85_all.yaml
    ├── ebl_validator.py              # Python validator
    ├── pom.xml                       # Maven build configuration
    ├── build.gradle.kts              # Gradle build configuration
    ├── CHANGELOG.md                  # Version history
    ├── HOWTO.md                      # Detailed usage guide
    ├── overview-guide.md             # Architecture overview
    ├── examples/                     # Domain-specific examples
    │   ├── AdCampaignManagement.ebl
    │   ├── AdTech_Dynamic_Marketing_Cycle_Full.ebl
    │   ├── Healthcare_PatientIntake.ebl
    │   ├── Insurance_ClaimLifecycle.ebl
    │   ├── IT_Application_Onboarding.ebl
    │   ├── KYC_Onboarding.ebl
    │   ├── Logistics_Tracking.ebl
    │   ├── Payments_Screening.ebl
    │   ├── Retail_Order_Inventory.ebl
    │   └── ...
    ├── generated-src/                # ANTLR-generated parsers
    │   ├── java/
    │   └── python/
    └── tests/                        # Test suites
```

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
- **Domain Packs**: Pre-built vocabularies for industries:
  - AdTech (campaigns, audiences, bidding)
  - Healthcare (trials, patients, protocols)
  - Retail (inventory, orders, customers)
  - Logistics (shipments, warehouses, routes)
  - Finance (payments, accounts, transactions)
  - Insurance (policies, claims, underwriting)
  - KYC (identity verification, compliance)

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

- [CHANGELOG.md](EBL_v0.85/CHANGELOG.md) - Version history and updates
- [HOWTO.md](EBL_v0.85/HOWTO.md) - Detailed usage instructions
- [overview-guide.md](EBL_v0.85/overview-guide.md) - Architecture and design overview
- [ebl-classes.md](docs/ebl-classes.md) - EBL class reference
- [business_lexicon_ebl_requirements.md](docs/business_lexicon_ebl_requirements.md) - Requirements specification
- [EBL_ERM_Documentation.markdown](docs/EBL_ERM_Documentation.markdown) - Entity-Relationship Model documentation
- [ERM_Schema.txt](docs/ERM_Schema.txt) - ERM schema definition

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

1. Edit `EBL_Dictionary_v0.85.json` to add domain-specific:
   - Actors (roles)
   - Verbs (actions with permissions)
   - Data objects
   - Relationship types

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
