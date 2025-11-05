"""
IT Infrastructure Vertical Integration Tests for EBL v0.85

Tests the IT Infrastructure vertical examples against the IT Infrastructure domain dictionary.
This ensures that all IT Infrastructure-specific actors, verbs, and constructs are valid.

The IT Infrastructure vertical includes:
- Application lifecycle management
- Infrastructure provisioning (IaC)
- System topology mapping
- SLA management and monitoring
- SOC 2, ISO 27001, ITIL, and CIS Controls compliance
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

def test_it_application_onboarding_no_errors():
    """Test that IT application onboarding example has no semantic errors.

    This example demonstrates application lifecycle management including
    provisioning, deployment, configuration, and monitoring setup.
    """
    v = _run(
        'verticals/it_infrastructure/dictionary/it_infrastructure_dictionary_v0.85.json',
        'verticals/it_infrastructure/examples/IT_Application_Onboarding.ebl'
    )
    assert not v.errors, f"Expected no errors in IT application onboarding, got: {v.errors}"

def test_it_topology_relationships_no_errors():
    """Test that IT topology relationships example has no semantic errors.

    This example demonstrates system topology mapping, dependency relationships,
    and SLA tracking for IT infrastructure management.
    """
    v = _run(
        'verticals/it_infrastructure/dictionary/it_infrastructure_dictionary_v0.85.json',
        'verticals/it_infrastructure/examples/IT-TopologyRelationships.ebl'
    )
    assert not v.errors, f"Expected no errors in IT topology relationships, got: {v.errors}"
