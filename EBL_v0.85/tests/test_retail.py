"""
Retail Vertical Integration Tests for EBL v0.85

Tests the Retail vertical examples against the Retail domain dictionary.
This ensures that all Retail-specific actors, verbs, and constructs are valid.

The Retail vertical includes:
- Order fulfillment workflows
- Inventory management and replenishment
- Returns and refunds processing
- PCI-DSS and consumer protection compliance
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

def test_retail_order_inventory_no_errors():
    """Test that retail order inventory example has no semantic errors.

    This example demonstrates order fulfillment with inventory management,
    picking, packing, and shipping workflows for e-commerce operations.
    """
    v = _run(
        'verticals/retail/dictionary/retail_dictionary_v0.85.json',
        'verticals/retail/examples/Retail_Order_Inventory.ebl'
    )
    assert not v.errors, f"Expected no errors in retail order inventory, got: {v.errors}"

def test_inventory_replenishment_no_errors():
    """Test that inventory replenishment example has no semantic errors.

    This example demonstrates automated inventory replenishment workflows,
    including reorder point calculation, supplier management, and stock optimization.
    """
    v = _run(
        'verticals/retail/dictionary/retail_dictionary_v0.85.json',
        'verticals/retail/examples/InventoryReplenishment.ebl'
    )
    assert not v.errors, f"Expected no errors in inventory replenishment, got: {v.errors}"
