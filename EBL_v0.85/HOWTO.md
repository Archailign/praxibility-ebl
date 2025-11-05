# EBL Toolchain v0.85 — HOWTO

**Initial Open Source Release** - This version includes all core features, validators, and domain dictionaries.

## Features
- **Multi-domain support:** 8 industry verticals (AdTech, Healthcare, Insurance, Banking, KYC, Logistics, Retail, IT)
- **Self-contained verticals:** Each vertical has its own dictionary, grammar, validators, and tests
- **Dual-language validators:** Python and Java implementations for dictionary and semantic validation
- **ANTLR grammars:** Vertical-specific DSL grammars with domain keywords
- **Comprehensive validation:** Action checks, relationship validation, permission inference, compliance rules
- **Extensible dictionaries:** JSON format with actor/verb whitelists and data permissions
- **Example-driven:** 17 real-world EBL files organized by vertical

## Quick Start

### 1. Download ANTLR
```bash
curl -LO https://www.antlr.org/download/antlr-4.13.1-complete.jar
```

### 2. Generate Parsers

**Automated Parser Generation (Recommended):**
```bash
# Generate parsers for all verticals using utility script
cd EBL_v0.85
./utilities/generate_vertical_parsers.sh
```

This script:
- Downloads ANTLR 4.13.1 JAR if not present
- Generates Python parsers for all 8 verticals
- Generates Java parsers for all 8 verticals
- Places parsers in `verticals/[vertical]/generated/python/` and `generated/java/`

Each vertical has its own grammar file with domain-specific keywords and types:
- `verticals/banking/grammar/Banking_v0_85.g4`
- `verticals/healthcare/grammar/Healthcare_v0_85.g4`
- `verticals/it_infrastructure/grammar/IT_Infrastructure_v0_85.g4`
- etc.

**Manual Parser Generation (Optional):**
```bash
# Generate parsers for a specific vertical manually
java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 -visitor -listener \
  -o verticals/banking/generated/python \
  verticals/banking/grammar/Banking_v0_85.g4

java -jar antlr-4.13.1-complete.jar -Dlanguage=Java -visitor -listener \
  -o verticals/banking/generated/java \
  -package com.archailign.ebl.banking \
  verticals/banking/grammar/Banking_v0_85.g4
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

Each vertical has its own test suite. Tests are located in `verticals/[vertical]/tests/`.

### Vertical-Specific Tests

**Python Tests:**
```bash
# Run tests for a specific vertical
cd verticals/banking/tests/python
python test_banking_validator.py

# Or use pytest
cd verticals/banking
pytest tests/python/test_banking_validator.py -v

# Run all tests for all verticals
for vertical in banking healthcare retail insurance kyc_compliance adtech logistics it_infrastructure; do
  echo "Testing $vertical..."
  cd verticals/$vertical/tests/python && python test_${vertical}_validator.py
done
```

**Java Tests:**
```bash
# Compile and run tests for a specific vertical
cd verticals/banking/tests/java
javac -cp .:../../validators/java BankingValidatorTest.java
java BankingValidatorTest

# Run all vertical tests
for vertical in banking healthcare retail insurance kyc_compliance adtech logistics it_infrastructure; do
  echo "Testing $vertical..."
  cd verticals/$vertical/tests/java && java ${vertical^}ValidatorTest
done
```

### Legacy Tests (Maven/Gradle)

**Using Maven:**
```bash
mvn -q test
```

**Using Gradle:**
```bash
./gradlew -q test
```

## Validation

Each vertical has its own validators in `verticals/[vertical]/validators/`.

### Vertical-Specific Validators

**Python Dictionary Validation:**
```bash
# Validate against vertical dictionary (checks actors, verbs, entities)
cd verticals/banking
python validators/python/dictionary_validator.py \
  examples/MortgageLoanApplication.ebl \
  dictionary/banking_dictionary_v0.85.json

# Healthcare example
cd verticals/healthcare
python validators/python/dictionary_validator.py \
  examples/PatientIntake.ebl \
  dictionary/healthcare_dictionary_v0.85.json
```

**Python Semantic Validation:**
```bash
# Validate business logic and compliance rules
cd verticals/banking
python validators/python/semantic_validator.py \
  examples/Payments_Screening.ebl \
  dictionary/banking_dictionary_v0.85.json

# Validates PCI-DSS, SOX, Wire transfer rules, AML, etc.
```

**Java Dictionary Validation:**
```bash
# Compile and run Java validator
cd verticals/banking
javac validators/java/BankingDictionaryValidator.java
java validators.java.BankingDictionaryValidator \
  examples/MortgageLoanApplication.ebl \
  dictionary/banking_dictionary_v0.85.json
```

## Available Verticals

Each vertical is self-contained with dictionary, grammar, validators, tests, and examples:

### Banking - Banking & Financial Services
- **Dictionary:** `verticals/banking/dictionary/banking_dictionary_v0.85.json`
- **Grammar:** `verticals/banking/grammar/Banking_v0_85.g4`
- **Validators:** `verticals/banking/validators/python/` and `validators/java/`
- **Tests:** `verticals/banking/tests/python/` and `tests/java/`
- **Examples:** MortgageLoanApplication.ebl, Payments_Screening.ebl, AFC_SAR_Filing.ebl

### Healthcare - Healthcare & Pharmaceuticals
- **Dictionary:** `verticals/healthcare/dictionary/healthcare_dictionary_v0.85.json`
- **Grammar:** `verticals/healthcare/grammar/Healthcare_v0_85.g4`
- **Validators:** `verticals/healthcare/validators/python/` and `validators/java/`
- **Tests:** `verticals/healthcare/tests/python/` and `tests/java/`
- **Examples:** PatientIntake.ebl, ClinicalTrialEnrollment.ebl

### Insurance - Insurance & Risk Management
- **Dictionary:** `verticals/insurance/dictionary/insurance_dictionary_v0.85.json`
- **Grammar:** `verticals/insurance/grammar/Insurance_v0_85.g4`
- **Validators:** `verticals/insurance/validators/python/` and `validators/java/`

### Retail - Retail & E-commerce
- **Dictionary:** `verticals/retail/dictionary/retail_dictionary_v0.85.json`
- **Grammar:** `verticals/retail/grammar/Retail_v0_85.g4`
- **Validators:** `verticals/retail/validators/python/` and `validators/java/`

### KYC/Compliance - Know Your Customer & Governance
- **Dictionary:** `verticals/kyc_compliance/dictionary/kyc_compliance_dictionary_v0.85.json`
- **Grammar:** `verticals/kyc_compliance/grammar/KYC_Compliance_v0_85.g4`
- **Validators:** `verticals/kyc_compliance/validators/python/` and `validators/java/`

### AdTech - Advertising Technology
- **Dictionary:** `verticals/adtech/dictionary/adtech_dictionary_v0.85.json`
- **Grammar:** `verticals/adtech/grammar/AdTech_v0_85.g4`
- **Validators:** `verticals/adtech/validators/python/` and `validators/java/`

### Logistics - Logistics & Supply Chain
- **Dictionary:** `verticals/logistics/dictionary/logistics_dictionary_v0.85.json`
- **Grammar:** `verticals/logistics/grammar/Logistics_v0_85.g4`
- **Validators:** `verticals/logistics/validators/python/` and `validators/java/`

### IT Infrastructure - IT Operations
- **Dictionary:** `verticals/it_infrastructure/dictionary/it_infrastructure_dictionary_v0.85.json`
- **Grammar:** `verticals/it_infrastructure/grammar/IT_Infrastructure_v0_85.g4`
- **Validators:** `verticals/it_infrastructure/validators/python/` and `validators/java/`

---

## Project Architecture

- **Vertical Independence**: Each vertical has its own complete dictionary, grammar, validators, and tests
- **ANTLR-Based Parsing**: All validation uses ANTLR-generated parsers from vertical-specific grammars
- **No Central Dependencies**: Verticals operate independently without shared centralized files
- **Core Grammar**: `src/main/antlr4/EBL.g4` (reference only, not used for validation)
