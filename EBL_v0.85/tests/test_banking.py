"""
Banking Vertical Integration Tests for EBL v0.85

Tests the Banking vertical examples against the Banking domain dictionary.
This ensures that all Banking-specific actors, verbs, and constructs are valid.

The Banking vertical includes:
- Mortgage loan application workflows
- Payment screening (OFAC, sanctions)
- Anti-Financial Crime (AFC) and SAR filing
- BSA/AML compliance requirements
"""
import json
from antlr4 import FileStream, CommonTokenStream, ParseTreeWalker
from EBLLexer import EBLLexer
from EBLParser import EBLParser
from ebl_validator import Dict, Validator

def _run(dict_path, ebl_path):
    """Helper function to run validator on an EBL file with a dictionary."""
    with open(dict_path, 'r', encoding='utf-8') as f:
        d = Dict(json.load(f))
    s = FileStream(ebl_path, encoding='utf-8')
    l = EBLLexer(s)
    t = CommonTokenStream(l)
    p = EBLParser(t)
    tree = p.eblDefinition()
    v = Validator(d)
    ParseTreeWalker().walk(v, tree)
    return v

def test_mortgage_loan_application_no_errors():
    """Test that mortgage loan application example has no semantic errors.

    This example demonstrates loan origination with LTV (Loan-to-Value) validation
    and credit risk assessment workflows.
    """
    v = _run(
        'verticals/banking/dictionary/banking_dictionary_v0.85.json',
        'verticals/banking/examples/MortgageLoanApplication.ebl'
    )
    assert not v.errors, f"Expected no errors in mortgage loan application, got: {v.errors}"

def test_payments_screening_no_errors():
    """Test that payments screening example has no semantic errors.

    This example demonstrates OFAC sanctions screening and watchlist validation
    for payment transactions.
    """
    v = _run(
        'verticals/banking/dictionary/banking_dictionary_v0.85.json',
        'verticals/banking/examples/Payments_Screening.ebl'
    )
    assert not v.errors, f"Expected no errors in payments screening, got: {v.errors}"

def test_afc_fraud_sar_no_errors():
    """Test that AFC fraud and SAR filing example has no semantic errors.

    This example demonstrates suspicious activity detection and Suspicious Activity Report
    (SAR) filing workflows for BSA/AML compliance.
    """
    v = _run(
        'verticals/banking/dictionary/banking_dictionary_v0.85.json',
        'verticals/banking/examples/AFC_Fraud_SAR.ebl'
    )
    assert not v.errors, f"Expected no errors in AFC fraud SAR filing, got: {v.errors}"
