# EBL Testing Strategy v0.85

## Overview

EBL v0.85 uses a **vertical-specific testing approach** where each vertical contains its own tests and validators. Each vertical is self-contained with Python and Java test suites.

---

## Test Organization

```
EBL_v0.85/
└── verticals/
    ├── banking/
    │   ├── tests/
    │   │   ├── python/
    │   │   │   └── test_banking_validator.py
    │   │   └── java/
    │   │       └── BankingValidatorTest.java
    │   └── validators/
    │       ├── python/
    │       │   ├── dictionary_validator.py
    │       │   └── semantic_validator.py
    │       └── java/
    │           └── BankingDictionaryValidator.java
    │
    ├── healthcare/     [Same structure]
    ├── retail/         [Same structure]
    ├── insurance/      [Same structure]
    ├── kyc_compliance/ [Same structure]
    ├── adtech/         [Same structure]
    ├── logistics/      [Same structure]
    └── it_infrastructure/ [Same structure]
```

---

## Test Types

### 1. Dictionary Validation Tests

**Purpose:** Validate EBL files against vertical dictionary constraints

**What they check:**
- ✅ Actors exist in dictionary
- ✅ Verbs are valid for the domain
- ✅ Entities are properly defined
- ✅ DataObjects follow naming conventions
- ✅ Relationship types are valid

**Example (Python):**
```python
def test_valid_actors():
    """Test that valid actors pass validation"""
    validator = BankingDictionaryValidator('dictionary/banking_dictionary_v0.85.json')
    content = """
    Process PaymentProcessing {
        Actors: [PaymentProcessor, FraudAnalyst]
    }
    """
    validator.validate_file(content)
    assert len(validator.errors) == 0
```

**Example (Java):**
```java
@Test
public void testValidActors() {
    BankingDictionaryValidator validator = new BankingDictionaryValidator(
        "dictionary/banking_dictionary_v0.85.json"
    );
    boolean isValid = validator.validateContent(content);
    assertTrue(isValid);
}
```

---

### 2. Semantic Validation Tests

**Purpose:** Validate business logic and compliance rules

**Domain-Specific Rules:**

**Banking:**
- PCI-DSS: Card encryption, CVV non-storage
- Wire transfers: Dual authorization
- Fraud detection requirements
- AML/sanctions screening
- SOX compliance

**Healthcare:**
- HIPAA: PHI protection
- FDA regulations
- Clinical trial protocols
- HL7/FHIR standards

**Retail:**
- PCI compliance for payments
- Inventory management
- Pricing validation
- Omnichannel logic

**Insurance:**
- NAIC compliance
- Claims validation
- Fraud detection
- Reserve requirements

**KYC/Compliance:**
- KYC/AML rules
- Sanctions screening
- PEP checks
- SAR filing

**AdTech:**
- GDPR consent
- Privacy compliance
- Viewability standards
- Fraud detection

**Logistics:**
- Customs compliance
- Incoterms validation
- Route optimization
- Hazmat rules

**IT Infrastructure:**
- SLO compliance
- Security controls
- Change management
- Incident response

---

## Running Tests

### Python Tests

```bash
# Run tests for a specific vertical
cd verticals/banking/tests/python
python test_banking_validator.py

# Run with pytest
cd verticals/banking
pytest tests/python/test_banking_validator.py -v

# Run all tests for all verticals
for vertical in banking healthcare retail insurance kyc_compliance adtech logistics it_infrastructure; do
  echo "Testing $vertical..."
  cd verticals/$vertical/tests/python && python test_${vertical}_validator.py
done
```

### Java Tests

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

---

## Validation Examples

### Banking Vertical

```bash
cd verticals/banking

# Dictionary validation
python validators/python/dictionary_validator.py \
  examples/MortgageLoanApplication.ebl \
  dictionary/banking_dictionary_v0.85.json

# Semantic validation
python validators/python/semantic_validator.py \
  examples/Payments_Screening.ebl \
  dictionary/banking_dictionary_v0.85.json
```

### Healthcare Vertical

```bash
cd verticals/healthcare

# Dictionary validation
python validators/python/dictionary_validator.py \
  examples/PatientIntake.ebl \
  dictionary/healthcare_dictionary_v0.85.json
```

---

## Test Coverage

| Vertical | Dictionary | Grammar | Validators | Tests | Status |
|----------|-----------|---------|------------|-------|--------|
| Banking | ✅ | ✅ | ✅ Complete | ✅ Complete | Production-Ready |
| Healthcare | ✅ | ✅ | 📝 Stub | 📝 Stub | Templates Ready |
| Retail | ✅ | ✅ | 📝 Stub | 📝 Stub | Templates Ready |
| Insurance | ✅ | ✅ | 📝 Stub | 📝 Stub | Templates Ready |
| KYC/Compliance | ✅ | ✅ | 📝 Stub | 📝 Stub | Templates Ready |
| AdTech | ✅ | ✅ | 📝 Stub | 📝 Stub | Templates Ready |
| Logistics | ✅ | ✅ | 📝 Stub | 📝 Stub | Templates Ready |
| IT Infrastructure | ✅ | ✅ | 📝 Stub | 📝 Stub | Templates Ready |

**Legend:**
- ✅ Fully implemented
- 📝 Template/stub created (ready for customization)

---

## Adding New Tests

### 1. Add Python Test

Create test in `verticals/[vertical]/tests/python/`:

```python
import unittest
from pathlib import Path
import sys

# Add validators to path
validators_path = Path(__file__).parent.parent.parent / 'validators' / 'python'
sys.path.insert(0, str(validators_path))

from dictionary_validator import [Vertical]DictionaryValidator
from semantic_validator import [Vertical]SemanticValidator

class Test[Vertical]Validator(unittest.TestCase):

    def test_example_validation(self):
        """Test validation of example file"""
        validator = [Vertical]DictionaryValidator('../../dictionary/[vertical]_dictionary_v0.85.json')
        with open('../../examples/Example.ebl', 'r') as f:
            content = f.read()
        validator.validate_file(content)
        self.assertEqual(len(validator.errors), 0)

if __name__ == '__main__':
    unittest.main()
```

### 2. Add Java Test

Create test in `verticals/[vertical]/tests/java/`:

```java
package com.archailign.ebl.[vertical].tests;

import com.archailign.ebl.[vertical].validators.[Vertical]DictionaryValidator;

public class [Vertical]ValidatorTest {

    public static void main(String[] args) {
        try {
            [Vertical]DictionaryValidator validator =
                new [Vertical]DictionaryValidator("../../dictionary/[vertical]_dictionary_v0.85.json");

            boolean isValid = validator.validateFile("../../examples/Example.ebl");

            if (isValid) {
                System.out.println("✅ Validation passed");
            } else {
                System.out.println("❌ Validation failed");
                System.exit(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
    }
}
```

---

## Best Practices

### Test Independence
- ✅ Each test should be independent
- ✅ No shared mutable state
- ✅ Tests work in any order

### Clear Assertions
- ✅ Descriptive error messages
- ✅ Test both positive and negative cases
- ✅ Validate errors, warnings, and success

### Documentation
- ✅ Add docstrings to all tests
- ✅ Explain what the test validates
- ✅ Link to related examples

### Maintenance
- ✅ Update tests when dictionaries change
- ✅ Keep tests in sync with examples
- ✅ Add tests for new validation rules

---

## Continuous Integration

### GitHub Actions Example

```yaml
name: EBL Vertical Tests

on: [push, pull_request]

jobs:
  test-verticals:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        vertical: [banking, healthcare, retail, insurance, kyc_compliance, adtech, logistics, it_infrastructure]

    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.9'

      - name: Install Dependencies
        run: pip install pytest

      - name: Run ${{ matrix.vertical }} Tests
        run: |
          cd verticals/${{ matrix.vertical }}/tests/python
          python test_${{ matrix.vertical }}_validator.py
```

---

## Next Steps

1. **Customize Validators** - Use Banking as template for other verticals
2. **Expand Test Coverage** - Add more test cases for each vertical
3. **Integration Tests** - Test cross-vertical workflows
4. **Performance Tests** - Benchmark large EBL files
5. **Regression Tests** - Prevent breaking changes

---

**Version:** 0.85
**Architecture:** ANTLR-Based Self-Contained Vertical Testing
**Last Updated:** 2025-11-05
**Status:** Production-Ready (Banking), Templates Ready (Other Verticals)
