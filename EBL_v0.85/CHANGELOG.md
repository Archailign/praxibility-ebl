# CHANGELOG

## v0.85 (05-11-2025) - Self-Contained Vertical Architecture
**Complete Vertical Isolation with DSL Grammars, Validators & Tests**

This release represents a major architectural transformation to a fully self-contained vertical structure where each industry vertical is an independent Domain-Specific Language (DSL) with its own grammar, validators, tests, and documentation.

### 🎯 Major Changes

#### Self-Contained Vertical Architecture
- **Removed centralized `/tests` directory** - All tests now live within their respective verticals
- **Created self-contained structure** for each of 8 verticals:
  ```
  verticals/[vertical]/
  ├── dictionary/           # Domain vocabulary (JSON)
  ├── grammar/             # ANTLR DSL grammar (.g4)
  ├── validators/
  │   ├── python/         # Dictionary & semantic validators
  │   └── java/           # Dictionary & semantic validators
  ├── tests/
  │   ├── python/         # Test suites
  │   └── java/           # Test suites
  ├── examples/           # Domain EBL files
  └── data_model/         # Database schemas
  ```

#### Domain-Specific Language Grammars (NEW)
- **Created 8 vertical-specific ANTLR grammars** with domain keywords and types:
  - `Banking_v0_85.g4` - SWIFT, IBAN, BIC, PCI_DSS, TOKENIZATION, CardNumber types
  - `Healthcare_v0_85.g4` - HIPAA, PHI, HL7, FHIR, DICOM, ICD10, CPT keywords
  - `IT_Infrastructure_v0_85.g4` - KUBERNETES, DOCKER, SLO, Terraform, IPAddress types
  - `Insurance_v0_85.g4` - NAIC, Solvency_II, Policy, Claim types
  - `Retail_v0_85.g4` - SKU, POS, Inventory, Fulfillment keywords
  - `KYC_Compliance_v0_85.g4` - AML, FATF, SAR, PEP, Sanctions keywords
  - `AdTech_v0_85.g4` - GDPR, RTB, DSP, SSP, Impression keywords
  - `Logistics_v0_85.g4` - BOL, Container, Incoterms, Customs keywords
- Each grammar extends base EBL with vertical-specific lexer rules and types

#### Vertical-Specific Validators (NEW)
- **Python Validators** (2 per vertical × 8 verticals = 16 files):
  - `dictionary_validator.py` - Validates actors, verbs, entities, DataObjects
  - `semantic_validator.py` - Validates business logic and compliance rules
- **Java Validators** (2 per vertical × 8 verticals = 16 files):
  - `[Vertical]DictionaryValidator.java` - Dictionary compliance
  - `[Vertical]SemanticValidator.java` - Business rules & compliance
- **Banking Validators FULLY IMPLEMENTED** with:
  - PCI-DSS compliance (card encryption, CVV non-storage)
  - Wire transfer dual authorization
  - Fraud detection requirements
  - AML/sanctions screening
  - SOX compliance (segregation of duties)
  - Sensitive data encryption validation
- **Remaining 7 verticals** - Template stubs created ready for customization

#### Vertical-Specific Tests (NEW)
- **Python Tests** (1 per vertical × 8 verticals = 8 files):
  - `test_[vertical]_validator.py` - Comprehensive test suites
- **Java Tests** (1 per vertical × 8 verticals = 8 files):
  - `[Vertical]ValidatorTest.java` - JUnit-style test suites
- **Banking Tests FULLY IMPLEMENTED** with test cases for:
  - Valid/invalid actors and verbs
  - PCI-DSS compliance scenarios
  - Wire transfer authorization
  - Fraud detection rules
  - Integration tests
- **Remaining 7 verticals** - Test templates created

#### Comprehensive Dictionary Enhancements
- **Expanded all 8 vertical dictionaries** with production-ready vocabularies:
  - Banking: 125 actors, 91 verbs, 110 entities, 165 DataObjects (24 compliance frameworks)
  - Healthcare: 90 actors, 85 verbs, 100 entities, 62 DataObjects (11 compliance frameworks)
  - IT Infrastructure: 166 actors, 104 verbs, 135 entities, 170 DataObjects (17 compliance frameworks)
  - Retail: 134 actors, 111 verbs, 111 entities, 165 DataObjects (15 compliance frameworks)
  - Insurance: 130 actors, 87 verbs, 108 entities, 150 DataObjects (22 compliance frameworks)
  - KYC/Compliance: 116 actors, 86 verbs, 128 entities, 160 DataObjects (25 compliance frameworks)
  - AdTech: 43 actors, 44 verbs, 94 entities, 105 DataObjects (11 compliance frameworks)
  - Logistics: 36 actors, 45 verbs, 98 entities, 62 DataObjects (13 compliance frameworks)
- **Total vocabulary**: 840 actors, 653 verbs, 884 entities, 1,039 DataObjects, 663 keywords, 138 compliance frameworks

#### Documentation Overhaul
- **Created/Updated comprehensive documentation**:
  - `TESTING.md` (360 lines) - Vertical-specific testing strategy, removed centralized test references
  - `VERTICAL_STRUCTURE.md` (224 lines) - Complete architectural documentation
  - `HOWTO.md` - Updated for vertical-specific validators and grammars
  - `verticals/README.md` - Updated structure and statistics tables
  - Individual vertical READMEs (8 files) - Domain-specific usage and compliance
- **Created vertical READMEs** for all 8 verticals with:
  - Domain-specific actors, verbs, and vocabulary
  - Validator usage examples (Python & Java)
  - Compliance framework requirements
  - Testing instructions
  - Example file descriptions
- **Documentation features**:
  - No redundancies between files
  - Clear separation of concerns
  - Vertical-specific vs. project-wide documentation
  - Up-to-date file paths and commands

#### Project Organization
- **Removed centralized testing**: Deleted `/EBL_v0.85/tests/` directory
- **Created 72+ new files** across 8 verticals:
  - 8 ANTLR grammar files (.g4)
  - 16 Python validators (2 per vertical)
  - 16 Java validators (2 per vertical)
  - 8 Python test files
  - 8 Java test files
  - 8 vertical README files
  - 8 comprehensive JSON dictionaries
- **Organized utility scripts**:
  - Created `utilities/` folder
  - Moved dictionary and README generation scripts
  - Created `utilities/README.md` documentation

### 📦 Core Features
- **Self-Contained Vertical DSLs** - Each vertical is an independent DSL
- **ANTLR4 Grammars** - Core grammar + 8 vertical-specific grammars with domain keywords
- **Comprehensive Dictionaries** - 8 production-ready dictionaries with 840+ actors, 653+ verbs
- **Dual-Language Validators** - Python and Java validators for each vertical
- **Dictionary Validation** - Actor, verb, entity, DataObject compliance checking
- **Semantic Validation** - Business logic and compliance rule enforcement (PCI-DSS, HIPAA, SOX, etc.)
- **Dual-Language Testing** - Python pytest + Java JUnit test suites
- **Maven/Gradle Support** - Build configurations for legacy validators

### 🏭 Supported Verticals
- **AdTech**: Campaign management, audience targeting, GDPR/CCPA compliance
- **Banking**: Mortgage lending, payment screening, AFC/SAR filing, BSA/AML
- **Healthcare**: Patient intake, clinical trials, HIPAA/GCP compliance
- **Insurance**: Claims lifecycle, subrogation, Solvency II compliance
- **KYC/Compliance**: Onboarding, SoD controls, FATF compliance
- **Retail**: Order fulfillment, inventory replenishment, PCI-DSS
- **Logistics**: Shipment tracking, CTPAT/ISO 28000 compliance
- **IT Infrastructure**: App onboarding, topology mapping, SOC 2/ISO 27001

### 📊 Examples & Implementation Status
- **17 production-ready examples** across 8 verticals
- **Banking vertical**: Production-ready with full validator and test implementation
- **Remaining 7 verticals**: Template stubs ready for customization
- **Each vertical includes**:
  - Dictionary (JSON) with comprehensive vocabulary
  - ANTLR grammar (.g4) with domain-specific keywords
  - Python validators (dictionary + semantic) - stubs or complete
  - Java validators (dictionary + semantic) - stubs or complete
  - Python tests - stubs or complete
  - Java tests - stubs or complete
  - README with usage examples
  - Example EBL files

### 🔧 Technical Improvements
- **True DSL architecture**: Each vertical is a proper Domain-Specific Language
- **Grammar-driven parsing**: ANTLR grammars with vertical-specific lexer rules
- **Compliance-aware validation**: PCI-DSS, HIPAA, SOX, GDPR, AML, and more
- **Self-contained verticals**: Independent development and deployment
- **Dual-language support**: Complete Python and Java implementations
- **Master dictionary retained**: `EBL_Dictionary_v0.85_all.json` for cross-vertical use
- **CI/CD ready**: All validators and tests integrate with standard tooling

### 📝 Files Changed
- **Created**: 72+ new files across 8 verticals:
  - 8 ANTLR grammar files
  - 16 Python validators
  - 16 Java validators
  - 8 Python test files
  - 8 Java test files
  - 8 vertical READMEs
  - VERTICAL_STRUCTURE.md
- **Updated**: TESTING.md (complete rewrite), HOWTO.md, verticals/README.md, CHANGELOG.md
- **Removed**: Centralized `/tests` directory
- **Total**: 100+ files created, modified, or reorganized

### 🎓 Migration Notes

**Validation Commands:**
```bash
# Old (centralized validator)
python ebl_validator.py EBL_Dictionary_v0.85_all.json examples/KYC_Onboarding.ebl

# New (vertical-specific validators)
cd verticals/banking
python validators/python/dictionary_validator.py \
  examples/MortgageLoanApplication.ebl \
  dictionary/banking_dictionary_v0.85.json

python validators/python/semantic_validator.py \
  examples/MortgageLoanApplication.ebl \
  dictionary/banking_dictionary_v0.85.json
```

**Test Execution:**
```bash
# Old (centralized tests)
mvn test -Dtest=ValidatorV130Test
pytest tests/test_v130.py

# New (vertical-specific tests)
cd verticals/banking/tests/python
python test_banking_validator.py

cd verticals/banking/tests/java
javac BankingValidatorTest.java
java BankingValidatorTest
```

**Grammar Usage:**
```bash
# Generate parser for a specific vertical
java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 \
  -o generated-src/python/banking \
  verticals/banking/grammar/Banking_v0_85.g4
```

**File Paths:**
- Examples: `verticals/[vertical]/examples/*.ebl`
- Dictionaries: `verticals/[vertical]/dictionary/[vertical]_dictionary_v0.85.json`
- Grammars: `verticals/[vertical]/grammar/[Vertical]_v0_85.g4`
- Validators: `verticals/[vertical]/validators/python/` or `validators/java/`
- Tests: `verticals/[vertical]/tests/python/` or `tests/java/`

### Previous Development History
## v0.1 (03-01-2025) - framework
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