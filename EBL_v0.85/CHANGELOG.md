# CHANGELOG

## v0.85 (05-11-2025) - Major Restructure & Test Coverage
**Vertical Organization & Comprehensive Testing**

This release represents a major structural improvement to the EBL project with complete vertical-based organization and near-complete test coverage.

### 🎯 Major Changes

#### Vertical-Based Organization
- **Restructured project** into 8 industry-specific verticals, each with isolated:
  - Examples directory (`verticals/[vertical]/examples/`)
  - Domain dictionary (`verticals/[vertical]/dictionary/`)
  - Data model schemas (`verticals/[vertical]/data_model/`)
  - Vertical-specific README documentation
- **Created vertical structure** for:
  - AdTech (Advertising Technology) - 2 examples
  - Banking (Financial Services) - 3 examples
  - Healthcare (Healthcare & Pharma) - 2 examples
  - Insurance (Insurance & Risk) - 2 examples
  - KYC/Compliance (Governance) - 3 examples
  - Retail (Retail & E-Commerce) - 2 examples
  - Logistics (Supply Chain) - 1 example
  - IT Infrastructure (IT Operations) - 2 examples

#### Test Coverage Improvements
- **Created 10 new test files** (5 Java + 5 Python):
  - `BankingValidatorTest.java` / `test_banking.py` - 3 tests
  - `HealthcareValidatorTest.java` / `test_healthcare.py` - 2 tests
  - `RetailValidatorTest.java` / `test_retail.py` - 2 tests
  - `LogisticsValidatorTest.java` / `test_logistics.py` - 1 test
  - `ITInfrastructureValidatorTest.java` / `test_it_infrastructure.py` - 2 tests
- **Improved test coverage** from 29% (5/17 examples) to 88% (15/17 examples)
- **Renamed tests** for clarity:
  - `ValidatorV130Test.java` → `SemanticValidatorTest.java`
  - `test_v130.py` → `test_semantic_validation.py`
- **Updated existing tests** to use v0.85 and vertical structure

#### Documentation Overhaul
- **Created comprehensive TESTING.md** (450+ lines) documenting:
  - Test organization and strategy
  - When to use Java vs Python tests
  - Running tests and adding new tests
  - Coverage goals and CI/CD integration
  - Best practices and troubleshooting
- **Updated all documentation** to reflect vertical structure:
  - README.md - Project structure and vertical organization
  - GETTING_STARTED.md - All examples use vertical paths
  - HOWTO.md - Validation commands updated
  - CONTRIBUTING.md - Test guidelines and vertical workflow
  - docs/ebl-overview.md - Architecture updates
  - discussion.md - Launch documentation
- **Created vertical READMEs** for all 8 verticals with:
  - Domain-specific actors and verbs
  - Example descriptions and use cases
  - Compliance requirements (HIPAA, GDPR, PCI-DSS, etc.)
  - Validation examples
- **Created verticals/README.md** - Overview of vertical structure

#### Project Cleanup
- **Removed redundant files**:
  - Deleted legacy `examples/` folder (17 files moved to verticals)
  - Removed duplicate `adTech_Dictionary_v0.85.json/yaml` (now in verticals)
  - Cleaned up `.DS_Store` system files (2 files)
- **Organized utility scripts**:
  - Created `utilities/` folder
  - Moved `create_vertical_dictionaries.py` to utilities
  - Moved `create_vertical_readmes.py` to utilities
  - Created `utilities/README.md` documentation
- **Standardized file references** across all documentation

### 📦 Core Features
- ANTLR4 grammar definition for EBL syntax
- Domain dictionaries (JSON/YAML) with multi-industry support
- Java semantic validator and dictionary symbol loader
- Python validator for EBL files
- Maven and Gradle build configurations
- Comprehensive dual-language testing (Java + Python)

### 🏭 Supported Verticals
- **AdTech**: Campaign management, audience targeting, GDPR/CCPA compliance
- **Banking**: Mortgage lending, payment screening, AFC/SAR filing, BSA/AML
- **Healthcare**: Patient intake, clinical trials, HIPAA/GCP compliance
- **Insurance**: Claims lifecycle, subrogation, Solvency II compliance
- **KYC/Compliance**: Onboarding, SoD controls, FATF compliance
- **Retail**: Order fulfillment, inventory replenishment, PCI-DSS
- **Logistics**: Shipment tracking, CTPAT/ISO 28000 compliance
- **IT Infrastructure**: App onboarding, topology mapping, SOC 2/ISO 27001

### 📊 Examples & Test Coverage
- **17 production-ready examples** across 8 verticals
- **15/17 examples tested** (88% coverage)
- **All verticals covered** (100% vertical coverage)
- Dual-language tests (Java JUnit + Python pytest)

### 🔧 Technical Improvements
- **Master dictionary retained**: `EBL_Dictionary_v0.85_all.json/yaml` for cross-vertical use
- **Vertical isolation**: Each vertical has independent dictionary and data model
- **Test suite**: Comprehensive semantic validation across all verticals
- **CI/CD ready**: All tests integrate with Maven/Gradle and pytest
- **Documentation**: 450+ lines of testing documentation

### 📝 Files Changed
- **Created**: 10 test files, 9 vertical READMEs, TESTING.md, utilities/README.md
- **Updated**: README.md, GETTING_STARTED.md, HOWTO.md, CONTRIBUTING.md, docs/ebl-overview.md, discussion.md
- **Moved**: 17 example files, 2 utility scripts
- **Removed**: examples/ folder, duplicate dictionaries, system files
- **Renamed**: 2 test files for clarity

### 🎓 Migration Notes
- **Examples moved**: `examples/*.ebl` → `verticals/[vertical]/examples/*.ebl`
- **Dictionaries**: Use vertical-specific dictionaries in `verticals/[vertical]/dictionary/`
- **Validation**: Update commands to use vertical structure:
  ```bash
  # Old
  python ebl_validator.py EBL_Dictionary_v0.85_all.json examples/KYC_Onboarding.ebl

  # New
  python ebl_validator.py \
    verticals/kyc_compliance/dictionary/kyc_compliance_dictionary_v0.85.json \
    verticals/kyc_compliance/examples/KYC_Onboarding.ebl
  ```
- **Tests**: Run with new names:
  ```bash
  mvn test -Dtest=SemanticValidatorTest  # was ValidatorV130Test
  pytest tests/test_semantic_validation.py  # was test_v130.py
  ```

### 🚀 Supported by
Claude Code and Agentic Tools

### Previous Development History
- v0.7: added verbPermissions; ensured Java files included.

## v0.84
- **Dictionary**: merged domains (retail, logistics, payments, healthcare, afc) + IT meta-domain; verbPermissions & relationshipTypes.
- **Grammar**: added `Relationship` and `ITAsset` constructs.
- **Validators**: full action checks (actor/verb whitelist + R/W permissions) + relationship checks (unknown names, type whitelist, hosted_on governance hint).
- **CI**: GitHub Actions to generate Java/Python ANTLR targets.
- **Examples**: 5 domain examples + 2 IT examples (placeholders here).

## v0.83
- ERM-aligned updates (Risk/Control/Metric/SLA, SoD/Traceability).

## v0.8.2 (Full Toolchain)
- Merged domains (retail, logistics, payments, healthcare, afc, it) with ERM objects.
- Grammar supports Relationship endpoints as Actor/Entity/ITAsset.
- Java/Python validators implement action permission inference + relationship hygiene (name/type/hosted_on governance hint).
- CI workflow generates Java/Python ANTLR targets.

## v0.81
- Added **Insurance** and **KYC** domain packs (actors, verbs, DataObjects, permissions).
- **Validators**: new optional checks
  - Warn on **reserved keyword** misuse inside free-text (Validation, Rule.Trigger/Description, Report.Query).
  - **Enum** default value must be a member of the declared `values` set for Entity properties.
- CI: runs ANTLR generation + Maven & Gradle builds + Python pytest; publishes artifacts.

## v0.8
- Insurance: Fraud & Subrogation actors/verbs/data; example added.
- KYC: Jurisdictional document types (US/UK/DE/IN) & rules DO; example added.
- Validators: numeric `min`/`max` on DataObject fields; Enum field must specify `values=` (warn); retain reserved-keyword warnings, enum default checks, relationship & permission lint.
- CI/HOWTO updated.

## v0.79
- **Backward-compatible**: grammar unchanged from v0.7; all new rules are warnings (non-breaking).
- **Dictionary**: 
  - KYC: extended `docTypesByJurisdiction` with EU_EIDAS, AU, NZ, AE, SA, QA, KW.
  - Insurance: reinforced subrogation objects; kept `subrogates_against` relationship type.
- **Validators (Java/Python)**:
  - New warnings: 
    - **Unused actors** in a Process (declared but not used in Actions).
    - **Verb never permitted** by any actor in domain whitelist.
  - Retained earlier validations: reserved keyword warnings, entity enum default∈values, DataObject numeric range, Enum without values list (warn), relationship & governance lint, actor→verb whitelist and data permissions, entity→dataRef, DO policies/resources.
- **Examples**:
  - `Insurance_Subrogation_Counterparty.ebl` — includes `subrogates_against` and an intentionally unused actor to demo lint.
  - `KYC_Verb_NeverPermitted.ebl` — uses a domain verb not whitelisted by any actor to demo the new warning.
- **Build/CI/Docs**: Maven/Gradle/pytest CI preserved; HOWTO updated.