# CHANGELOG

## v0.85 (2025-01-03)
**Initial Open Source Release**

This is the first public release of Enterprise Business Language (EBL) under Apache 2.0 license.

### Core Features
- ANTLR4 grammar definition for EBL syntax
- Domain dictionaries (JSON/YAML) with multi-industry support
- Java semantic validator and dictionary symbol loader
- Python validator for EBL files
- Maven and Gradle build configurations
- Comprehensive documentation and examples

### Supported Domains
- **AdTech**: Campaigns, audiences, bidding
- **Healthcare**: Clinical trials, patient intake, protocols
- **Insurance**: Claims lifecycle, subrogation, underwriting
- **Finance/Payments**: Screening, transactions, accounts
- **KYC**: Onboarding, identity verification, compliance
- **Logistics**: Tracking, warehouses, routes
- **Retail**: Inventory, orders, customers
- **IT/Infrastructure**: Applications, systems, topology

### Examples Included
15+ real-world EBL examples across all supported domains

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