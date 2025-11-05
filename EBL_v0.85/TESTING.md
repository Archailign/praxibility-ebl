# EBL Testing Strategy v0.85

## Overview

The EBL project employs a dual-language testing approach with both **Java (JUnit)** and **Python (pytest)** tests. Each serves distinct purposes while ensuring comprehensive validation of the EBL grammar, semantic validators, and vertical-specific examples.

---

## Test Organization

```
EBL_v0.85/
├── src/test/java/           # Java unit tests (JUnit 5)
│   └── org/example/ebl/
│       ├── SemanticValidatorTest.java  # Semantic validation tests
│       └── AdTechValidatorTest.java    # AdTech vertical tests
│       └── BankingValidatorTest.java   # Banking vertical tests
│       └── ... (all vertical tests)
│
└── tests/                   # Python integration tests (pytest)
    ├── test_semantic_validation.py     # Semantic validation tests
    └── test_adtech_full.py             # AdTech vertical tests
    └── ... (all vertical tests)
```

---

## Test Types

### 1. Java Tests (`src/test/java/`)

**Purpose:** Unit tests for validator logic and CI/CD pipeline integration

**Technology Stack:**
- JUnit 5
- ANTLR4 Java runtime
- Maven/Gradle integration

**Use Cases:**
- ✅ Continuous Integration (CI/CD) with Maven/Gradle
- ✅ IDE integration (IntelliJ, Eclipse, VS Code)
- ✅ Fine-grained unit testing of validator components
- ✅ Performance testing and benchmarking
- ✅ Java-based toolchain validation

**Example:**
```java
@Test
public void kyc_onboarding_no_errors() throws Exception {
    var v = run(
        "verticals/kyc_compliance/dictionary/kyc_compliance_dictionary_v0.85.json",
        "verticals/kyc_compliance/examples/KYC_Onboarding.ebl"
    );
    assertTrue(v.getErrors().isEmpty(), "Expected no errors: " + v.getErrors());
}
```

**Running Java Tests:**
```bash
# Maven
mvn test

# Gradle
gradle test

# Specific test class
mvn test -Dtest=SemanticValidatorTest

# Specific test method
mvn test -Dtest=AdTechValidatorTest#full_adtech_example_has_no_errors
```

---

### 2. Python Tests (`tests/`)

**Purpose:** Integration tests for end-to-end validation and quick validation scripts

**Technology Stack:**
- pytest
- ANTLR4 Python3 runtime
- Python validator implementation

**Use Cases:**
- ✅ Quick validation during development
- ✅ Scripting and automation
- ✅ Integration with Python toolchains
- ✅ Lightweight CI/CD environments
- ✅ Cross-platform validation

**Example:**
```python
def test_kyc_onboarding_no_errors():
    """Test that KYC onboarding example has no semantic errors."""
    v = _run(
        'verticals/kyc_compliance/dictionary/kyc_compliance_dictionary_v0.85.json',
        'verticals/kyc_compliance/examples/KYC_Onboarding.ebl'
    )
    assert not v.errors, f"Expected no errors, got: {v.errors}"
```

**Running Python Tests:**
```bash
# All tests
cd EBL_v0.85
PYTHONPATH=generated-src/python pytest -v

# Specific test file
PYTHONPATH=generated-src/python pytest tests/test_semantic_validation.py -v

# Specific test function
PYTHONPATH=generated-src/python pytest tests/test_semantic_validation.py::test_kyc_onboarding_no_errors -v

# With coverage
PYTHONPATH=generated-src/python pytest --cov=ebl_validator --cov-report=html
```

---

## Test Categories

### A. Semantic Validation Tests

**Files:**
- `src/test/java/org/example/ebl/SemanticValidatorTest.java`
- `tests/test_semantic_validation.py`

**Purpose:** Test semantic validation rules across verticals

**Coverage:**
1. **Unused Actor Warnings**
   - Validates that declared but unused actors generate warnings
   - Example: `Insurance_Subrogation_Counterparty.ebl`

2. **Never Permitted Verb Warnings**
   - Validates that verbs with no actor permissions generate warnings
   - Example: `KYC_Verb_NeverPermitted.ebl`

3. **Cross-Vertical Validation**
   - Tests examples from multiple verticals (KYC, Insurance)
   - Ensures dictionary isolation between verticals

4. **No-Error Validations**
   - Ensures valid examples pass without errors
   - Examples: `KYC_Onboarding.ebl`, `Insurance_ClaimLifecycle.ebl`

**Test Cases:**
| Test | Vertical | Expected Outcome |
|------|----------|------------------|
| `test_unused_actor_warning()` | Insurance | Warning about unused actor |
| `test_never_permitted_warning()` | KYC | Warning about invalid verb |
| `test_kyc_onboarding_no_errors()` | KYC | No errors or warnings |
| `test_insurance_claim_lifecycle_no_errors()` | Insurance | No errors |

---

### B. Vertical-Specific Tests

**Files:**
- `src/test/java/org/example/ebl/AdTechValidatorTest.java`
- `tests/test_adtech_full.py`

**Purpose:** Test domain-specific examples against vertical dictionaries

**Coverage:**
1. **AdTech Vertical**
   - Campaign management workflows
   - Dynamic marketing cycles
   - GDPR/CCPA compliance

**Test Cases:**
| Test | File | Purpose |
|------|------|---------|
| `test_full_adtech_compiles()` | `AdTech_Dynamic_Marketing_Cycle_Full.ebl` | Event-driven campaign optimization |
| `test_adtech_campaign_management()` | `AdCampaignManagement.ebl` | Campaign lifecycle management |

**Expandable to Other Verticals:**
```java
// Example for Banking vertical
@Test
public void mortgage_loan_application_no_errors() throws Exception {
    var v = run(
        "verticals/banking/dictionary/banking_dictionary_v0.85.json",
        "verticals/banking/examples/MortgageLoanApplication.ebl"
    );
    assertTrue(v.getErrors().isEmpty());
}
```

---

## When to Use Each Test Framework

### Use Java Tests When:
- ✅ Integrating with Maven/Gradle build pipelines
- ✅ Running in CI/CD (GitHub Actions, Jenkins)
- ✅ Testing validator implementation details
- ✅ Performance benchmarking required
- ✅ IDE integration needed (IntelliJ, Eclipse)

### Use Python Tests When:
- ✅ Quick validation during development
- ✅ Scripting automated workflows
- ✅ Lightweight CI/CD environments
- ✅ Testing with Python-based tooling
- ✅ Rapid prototyping of new tests

### Use Both When:
- ✅ Ensuring cross-platform compatibility
- ✅ Comprehensive validation coverage
- ✅ Supporting diverse development environments

---

## Adding New Tests

### Adding a Java Test

1. **Create or update test class** in `src/test/java/org/example/ebl/`

2. **Follow naming convention:**
   ```java
   // Vertical-specific: [Vertical]ValidatorTest.java
   // Feature-specific: [Feature]ValidatorTest.java
   ```

3. **Template:**
   ```java
   @Test
   public void [vertical]_[example]_no_errors() throws Exception {
       var v = run(
           "verticals/[vertical]/dictionary/[vertical]_dictionary_v0.85.json",
           "verticals/[vertical]/examples/[Example].ebl"
       );
       assertTrue(v.getErrors().isEmpty(), "Expected no errors: " + v.getErrors());
   }
   ```

4. **Run:**
   ```bash
   mvn test -Dtest=[YourTest]
   ```

### Adding a Python Test

1. **Create or update test file** in `tests/`

2. **Follow naming convention:**
   ```python
   # test_[vertical]_[feature].py
   # test_[feature].py
   ```

3. **Template:**
   ```python
   def test_[vertical]_[example]_no_errors():
       """Test that [description]."""
       v = _run(
           'verticals/[vertical]/dictionary/[vertical]_dictionary_v0.85.json',
           'verticals/[vertical]/examples/[Example].ebl'
       )
       assert not v.errors, f"Expected no errors, got: {v.errors}"
   ```

4. **Run:**
   ```bash
   PYTHONPATH=generated-src/python pytest tests/test_[your_test].py -v
   ```

---

## Test Coverage Goals

### Current Coverage (v0.85)

| Vertical | Examples | Java Tests | Python Tests | Test Files |
|----------|----------|------------|--------------|------------|
| AdTech | 2 | ✅ 2 | ✅ 2 | `AdTechValidatorTest.java`, `test_adtech_full.py` |
| Banking | 3 | ✅ 3 | ✅ 3 | `BankingValidatorTest.java`, `test_banking.py` |
| Healthcare | 2 | ✅ 2 | ✅ 2 | `HealthcareValidatorTest.java`, `test_healthcare.py` |
| Insurance | 2 | ✅ 1 | ✅ 1 | `SemanticValidatorTest.java`, `test_semantic_validation.py` |
| KYC/Compliance | 3 | ✅ 2 | ✅ 2 | `SemanticValidatorTest.java`, `test_semantic_validation.py` |
| Retail | 2 | ✅ 2 | ✅ 2 | `RetailValidatorTest.java`, `test_retail.py` |
| Logistics | 1 | ✅ 1 | ✅ 1 | `LogisticsValidatorTest.java`, `test_logistics.py` |
| IT Infrastructure | 2 | ✅ 2 | ✅ 2 | `ITInfrastructureValidatorTest.java`, `test_it_infrastructure.py` |
| **Total** | **17** | **✅ 15/17** | **✅ 15/17** | **88% Coverage** |

**Status:** 🎉 **Near-complete coverage achieved!** 15 out of 17 examples now have comprehensive tests.

### Target Coverage (v1.0)

- ✅ **100% vertical coverage** - At least 1 test per vertical
- ✅ **80% example coverage** - At least 80% of examples tested
- ✅ **All semantic features** - Comprehensive validator testing
- ✅ **Cross-vertical tests** - Test interactions between verticals

---

## Continuous Integration

### GitHub Actions Workflow

```yaml
name: EBL Tests
on: [push, pull_request]

jobs:
  java-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: '11'
      - name: Build and Test
        run: |
          cd EBL_v0.85
          mvn clean test

  python-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.8'
      - name: Install Dependencies
        run: |
          pip install antlr4-python3-runtime pytest
      - name: Generate Parsers
        run: |
          cd EBL_v0.85
          java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 \
            -visitor -listener -o generated-src/python src/main/antlr4/EBL.g4
      - name: Run Tests
        run: |
          cd EBL_v0.85
          PYTHONPATH=generated-src/python pytest -v
```

---

## Troubleshooting

### Common Issues

#### 1. **ANTLR Parsers Not Generated**
```bash
# Solution: Generate parsers first
cd EBL_v0.85
mvn antlr4:antlr4
# or
java -jar antlr-4.13.1-complete.jar -Dlanguage=Java \
  -visitor -listener -o generated-src/java src/main/antlr4/EBL.g4
```

#### 2. **Python PYTHONPATH Not Set**
```bash
# Solution: Set PYTHONPATH
export PYTHONPATH=generated-src/python
pytest -v
```

#### 3. **Dictionary File Not Found**
```bash
# Ensure you're running from EBL_v0.85/ directory
cd EBL_v0.85
mvn test
```

#### 4. **Test References Old Paths**
If you see errors like:
```
FileNotFoundException: examples/KYC_Onboarding.ebl
```

**Solution:** Update test to use vertical structure:
```java
// Old (broken)
"examples/KYC_Onboarding.ebl"

// New (correct)
"verticals/kyc_compliance/examples/KYC_Onboarding.ebl"
```

---

## Best Practices

### 1. Test Naming
- ✅ Use descriptive names: `test_kyc_onboarding_no_errors()`
- ✅ Include vertical name: `test_banking_mortgage_loan()`
- ❌ Avoid generic names: `test_example1()`

### 2. Test Independence
- ✅ Each test should be independent
- ✅ No shared mutable state between tests
- ✅ Tests should work in any order

### 3. Assertions
- ✅ Include descriptive error messages
- ✅ Test both positive and negative cases
- ✅ Validate errors, warnings, and success cases

### 4. Documentation
- ✅ Add docstrings/JavaDoc to all tests
- ✅ Explain what the test validates
- ✅ Link to related examples/documentation

### 5. Maintenance
- ✅ Update tests when grammar changes
- ✅ Update tests when dictionaries change
- ✅ Keep tests in sync with examples

---

## Future Enhancements

### Completed for v0.85 ✅
- [x] Add tests for all 8 verticals - **COMPLETE** (88% example coverage)
- [x] Banking vertical tests (3 tests)
- [x] Healthcare vertical tests (2 tests)
- [x] Retail vertical tests (2 tests)
- [x] Logistics vertical tests (1 test)
- [x] IT Infrastructure vertical tests (2 tests)

### Remaining for v1.0
- [ ] Add remaining Insurance tests (1 more example: `Insurance_Subrogation_Counterparty.ebl` already covered)
- [ ] Add remaining KYC tests (1 more example: `Governance_SoD_Traceability.ebl`)
- [ ] Add cross-vertical validation tests
- [ ] Add performance benchmarking tests
- [ ] Add grammar regression tests
- [ ] Add code coverage reporting (JaCoCo, Coverage.py)
- [ ] Add mutation testing
- [ ] Add property-based testing (Hypothesis, QuickTheories)
- [ ] Add negative test cases (invalid EBL, malformed dictionaries)

### Quick Wins
- Add tests for the 2 remaining uncovered examples
- Add integration tests that validate multiple verticals together
- Add performance baseline tests for large EBL files

---

## Contributing Tests

When contributing new tests:

1. ✅ Add tests for new examples
2. ✅ Add tests for new grammar features
3. ✅ Update existing tests if breaking changes
4. ✅ Include both Java and Python tests
5. ✅ Document test purpose and coverage
6. ✅ Ensure tests pass before PR submission

See [CONTRIBUTING.md](../CONTRIBUTING.md) for detailed guidelines.

---

**Version:** 0.85
**Last Updated:** 05-11-2025
**Maintainer:** Praxibility Team
**Status:** Active Development
