"""
Semantic Validator Tests for EBL v0.85

Tests semantic validation features across multiple verticals:
- Unused actor warnings
- Never permitted verb warnings
- Cross-vertical validation

These tests demonstrate the validator's ability to catch semantic issues
that pass grammar validation but violate business logic rules.
"""
from antlr4 import FileStream, CommonTokenStream, ParseTreeWalker
from EBLLexer import EBLLexer
from EBLParser import EBLParser
from ebl_validator import Dict, Validator
import json

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

def test_unused_actor_warning():
    """Test that validator warns about declared but unused actors."""
    v = _run(
        'verticals/insurance/dictionary/insurance_dictionary_v0.85.json',
        'verticals/insurance/examples/Insurance_Subrogation_Counterparty.ebl'
    )
    assert any("declared but never used" in w for w in v.warnings), \
        f"Expected unused actor warning, got: {v.warnings}"

def test_never_permitted_warning():
    """Test that validator warns about verbs that are never permitted by any actor."""
    v = _run(
        'verticals/kyc_compliance/dictionary/kyc_compliance_dictionary_v0.85.json',
        'verticals/kyc_compliance/examples/KYC_Verb_NeverPermitted.ebl'
    )
    assert any("never permitted by any actor" in w for w in v.warnings), \
        f"Expected never permitted warning, got: {v.warnings}"

def test_kyc_onboarding_no_errors():
    """Test that KYC onboarding example has no semantic errors."""
    v = _run(
        'verticals/kyc_compliance/dictionary/kyc_compliance_dictionary_v0.85.json',
        'verticals/kyc_compliance/examples/KYC_Onboarding.ebl'
    )
    assert not v.errors, f"Expected no errors, got: {v.errors}"

def test_insurance_claim_lifecycle_no_errors():
    """Test that insurance claim lifecycle example has no semantic errors."""
    v = _run(
        'verticals/insurance/dictionary/insurance_dictionary_v0.85.json',
        'verticals/insurance/examples/Insurance_ClaimLifecycle.ebl'
    )
    assert not v.errors, f"Expected no errors, got: {v.errors}"
