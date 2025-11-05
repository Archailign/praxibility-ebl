# KYC & AML Compliance Vertical (EBL v0.85)

## Overview

Comprehensive DSL for Customer Due Diligence, Sanctions Screening, Transaction Monitoring.

## Structure

```
kyc_compliance/
├── dictionary/           # Domain-specific dictionary
├── grammar/             # ANTLR grammar with kyc_compliance keywords
├── validators/python/   # Python validators
├── validators/java/     # Java validators
├── tests/python/        # Python test suite
└── tests/java/          # Java test suite
```

## Validators

### Dictionary Validator
Validates EBL files against kyc_compliance dictionary constraints.

**Usage:**
```bash
python validators/python/dictionary_validator.py <ebl_file> dictionary/kyc_compliance_dictionary_v0.85.json
```

### Semantic Validator
Validates business logic and compliance (KYC/AML Rules, Sanctions Screening, PEP Checks, SAR Filing).

**Usage:**
```bash
python validators/python/semantic_validator.py <ebl_file> dictionary/kyc_compliance_dictionary_v0.85.json
```

## Domain Keywords

KYC, AML, PEP, SAR, OFAC, SDN

## Testing

```bash
cd tests/python && python test_kyc_compliance_validator.py
```
