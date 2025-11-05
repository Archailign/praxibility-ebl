# EBL Toolchain v0.85 — HOWTO

**Initial Open Source Release** - This version includes all core features, validators, and domain dictionaries.

## Features
- **Multi-domain support:** 8 industry verticals (AdTech, Healthcare, Insurance, Banking, KYC, Logistics, Retail, IT)
- **Comprehensive validation:** Action checks, relationship validation, permission inference
- **Extensible dictionaries:** JSON/YAML format with actor/verb whitelists and data permissions
- **Example-driven:** 17 real-world EBL files organized by vertical
- **Vertical structure:** Each industry has isolated examples, dictionaries, and data models

## Quick Start

### 1. Download ANTLR
```bash
curl -LO https://www.antlr.org/download/antlr-4.13.1-complete.jar
```

### 2. Generate Parsers
```bash
# Generate Java parser
java -jar antlr-4.13.1-complete.jar -Dlanguage=Java -visitor -listener -o generated-src/java src/main/antlr4/EBL.g4

# Generate Python parser
java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 -visitor -listener -o generated-src/python src/main/antlr4/EBL.g4
```

### 3. Install Dependencies

**Java (Maven or Gradle)**
```bash
# Maven builds automatically install dependencies
mvn -q -DskipTests package

# Or use Gradle
./gradlew build
```

**Python**
```bash
pip install antlr4-python3-runtime pytest
```

## Running Tests

### Java Tests

**Using Maven:**
```bash
mvn -q test
```

**Using Gradle:**
```bash
./gradlew -q test
```

### Python Tests
```bash
PYTHONPATH=generated-src/python pytest -q
```

## Validation

### Validate EBL Files (Java)
```bash
# Build the validator first
mvn -q -DskipTests package

# Run validation (replace <DICTIONARY> and <EBL_FILE> with actual files)
java -cp target/classes:generated-src/java org.example.ebl.EBLSemanticValidator <DICTIONARY>.json <EBL_FILE>.ebl

# Examples:
java -cp target/classes:generated-src/java org.example.ebl.EBLSemanticValidator \
  verticals/insurance/dictionary/insurance_dictionary_v0.85.json \
  verticals/insurance/examples/Insurance_Subrogation_Counterparty.ebl

java -cp target/classes:generated-src/java org.example.ebl.EBLSemanticValidator \
  verticals/kyc_compliance/dictionary/kyc_compliance_dictionary_v0.85.json \
  verticals/kyc_compliance/examples/KYC_Verb_NeverPermitted.ebl
```

### Validate EBL Files (Python)
```bash
# Run validation (replace <DICTIONARY> and <EBL_FILE> with actual files)
PYTHONPATH=generated-src/python python3 ebl_validator.py <DICTIONARY>.json <EBL_FILE>.ebl

# Examples:
PYTHONPATH=generated-src/python python3 ebl_validator.py \
  verticals/adtech/dictionary/adtech_dictionary_v0.85.json \
  verticals/adtech/examples/AdTech_Dynamic_Marketing_Cycle_Full.ebl

PYTHONPATH=generated-src/python python3 ebl_validator.py \
  verticals/kyc_compliance/dictionary/kyc_compliance_dictionary_v0.85.json \
  verticals/kyc_compliance/examples/KYC_Onboarding.ebl
```

## Available Vertical Dictionaries

Each vertical includes its own dictionary in `verticals/[vertical]/dictionary/`:

- `verticals/adtech/dictionary/adtech_dictionary_v0.85.json` - Advertising Technology
- `verticals/healthcare/dictionary/healthcare_dictionary_v0.85.json` - Healthcare & Pharmaceuticals
- `verticals/insurance/dictionary/insurance_dictionary_v0.85.json` - Insurance & Risk Management
- `verticals/banking/dictionary/banking_dictionary_v0.85.json` - Banking & Financial Services
- `verticals/kyc_compliance/dictionary/kyc_compliance_dictionary_v0.85.json` - Know Your Customer & Compliance
- `verticals/logistics/dictionary/logistics_dictionary_v0.85.json` - Logistics & Supply Chain
- `verticals/retail/dictionary/retail_dictionary_v0.85.json` - Retail & E-commerce
- `verticals/it_infrastructure/dictionary/it_infrastructure_dictionary_v0.85.json` - IT Infrastructure & Operations

**Master Dictionary:** `EBL_Dictionary_v0.85_all.json` (contains all domains)
