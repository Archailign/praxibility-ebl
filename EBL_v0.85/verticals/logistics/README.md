# Logistics & Supply Chain Vertical - Archailign Business Engineering EBL v0.85

## Overview

The **logistics** vertical provides EBL definitions for logistics & supply chain. This vertical includes validated examples, domain-specific dictionaries, and data models for implementing logistics & supply chain workflows.

## Directory Structure

```
logistics/
├── README.md                        # This file
├── examples/                        # Logistics & Supply Chain EBL examples
│   ├── Logistics_Tracking.ebl                   # Shipment tracking workflow
├── dictionary/                      # Domain vocabulary
│   └── logistics_dictionary_v0.85.json
└── data_model/                      # Database schemas
    ├── logistics_erm_base.sql
    └── logistics_erm_extended.sql
```

## Domain Dictionary

### Actors
Dispatcher, Driver, WarehouseManager, Receiver, Coordinator

### Key Verbs
Dispatch, Transport, Track, Receive, Confirm, Update

## Examples

### 1. Logistics_Tracking.ebl
**Purpose:** Shipment tracking workflow

## Use Cases

- Shipment tracking and visibility
- Warehouse management
- Route optimization
- Delivery confirmation

## Regulatory Compliance

**Key Regulations:** CTPAT, C-TPAT, ISO 28000, IATA regulations

## Validation

```bash
# Validate examples
cd verticals/logistics
for file in examples/*.ebl; do
  python ../../ebl_validator.py \
    dictionary/logistics_dictionary_v0.85.json \
    "$file"
done
```

## Getting Started

1. **Explore Examples**
   ```bash
   cd verticals/logistics/examples
   ls -la
   ```

2. **Review Dictionary**
   ```bash
   cat dictionary/logistics_dictionary_v0.85.json
   ```

3. **Deploy Data Model**
   ```bash
   # For PostgreSQL
   psql -f data_model/logistics_erm_base.sql

   # For MySQL
   mysql < data_model/logistics_erm_extended.sql
   ```

## Resources

- [Logistics & Supply Chain Dictionary](dictionary/logistics_dictionary_v0.85.json)
- [Main Documentation](../../README.md)
- [EBL Language Reference](../../../docs/ebl-classes.md)

---

**Version:** 0.85
**Compliance:** CTPAT, C-TPAT, ISO 28000, IATA regulations
**Last Updated:** 05-11-2025
**Maintainer:** Praxibility Team
