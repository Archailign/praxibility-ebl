# Logistics & Supply Chain Vertical (EBL v0.85)

## Overview

Comprehensive DSL for Transportation, Warehousing, Freight, Customs, Last-Mile.

## Structure

```
logistics/
├── dictionary/           # Domain-specific dictionary
├── grammar/             # ANTLR grammar with logistics keywords
├── validators/python/   # Python validators
├── validators/java/     # Java validators
├── tests/python/        # Python test suite
└── tests/java/          # Java test suite
```

## Validators

### Dictionary Validator
Validates EBL files against logistics dictionary constraints.

**Usage:**
```bash
python validators/python/dictionary_validator.py <ebl_file> dictionary/logistics_dictionary_v0.85.json
```

### Semantic Validator
Validates business logic and compliance (Customs Compliance, Incoterms Validation, Route Optimization, Hazmat Rules).

**Usage:**
```bash
python validators/python/semantic_validator.py <ebl_file> dictionary/logistics_dictionary_v0.85.json
```

## Domain Keywords

BOL, AWB, INCOTERMS, HAZMAT, WMS

## Testing

```bash
cd tests/python && python test_logistics_validator.py
```
