# Healthcare & Life Sciences Vertical (EBL v0.85)

## Overview

Comprehensive DSL for Clinical Care, EHR, Pharmacy, Medical Devices, Clinical Trials.

## Structure

```
healthcare/
├── dictionary/           # Domain-specific dictionary
├── grammar/             # ANTLR grammar with healthcare keywords
├── validators/python/   # Python validators
├── validators/java/     # Java validators
├── tests/python/        # Python test suite
└── tests/java/          # Java test suite
```

## Validators

### Dictionary Validator
Validates EBL files against healthcare dictionary constraints.

**Usage:**
```bash
python validators/python/dictionary_validator.py <ebl_file> dictionary/healthcare_dictionary_v0.85.json
```

### Semantic Validator
Validates business logic and compliance (HIPAA, PHI Protection, FDA Compliance, Clinical Trial Protocols).

**Usage:**
```bash
python validators/python/semantic_validator.py <ebl_file> dictionary/healthcare_dictionary_v0.85.json
```

## Domain Keywords

HIPAA, PHI, HL7, FHIR, DICOM

## Testing

```bash
cd tests/python && python test_healthcare_validator.py
```
