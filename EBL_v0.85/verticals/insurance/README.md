# Insurance & Risk Management Vertical - Archailign Business Engineering EBL v0.85

## Overview

The **insurance** vertical provides EBL definitions for insurance & risk management. This vertical includes validated examples, domain-specific dictionaries, and data models for implementing insurance & risk management workflows.

## Directory Structure

```
insurance/
├── README.md                        # This file
├── examples/                        # Insurance & Risk Management EBL examples
│   ├── Insurance_ClaimLifecycle.ebl             # End-to-end claims processing
│   ├── Insurance_Subrogation_Counterparty.ebl   # Subrogation recovery workflow
├── dictionary/                      # Domain vocabulary
│   └── insurance_dictionary_v0.85.json
└── data_model/                      # Database schemas
    ├── insurance_erm_base.sql
    └── insurance_erm_extended.sql
```

## Domain Dictionary

### Actors
Policyholder, ClaimsAdjuster, Underwriter, PaymentClerk, Investigator

### Key Verbs
File, Assess, Approve, Reject, Disburse, Investigate, Recover

## Examples

### 1. Insurance_ClaimLifecycle.ebl
**Purpose:** End-to-end claims processing

### 2. Insurance_Subrogation_Counterparty.ebl
**Purpose:** Subrogation recovery workflow

## Use Cases

- Claims filing and processing
- Policy underwriting and risk assessment
- Subrogation and recovery processes
- Fraud detection and investigation

## Regulatory Compliance

**Key Regulations:** State Insurance Regulations, Solvency II, IFRS 17

## Validation

```bash
# Validate examples
cd verticals/insurance
for file in examples/*.ebl; do
  python ../../ebl_validator.py \
    dictionary/insurance_dictionary_v0.85.json \
    "$file"
done
```

## Getting Started

1. **Explore Examples**
   ```bash
   cd verticals/insurance/examples
   ls -la
   ```

2. **Review Dictionary**
   ```bash
   cat dictionary/insurance_dictionary_v0.85.json
   ```

3. **Deploy Data Model**
   ```bash
   # For PostgreSQL
   psql -f data_model/insurance_erm_base.sql

   # For MySQL
   mysql < data_model/insurance_erm_extended.sql
   ```

## Resources

- [Insurance & Risk Management Dictionary](dictionary/insurance_dictionary_v0.85.json)
- [Main Documentation](../../README.md)
- [EBL Language Reference](../../../docs/ebl-classes.md)

---

**Version:** 0.85
**Compliance:** State Insurance Regulations, Solvency II, IFRS 17
**Last Updated:** 05-11-2025
**Maintainer:** Praxibility Team
