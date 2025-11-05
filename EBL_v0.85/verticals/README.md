# EBL Verticals - Domain-Specific Business Language Implementation

## Overview

The **verticals** directory organizes Archailign Business Engineering EBL by industry domain. Each vertical is a self-contained package with domain-specific examples, dictionaries, and data models.

### Why Verticals?

- **Domain Focus** - Industry-specific actors, verbs, and entities
- **Isolated Dictionaries** - No vocabulary conflicts between domains
- **Targeted Validation** - Validate against vertical-specific rules
- **Specialized Data Models** - Industry-specific database schemas
- **Independent Evolution** - Verticals evolve at their own pace

## Structure

Each vertical contains:

```
vertical_name/
├── README.md                               # Vertical-specific documentation
├── examples/                               # Domain EBL examples
│   └── *.ebl                              # Production-ready workflows
├── dictionary/                             # Domain vocabulary
│   └── vertical_name_dictionary_v0.85.json # Actors, verbs, entities
└── data_model/                             # Database schemas
    ├── vertical_name_erm_base.sql         # UUID-based schema
    └── vertical_name_erm_extended.sql     # INT-based with extensions
```

## Available Verticals

### 1. AdTech - Advertising Technology
**Path:** `adtech/`
**Examples:** 2
- Campaign management and optimization
- Dynamic marketing cycles
- Audience targeting and personalization

**Key Actors:** MediaBuyer, AdServer, DataAnalyst, CreativeDirector
**Compliance:** GDPR, CCPA, IAB Standards

[📖 Full Documentation](adtech/README.md)

---

### 2. Banking - Financial Services
**Path:** `banking/`
**Examples:** 3
- Mortgage loan processing
- Payment screening (OFAC, sanctions)
- Anti-Financial Crime (AFC) and SAR filing

**Key Actors:** Borrower, Underwriter, Lender, ComplianceOfficer, FraudAnalyst
**Compliance:** BSA/AML, OFAC, Fair Lending, GLBA

[📖 Full Documentation](banking/README.md)

---

### 3. Healthcare - Healthcare & Pharmaceuticals
**Path:** `healthcare/`
**Examples:** 2
- Patient intake and registration
- Clinical trial participant enrollment

**Key Actors:** Patient, Nurse, Physician, Investigator, ClinicalCoordinator
**Compliance:** HIPAA, GDPR, GCP, FDA 21 CFR Part 11

[📖 Full Documentation](healthcare/README.md)

---

### 4. Insurance - Insurance & Risk Management
**Path:** `insurance/`
**Examples:** 2
- Claims lifecycle management
- Subrogation recovery processes

**Key Actors:** Policyholder, ClaimsAdjuster, Underwriter, PaymentClerk
**Compliance:** State Regulations, Solvency II, IFRS 17

[📖 Full Documentation](insurance/README.md)

---

### 5. KYC/Compliance - Know Your Customer & Governance
**Path:** `kyc_compliance/`
**Examples:** 3
- KYC customer onboarding
- Segregation of Duties (SoD) controls
- Validation demonstrations

**Key Actors:** Customer, Registrar, KYCAnalyst, ComplianceOfficer, Auditor
**Compliance:** FATF, BSA/AML, GDPR, KYC Standards

[📖 Full Documentation](kyc_compliance/README.md)

---

### 6. Retail - Retail & E-Commerce
**Path:** `retail/`
**Examples:** 2
- Order fulfillment workflows
- Inventory replenishment automation

**Key Actors:** Customer, InventoryManager, Picker, Packer, ShippingClerk
**Compliance:** PCI-DSS, Consumer Protection, GDPR

[📖 Full Documentation](retail/README.md)

---

### 7. Logistics - Logistics & Supply Chain
**Path:** `logistics/`
**Examples:** 1
- Shipment tracking and visibility

**Key Actors:** Dispatcher, Driver, WarehouseManager, Receiver, Coordinator
**Compliance:** CTPAT, ISO 28000, IATA

[📖 Full Documentation](logistics/README.md)

---

### 8. IT Infrastructure - IT Operations
**Path:** `it_infrastructure/`
**Examples:** 2
- Application lifecycle management
- System topology and SLA tracking

**Key Actors:** SysAdmin, Architect, Engineer, DevOps, SecurityTeam
**Compliance:** SOC 2, ISO 27001, ITIL, CIS Controls

[📖 Full Documentation](it_infrastructure/README.md)

---

## Quick Start

### 1. Choose Your Vertical
```bash
cd verticals/banking  # or adtech, healthcare, etc.
```

### 2. Explore Examples
```bash
ls examples/
cat examples/*.ebl
```

### 3. Validate Against Vertical Dictionary
```bash
python ../../ebl_validator.py \
  dictionary/banking_dictionary_v0.85.json \
  examples/MortgageLoanApplication.ebl
```

### 4. Deploy Vertical Data Model
```bash
# PostgreSQL
psql -d mydb -f data_model/banking_erm_base.sql

# MySQL
mysql mydb < data_model/banking_erm_extended.sql
```

## Cross-Vertical Usage

### Combining Multiple Verticals

Some use cases span multiple verticals:

**Example: E-Commerce Platform**
- `retail/` - Product catalog and orders
- `logistics/` - Shipping and tracking
- `kyc_compliance/` - Customer verification
- `banking/` - Payment processing

**Approach:**
1. Use multiple vertical dictionaries
2. Merge data models where needed
3. Validate with combined dictionary:

```bash
# Create combined dictionary
python merge_dictionaries.py \
  verticals/retail/dictionary/*.json \
  verticals/logistics/dictionary/*.json \
  verticals/banking/dictionary/*.json \
  --output combined_ecommerce_dict.json

# Validate cross-vertical workflow
python ebl_validator.py \
  combined_ecommerce_dict.json \
  my_ecommerce_workflow.ebl
```

## Vertical Statistics

| Vertical | Examples | Actors | Verbs | Data Tables |
|----------|----------|--------|-------|-------------|
| AdTech | 2 | 5 | 15+ | 8+ |
| Banking | 3 | 7 | 12+ | 10+ |
| Healthcare | 2 | 5 | 10+ | 7+ |
| Insurance | 2 | 5 | 12+ | 8+ |
| KYC/Compliance | 3 | 6 | 10+ | 9+ |
| Retail | 2 | 5 | 10+ | 6+ |
| Logistics | 1 | 5 | 8+ | 5+ |
| IT Infrastructure | 2 | 5 | 8+ | 6+ |
| **Total** | **17** | **43+** | **85+** | **59+** |

## Contributing New Verticals

Want to add a new vertical? Follow these steps:

### 1. Create Directory Structure
```bash
mkdir -p verticals/my_vertical/{examples,dictionary,data_model}
```

### 2. Create Dictionary
```json
{
  "version": "0.85",
  "name": "My Vertical Business Lexicon (EBL)",
  "vertical": "my_vertical",
  "core": { /* shared core from base dictionary */ },
  "domain": {
    "entities": [...],
    "actors": [...],
    "verbs": [...],
    "actorVerbs": {...}
  }
}
```

### 3. Add Examples
- Create `.ebl` files following EBL syntax
- Include DataObjects, Entities, Processes, Rules
- Add `erMap` attributes for traceability

### 4. Define Data Model
- Extend base ERM with vertical-specific tables
- Include vertical-specific indexes and constraints
- Document schema in README

### 5. Write Documentation
- Copy template from existing vertical README
- Document actors, verbs, use cases
- Include validation examples
- List compliance requirements

### 6. Submit Pull Request
See [CONTRIBUTING.md](../../CONTRIBUTING.md)

## Resources

- **[Main Documentation](../README.md)** - Project overview
- **[GETTING_STARTED.md](../../GETTING_STARTED.md)** - Comprehensive tutorial
- **[EBL Classes Reference](../../docs/ebl-classes.md)** - Language constructs
- **[EBL Lexicon](../../docs/ebl-Lexicon.md)** - Vocabulary specification

---

**Version:** 0.85
**Total Verticals:** 8
**Total Examples:** 17
**Last Updated:** 05-11-2025
**Maintainer:** Praxibility Team