# IT Infrastructure & Operations Vertical - Archailign Business Engineering EBL v0.85

## Overview

The **it_infrastructure** vertical provides EBL definitions for it infrastructure & operations. This vertical includes validated examples, domain-specific dictionaries, and data models for implementing it infrastructure & operations workflows.

## Directory Structure

```
it_infrastructure/
├── README.md                        # This file
├── examples/                        # IT Infrastructure & Operations EBL examples
│   ├── IT_Application_Onboarding.ebl            # Application lifecycle management
│   ├── IT-TopologyRelationships.ebl             # System topology and SLA mapping
├── dictionary/                      # Domain vocabulary
│   └── it_infrastructure_dictionary_v0.85.json
└── data_model/                      # Database schemas
    ├── it_infrastructure_erm_base.sql
    └── it_infrastructure_erm_extended.sql
```

## Domain Dictionary

### Actors
SysAdmin, Architect, Engineer, DevOps, SecurityTeam

### Key Verbs
Deploy, Monitor, Configure, Scale, Backup, Restore

## Examples

### 1. IT_Application_Onboarding.ebl
**Purpose:** Application lifecycle management

### 2. IT-TopologyRelationships.ebl
**Purpose:** System topology and SLA mapping

## Use Cases

- Application onboarding and lifecycle
- Infrastructure provisioning (IaC)
- System topology mapping
- SLA management and monitoring

## Regulatory Compliance

**Key Regulations:** SOC 2, ISO 27001, ITIL, CIS Controls

## Validation

```bash
# Validate examples
cd verticals/it_infrastructure
for file in examples/*.ebl; do
  python ../../ebl_validator.py \
    dictionary/it_infrastructure_dictionary_v0.85.json \
    "$file"
done
```

## Getting Started

1. **Explore Examples**
   ```bash
   cd verticals/it_infrastructure/examples
   ls -la
   ```

2. **Review Dictionary**
   ```bash
   cat dictionary/it_infrastructure_dictionary_v0.85.json
   ```

3. **Deploy Data Model**
   ```bash
   # For PostgreSQL
   psql -f data_model/it_infrastructure_erm_base.sql

   # For MySQL
   mysql < data_model/it_infrastructure_erm_extended.sql
   ```

## Resources

- [IT Infrastructure & Operations Dictionary](dictionary/it_infrastructure_dictionary_v0.85.json)
- [Main Documentation](../../README.md)
- [EBL Language Reference](../../../docs/ebl-classes.md)

---

**Version:** 0.85
**Compliance:** SOC 2, ISO 27001, ITIL, CIS Controls
**Last Updated:** 05-11-2025
**Maintainer:** Praxibility Team
