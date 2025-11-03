# EBL Toolchain v1.3.0 — HOWTO (Backward-compatible with 1.2.x)

**Compatibility:** Grammar unchanged from v1.2.9 → v1.3.0. All new checks are *non-breaking* warnings except:
- Existing errors retained (missing dataRef, DO without Policies/Resources, enum default ∉ values, min>max).

## Generate Parsers
curl -LO https://www.antlr.org/download/antlr-4.13.1-complete.jar
java -jar antlr-4.13.1-complete.jar -Dlanguage=Java -visitor -listener -o generated-src/java src/main/antlr4/EBL.g4
java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 -visitor -listener -o generated-src/python src/main/antlr4/EBL.g4

## Validate (Java)
mvn -q -DskipTests package
java -cp target/classes:generated-src/java org.example.ebl.EBLSemanticValidator EBL_Dictionary_v1.3.0.json examples/Insurance_Subrogation_Counterparty.ebl

## Validate (Python)
python3 -m pip install -q antlr4-python3-runtime pytest
PYTHONPATH=generated-src/python python3 ebl_validator.py EBL_Dictionary_v1.3.0.json examples/KYC_Verb_NeverPermitted.ebl

## What’s new for authors
- **KYC doc types:** `EU_EIDAS`, `AU`, `NZ`, `AE`, `SA`, `QA`, `KW` added to `docTypesByJurisdiction`.
- **Insurance subrogation:** new example **Subrogation vs ThirdParty** using `subrogates_against` relationship.
- **Lint:** warnings for **unused actors** in a process and **verbs never permitted** by any actor in domain whitelist.

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
PYTHONPATH=generated-src/python python3 ebl_validator.py EBL_Dictionary_v1.3.1.json examples/AdTech_Dynamic_Marketing_Cycle_Full.ebl
