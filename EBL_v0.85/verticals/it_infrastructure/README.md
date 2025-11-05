# IT Infrastructure & Cloud Ops Vertical (EBL v0.85)

## Overview

Comprehensive DSL for Cloud, DevOps, SRE, Kubernetes, CI/CD, ITSM.

## Structure

```
it_infrastructure/
├── dictionary/           # Domain-specific dictionary
├── grammar/             # ANTLR grammar with it_infrastructure keywords
├── validators/python/   # Python validators
├── validators/java/     # Java validators
├── tests/python/        # Python test suite
└── tests/java/          # Java test suite
```

## Validators

### Dictionary Validator
Validates EBL files against it_infrastructure dictionary constraints.

**Usage:**
```bash
python validators/python/dictionary_validator.py <ebl_file> dictionary/it_infrastructure_dictionary_v0.85.json
```

### Semantic Validator
Validates business logic and compliance (SLO Compliance, Security Controls, Change Management, Incident Response).

**Usage:**
```bash
python validators/python/semantic_validator.py <ebl_file> dictionary/it_infrastructure_dictionary_v0.85.json
```

## Domain Keywords

KUBERNETES, SRE, SLO, CI_CD, PROMETHEUS

## Testing

```bash
cd tests/python && python test_it_infrastructure_validator.py
```
