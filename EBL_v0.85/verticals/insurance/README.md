# Insurance (P&C, Life, Health) Vertical (EBL v0.85)

## Overview

Comprehensive DSL for Underwriting, Claims, Actuarial, Reinsurance, Fraud.

## Structure

```
insurance/
├── dictionary/           # Domain-specific dictionary
├── grammar/             # ANTLR grammar with insurance keywords
├── validators/python/   # Python validators
├── validators/java/     # Java validators
├── tests/python/        # Python test suite
└── tests/java/          # Java test suite
```

## Validators

### Dictionary Validator
Validates EBL files against insurance dictionary constraints.

**Usage:**
```bash
python validators/python/dictionary_validator.py <ebl_file> dictionary/insurance_dictionary_v0.85.json
```

### Semantic Validator
Validates business logic and compliance (NAIC Compliance, Claims Validation, Fraud Detection, Reserve Requirements).

**Usage:**
```bash
python validators/python/semantic_validator.py <ebl_file> dictionary/insurance_dictionary_v0.85.json
```

## Domain Keywords

FNOL, ACORD, IBNR, SUBROGATION

## Testing

```bash
cd tests/python && python test_insurance_validator.py
```
