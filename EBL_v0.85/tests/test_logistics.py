"""
Logistics Vertical Integration Tests for EBL v0.85

Tests the Logistics vertical examples against the Logistics domain dictionary.
This ensures that all Logistics-specific actors, verbs, and constructs are valid.

The Logistics vertical includes:
- Shipment tracking and visibility
- Warehouse management operations
- Route optimization
- Delivery confirmation workflows
- CTPAT, ISO 28000, and IATA compliance
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

def test_logistics_tracking_no_errors():
    """Test that logistics tracking example has no semantic errors.

    This example demonstrates shipment tracking, status updates,
    and delivery confirmation workflows for supply chain visibility.
    """
    v = _run(
        'verticals/logistics/dictionary/logistics_dictionary_v0.85.json',
        'verticals/logistics/examples/Logistics_Tracking.ebl'
    )
    assert not v.errors, f"Expected no errors in logistics tracking, got: {v.errors}"
