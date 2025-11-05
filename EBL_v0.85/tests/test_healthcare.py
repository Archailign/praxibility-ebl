"""
Healthcare Vertical Integration Tests for EBL v0.85

Tests the Healthcare vertical examples against the Healthcare domain dictionary.
This ensures that all Healthcare-specific actors, verbs, and constructs are valid.

The Healthcare vertical includes:
- Patient intake and registration workflows
- Clinical trial participant enrollment
- Protocol compliance and consent management
- HIPAA, GDPR, and GCP compliance requirements
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

def test_patient_intake_no_errors():
    """Test that patient intake example has no semantic errors.

    This example demonstrates patient registration, insurance verification,
    and initial assessment workflows for healthcare facilities.
    """
    v = _run(
        'verticals/healthcare/dictionary/healthcare_dictionary_v0.85.json',
        'verticals/healthcare/examples/Healthcare_PatientIntake.ebl'
    )
    assert not v.errors, f"Expected no errors in patient intake, got: {v.errors}"

def test_clinical_trial_enrollment_no_errors():
    """Test that clinical trial enrollment example has no semantic errors.

    This example demonstrates participant screening, informed consent,
    protocol compliance, and regulatory requirements (GCP, FDA 21 CFR Part 11).
    """
    v = _run(
        'verticals/healthcare/dictionary/healthcare_dictionary_v0.85.json',
        'verticals/healthcare/examples/ClinicalTrialEnrollment.ebl'
    )
    assert not v.errors, f"Expected no errors in clinical trial enrollment, got: {v.errors}"
