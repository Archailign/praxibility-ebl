# Retail & E-Commerce Vertical (EBL v0.85)

## Overview

Comprehensive DSL for Omnichannel, POS, Inventory, Merchandising, Loyalty.

## Structure

```
retail/
├── dictionary/           # Domain-specific dictionary
├── grammar/             # ANTLR grammar with retail keywords
├── validators/python/   # Python validators
├── validators/java/     # Java validators
├── tests/python/        # Python test suite
└── tests/java/          # Java test suite
```

## Validators

### Dictionary Validator
Validates EBL files against retail dictionary constraints.

**Usage:**
```bash
python validators/python/dictionary_validator.py <ebl_file> dictionary/retail_dictionary_v0.85.json
```

### Semantic Validator
Validates business logic and compliance (PCI Compliance, Inventory Management, Pricing Rules, Omnichannel Logic).

**Usage:**
```bash
python validators/python/semantic_validator.py <ebl_file> dictionary/retail_dictionary_v0.85.json
```

## Domain Keywords

SKU, UPC, BOPIS, POS, OMNICHANNEL

## Testing

```bash
cd tests/python && python test_retail_validator.py
```
