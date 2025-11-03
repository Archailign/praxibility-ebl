import json
from antlr4 import FileStream, CommonTokenStream, ParseTreeWalker
from EBLLexer import EBLLexer
from EBLParser import EBLParser
from ebl_validator import Dict, Validator

def test_full_adtech_compiles():
    with open('EBL_Dictionary_v1.3.1.json','r',encoding='utf-8') as f:
        d = Dict(json.load(f))
    s = FileStream('examples/AdTech_Dynamic_Marketing_Cycle_Full.ebl', encoding='utf-8')
    l = EBLLexer(s); t = CommonTokenStream(l); p = EBLParser(t)
    tree = p.eblDefinition()
    v = Validator(d)
    ParseTreeWalker().walk(v, tree)
    assert not v.errors, f"errors: {v.errors}"
