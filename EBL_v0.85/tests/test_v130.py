from antlr4 import FileStream, CommonTokenStream, ParseTreeWalker
from EBLLexer import EBLLexer
from EBLParser import EBLParser
from ebl_validator import Dict, Validator
import json

def _run(dict_path, ebl_path):
    with open(dict_path,'r',encoding='utf-8') as f:
        d = Dict(json.load(f))
    s = FileStream(ebl_path, encoding='utf-8')
    l = EBLLexer(s); t = CommonTokenStream(l); p = EBLParser(t)
    tree = p.eblDefinition()
    v = Validator(d)
    ParseTreeWalker().walk(v, tree)
    return v

def test_unused_actor_warning():
    v = _run('EBL_Dictionary_v1.3.0.json', 'examples/Insurance_Subrogation_Counterparty.ebl')
    assert any("declared but never used" in w for w in v.warnings)

def test_never_permitted_warning():
    v = _run('EBL_Dictionary_v1.3.0.json', 'examples/KYC_Verb_NeverPermitted.ebl')
    assert any("never permitted by any actor" in w for w in v.warnings)
