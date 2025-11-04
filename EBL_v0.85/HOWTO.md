# EBL Toolchain v0.85 — HOWTO

**Initial Open Source Release** - This version includes all core features, validators, and domain dictionaries.

## Features
- **Multi-domain support:** AdTech, Healthcare, Insurance, Finance/Payments, KYC, Logistics, Retail, IT/Infrastructure
- **Comprehensive validation:** Action checks, relationship validation, permission inference
- **Extensible dictionaries:** JSON/YAML format with actor/verb whitelists and data permissions
- **Example-driven:** 15+ real-world EBL files demonstrating various domain patterns

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
java -cp target/classes:generated-src/java org.example.ebl.EBLSemanticValidator adTech_Dictionary_v0.85.json examples/Insurance_Subrogation_Counterparty.ebl
java -cp target/classes:generated-src/java org.example.ebl.EBLSemanticValidator adTech_Dictionary_v0.85.json examples/KYC_Verb_NeverPermitted.ebl
```

### Validate EBL Files (Python)
```bash
# Run validation (replace <DICTIONARY> and <EBL_FILE> with actual files)
PYTHONPATH=generated-src/python python3 ebl_validator.py <DICTIONARY>.json <EBL_FILE>.ebl

# Examples:
PYTHONPATH=generated-src/python python3 ebl_validator.py adTech_Dictionary_v0.85.json examples/AdTech_Dynamic_Marketing_Cycle_Full.ebl
PYTHONPATH=generated-src/python python3 ebl_validator.py adTech_Dictionary_v0.85.json examples/KYC_Onboarding.ebl
```

## Available Domain Dictionaries
- `adTech_Dictionary_v0.85.json` - Advertising Technology
- `healthcare_Dictionary_v0.85.json` - Healthcare & Pharmaceuticals
- `insurance_Dictionary_v0.85.json` - Insurance & Risk Management
- `payments_Dictionary_v0.85.json` - Payments & Financial Services
- `kyc_Dictionary_v0.85.json` - Know Your Customer & Compliance
- `logistics_Dictionary_v0.85.json` - Logistics & Supply Chain
- `retail_Dictionary_v0.85.json` - Retail & E-commerce
- `it_Dictionary_v0.85.json` - IT Infrastructure & Operations
