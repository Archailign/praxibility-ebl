# EBL Toolchain v0.85 — HOWTO

**Initial Open Source Release** - This version includes all core features, validators, and domain dictionaries.

## Generate Parsers
curl -LO https://www.antlr.org/download/antlr-4.13.1-complete.jar
java -jar antlr-4.13.1-complete.jar -Dlanguage=Java -visitor -listener -o generated-src/java src/main/antlr4/EBL.g4
java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 -visitor -listener -o generated-src/python src/main/antlr4/EBL.g4

## Validate (Java)
mvn -q -DskipTests package
java -cp target/classes:generated-src/java org.example.ebl.EBLSemanticValidator adTech_Dictionary_v0.85.json examples/Insurance_Subrogation_Counterparty.ebl

## Validate (Python)
python3 -m pip install -q antlr4-python3-runtime pytest
PYTHONPATH=generated-src/python python3 ebl_validator.py adTech_Dictionary_v0.85.json examples/KYC_Verb_NeverPermitted.ebl

## Features
- **Multi-domain support:** AdTech, Healthcare, Insurance, Finance/Payments, KYC, Logistics, Retail, IT/Infrastructure
- **Comprehensive validation:** Action checks, relationship validation, permission inference
- **Extensible dictionaries:** JSON/YAML format with actor/verb whitelists and data permissions
- **Example-driven:** 15+ real-world EBL files demonstrating various domain patterns

## Tests
mvn -q test
./gradlew test
PYTHONPATH=generated-src/python pytest -q


# Generate Java & Python parsers (choose Maven or Gradle; both work)

## Maven
mvn -q -DskipTests=false test

## Gradle
./gradlew -q test

# Python validator run (after generating Python targets with ANTLR, if you want):
# (You can also reuse Java tests above.)
pip install antlr4-python3-runtime pytest
# Generate Python targets:
java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 -visitor -listener -o generated-src/python src/main/antlr4/EBL.g4
PYTHONPATH=generated-src/python pytest -q

# Manual validation example:
PYTHONPATH=generated-src/python python3 ebl_validator.py adTech_Dictionary_v0.85.json examples/AdTech_Dynamic_Marketing_Cycle_Full.ebl
