# AdTech & Digital Advertising Vertical (EBL v0.85)

## Overview

Comprehensive DSL for Programmatic, RTB, DSP/SSP/DMP, Attribution, Privacy.

## Structure

```
adtech/
├── dictionary/           # Domain-specific dictionary
├── grammar/             # ANTLR grammar with adtech keywords
├── validators/python/   # Python validators
├── validators/java/     # Java validators
├── tests/python/        # Python test suite
└── tests/java/          # Java test suite
```

## Validators

### Dictionary Validator
Validates EBL files against adtech dictionary constraints.

**Usage:**
```bash
python validators/python/dictionary_validator.py <ebl_file> dictionary/adtech_dictionary_v0.85.json
```

### Semantic Validator
Validates business logic and compliance (GDPR Consent, Privacy Compliance, Viewability Standards, Fraud Detection).

**Usage:**
```bash
python validators/python/semantic_validator.py <ebl_file> dictionary/adtech_dictionary_v0.85.json
```

## Domain Keywords

RTB, DSP, CPM, VIEWABILITY, ATTRIBUTION

## Testing

```bash
cd tests/python && python test_adtech_validator.py
```
