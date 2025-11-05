# Banking & Payments Vertical (EBL v0.85)

## Overview

Comprehensive DSL for banking and financial services operations.

## Structure

```
banking/
├── dictionary/           # 125 actors, 91 verbs, 110 entities, 165 DataObjects
├── grammar/             # ANTLR grammar with banking keywords
├── validators/python/   # Python validators
├── validators/java/     # Java validators
├── tests/python/        # Python test suite
└── tests/java/          # Java test suite
```

## Validators

### Dictionary Validator
Validates EBL files against banking dictionary constraints.

**Usage:**
```bash
python validators/python/dictionary_validator.py <ebl_file> dictionary/banking_dictionary_v0.85.json
```

### Semantic Validator
Validates business logic and compliance (PCI-DSS, SOX, Basel III, AML).

**Usage:**
```bash
python validators/python/semantic_validator.py <ebl_file> dictionary/banking_dictionary_v0.85.json
```

## Testing

```bash
cd tests/python && python test_banking_validator.py
```
