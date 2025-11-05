"""
Banking Vertical - Test Suite
Tests for dictionary and semantic validators
"""

import unittest
import os
import sys
from pathlib import Path

# Add validators to path
validators_path = Path(__file__).parent.parent.parent / 'validators' / 'python'
sys.path.insert(0, str(validators_path))

from dictionary_validator import BankingDictionaryValidator
from semantic_validator import BankingSemanticValidator


class TestBankingDictionaryValidator(unittest.TestCase):
    """Test dictionary validation"""

    @classmethod
    def setUpClass(cls):
        """Set up test fixtures"""
        # Path to dictionary
        cls.dict_path = Path(__file__).parent.parent.parent / 'dictionary' / 'banking_dictionary_v0.85.json'
        cls.validator = BankingDictionaryValidator(str(cls.dict_path))

    def test_valid_actors(self):
        """Test that valid actors pass validation"""
        valid_content = """
        Process PaymentProcessing {
            Actors: [PaymentProcessor, FraudAnalyst]
        }
        """
        self.validator.validate_file(valid_content)
        self.assertEqual(len(self.validator.errors), 0)

    def test_invalid_actors(self):
        """Test that invalid actors fail validation"""
        invalid_content = """
        Process PaymentProcessing {
            Actors: [InvalidActor, NonExistentRole]
        }
        """
        self.validator.validate_file(invalid_content)
        self.assertGreater(len(self.validator.errors), 0)

    def test_valid_data_objects(self):
        """Test valid DataObject references"""
        valid_content = """
        DataObject DO_PaymentTransaction {
            Schema:
                amount: Currency
        }

        Entity Payment {
            dataRef: DO_PaymentTransaction
        }
        """
        self.validator.validate_file(valid_content)
        # Should have no errors for dataRef
        dataref_errors = [e for e in self.validator.errors if 'dataRef' in e.message]
        self.assertEqual(len(dataref_errors), 0)

    def test_invalid_dataref(self):
        """Test invalid DataObject reference"""
        invalid_content = """
        Entity Payment {
            dataRef: DO_NonExistent
        }
        """
        self.validator.validate_file(invalid_content)
        dataref_errors = [e for e in self.validator.errors if 'dataRef' in e.message]
        self.assertGreater(len(dataref_errors), 0)

    def test_relationship_types(self):
        """Test relationship type validation"""
        valid_content = """
        Relationship PaymentToAccount {
            From: Payment
            To: Account
            Type: debits_from
        }
        """
        self.validator.validate_file(valid_content)
        # Check warnings for relationship types
        self.assertTrue(True)  # Placeholder


class TestBankingSemanticValidator(unittest.TestCase):
    """Test semantic validation rules"""

    @classmethod
    def setUpClass(cls):
        """Set up test fixtures"""
        cls.dict_path = Path(__file__).parent.parent.parent / 'dictionary' / 'banking_dictionary_v0.85.json'
        cls.validator = BankingSemanticValidator(str(cls.dict_path))

    def test_pci_compliance_card_encryption(self):
        """Test PCI-DSS: Card numbers must be encrypted"""
        content_without_encryption = """
        DataObject DO_Card {
            Schema:
                CardNumber: String
        }
        """
        self.validator.validate(content_without_encryption)
        pci_errors = [i for i in self.validator.issues if i.rule.startswith('PCI')]
        self.assertGreater(len(pci_errors), 0)

    def test_pci_compliance_no_cvv_storage(self):
        """Test PCI-DSS: CVV must not be stored"""
        content_with_cvv_storage = """
        DataObject DO_Card {
            Schema:
                CVV: String
            Policies:
                - Store CVV for later use
        }
        """
        self.validator.validate(content_with_cvv_storage)
        cvv_errors = [i for i in self.validator.issues if 'CVV' in i.message]
        self.assertGreater(len(cvv_errors), 0)

    def test_wire_transfer_dual_authorization(self):
        """Test wire transfers require dual authorization"""
        content_single_actor = """
        Process WireTransfer {
            Actors: [TreasuryOfficer]
        }
        """
        self.validator.validate(content_single_actor)
        wire_warnings = [i for i in self.validator.issues if i.rule.startswith('WIRE')]
        self.assertGreater(len(wire_warnings), 0)

    def test_fraud_detection_required(self):
        """Test that high-risk transactions require fraud screening"""
        content_no_fraud_check = """
        Process PaymentTransfer {
            Actors: [PaymentProcessor]
            Actions:
                - Transfer funds
        }
        """
        self.validator.validate(content_no_fraud_check)
        fraud_warnings = [i for i in self.validator.issues if i.rule.startswith('FRAUD')]
        self.assertGreater(len(fraud_warnings), 0)

    def test_aml_screening_international(self):
        """Test AML screening for international transfers"""
        content_international_no_aml = """
        Process InternationalTransfer {
            Actors: [WireTransferSpecialist]
            Actions:
                - Transfer to foreign account
        }
        """
        self.validator.validate(content_international_no_aml)
        aml_errors = [i for i in self.validator.issues if 'AML' in i.message or 'sanction' in i.message.lower()]
        self.assertGreater(len(aml_errors), 0)

    def test_sensitive_data_encryption(self):
        """Test sensitive data fields are encrypted"""
        content_unencrypted_ssn = """
        DataObject DO_Customer {
            Schema:
                SSN: String
        }
        """
        self.validator.validate(content_unencrypted_ssn)
        data_warnings = [i for i in self.validator.issues if i.rule.startswith('DATA')]
        self.assertGreater(len(data_warnings), 0)

    def test_transaction_balance_validation(self):
        """Test debit operations validate balance"""
        content_no_balance_check = """
        Process WithdrawFunds {
            Actions:
                - Debit account
        }
        """
        self.validator.validate(content_no_balance_check)
        txn_warnings = [i for i in self.validator.issues if i.rule.startswith('TXN')]
        self.assertGreater(len(txn_warnings), 0)


class TestBankingIntegration(unittest.TestCase):
    """Integration tests using real example files"""

    @classmethod
    def setUpClass(cls):
        """Set up paths to example files"""
        cls.dict_path = Path(__file__).parent.parent.parent / 'dictionary' / 'banking_dictionary_v0.85.json'
        cls.examples_path = Path(__file__).parent.parent.parent / 'examples'

    def test_validate_example_files(self):
        """Test validation of example EBL files if they exist"""
        if self.examples_path.exists():
            for ebl_file in self.examples_path.glob('*.ebl'):
                with self.subTest(file=ebl_file.name):
                    dict_validator = BankingDictionaryValidator(str(self.dict_path))
                    semantic_validator = BankingSemanticValidator(str(self.dict_path))

                    with open(ebl_file, 'r') as f:
                        content = f.read()

                    # Both validators should run without exceptions
                    dict_validator.validate_file(content)
                    semantic_validator.validate(content)

                    # Print reports
                    print(f"\n{'='*80}")
                    print(f"Validation Report for: {ebl_file.name}")
                    print(f"{'='*80}")
                    print(dict_validator.get_validation_report())
                    print(semantic_validator.get_validation_report())


def run_tests():
    """Run all tests"""
    unittest.main(verbosity=2)


if __name__ == '__main__':
    run_tests()
