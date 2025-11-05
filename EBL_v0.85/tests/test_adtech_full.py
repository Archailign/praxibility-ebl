"""
AdTech Vertical Integration Tests for EBL v0.85

Tests the AdTech vertical examples against the AdTech domain dictionary.
This ensures that all AdTech-specific actors, verbs, and constructs are valid.
"""
import json
from antlr4 import FileStream, CommonTokenStream, ParseTreeWalker
from EBLLexer import EBLLexer
from EBLParser import EBLParser
from ebl_validator import Dict, Validator

def test_full_adtech_compiles():
    """Test that the full AdTech dynamic marketing cycle example compiles without errors."""
    with open('verticals/adtech/dictionary/adtech_dictionary_v0.85.json', 'r', encoding='utf-8') as f:
        d = Dict(json.load(f))
    s = FileStream('verticals/adtech/examples/AdTech_Dynamic_Marketing_Cycle_Full.ebl', encoding='utf-8')
    l = EBLLexer(s)
    t = CommonTokenStream(l)
    p = EBLParser(t)
    tree = p.eblDefinition()
    v = Validator(d)
    ParseTreeWalker().walk(v, tree)
    assert not v.errors, f"errors: {v.errors}"

def test_adtech_campaign_management():
    """Test that the AdTech campaign management example compiles without errors."""
    with open('verticals/adtech/dictionary/adtech_dictionary_v0.85.json', 'r', encoding='utf-8') as f:
        d = Dict(json.load(f))
    s = FileStream('verticals/adtech/examples/AdCampaignManagement.ebl', encoding='utf-8')
    l = EBLLexer(s)
    t = CommonTokenStream(l)
    p = EBLParser(t)
    tree = p.eblDefinition()
    v = Validator(d)
    ParseTreeWalker().walk(v, tree)
    assert not v.errors, f"errors: {v.errors}"
