# ebl_validator.py — v0.85 (Initial open source release)
import sys, json, re
from antlr4 import FileStream, CommonTokenStream, ParseTreeWalker
from EBLLexer import EBLLexer
from EBLParser import EBLParser
from EBLListener import EBLListener

def canon(s): return re.sub(r'[^A-Za-z0-9_]+','', s or '').lower()

class Dict:
    def __init__(self, d: dict):
        core = d.get("core",{})
        self.reserved = set(k.upper() for k in (core.get("keywords",{}).get("reserved") or []))
        self.verb_perms = { canon(k): v.lower() for k,v in (core.get("verbPermissions") or {}).items() }
        self.rel_types = set(canon(x) for x in (core.get("relationshipTypes") or []))
        self.actors = set(); self.verbs = set(); self.actor_verbs = {}; self.read = {}; self.write = {}
        self.union_allowed_verbs = set()
        for dom in (d.get("domains") or {}).values():
            if not dom: continue
            for a in dom.get("actors",[]) or []: self.actors.add(canon(a))
            for v in dom.get("verbs",[]) or []: self.verbs.add(canon(v))
            for a,vlist in (dom.get("actorVerbs") or {}).items():
                vs = set(canon(v) for v in vlist)
                self.actor_verbs.setdefault(canon(a), set()).update(vs)
                self.union_allowed_verbs.update(vs)
            for a,p in (dom.get("actorDataPerms") or {}).items():
                if p.get("read"): self.read.setdefault(canon(a), set()).update(canon(x) for x in p["read"])
                if p.get("write"): self.write.setdefault(canon(a), set()).update(canon(x) for x in p["write"])

    def has_actor(self, a): return canon(a) in self.actors
    def has_verb(self, v): return canon(v) in self.verbs
    def actor_allows(self, a,v):
        allowed = self.actor_verbs.get(canon(a))
        return True if not allowed else canon(v) in allowed
    def can_read(self, a,d): 
        s = self.read.get(canon(a)); return True if not s else canon(d) in s
    def can_write(self, a,d): 
        s = self.write.get(canon(a)); return True if not s else canon(d) in s
    def perm_for(self, v): return self.verb_perms.get(canon(v))
    def is_rel(self, t): return canon(t) in self.rel_types
    def permitted_any(self, v): return True if not self.union_allowed_verbs else canon(v) in self.union_allowed_verbs

class Validator(EBLListener):
    def __init__(self, d: Dict, warn_unknown_assets=True):
        self.d = d
        self.warn_unknown_assets = warn_unknown_assets
        self.errors=[]; self.warnings=[]
        self.dataobjs=set(); self.entities=set(); self.itassets=set()
        self.pending=[]
        self.proc_stack=[]  # [(declared set, used set)]
        self.entity_enum_vals = {}; self.entity_enum_defs = {}

    def enterDataObject(self, ctx):
        self.dataobjs.add(ctx.IDENTIFIER(0).getText())
        for f in ctx.fieldDef():
            field = f.IDENTIFIER().getText(); type_ = f.type().getText()
            attrs = "".join(a.getText() for a in f.fieldAttr())
            if "min=" in attrs and "max=" in attrs:
                try:
                    m = float(re.search(r'min=([0-9]+(\.[0-9]+)?)', attrs).group(1))
                    x = float(re.search(r'max=([0-9]+(\.[0-9]+)?)', attrs).group(1))
                    if m > x: self.errors.append(f"DataObject: field '{field}' has min>max ({m} > {x})")
                except Exception: pass
            if type_ == "Enum" and "values=" not in attrs:
                self.warnings.append(f"DataObject: field '{field}' Enum without values= list.")

    def enterEntity(self, ctx):
        name = ctx.IDENTIFIER(0).getText()
        self.entities.add(name)
        self.pending.append((name, ctx.IDENTIFIER(1).getText()))
        for p in ctx.property():
            prop = p.IDENTIFIER().getText()
            type_ = p.propertyDef().type().getText()
            if type_ == "Enum":
                key = f"{name}.{prop}"; vals=set(); default=None
                for a in p.propertyDef().propertyAttr():
                    txt = a.getText()
                    if txt.startswith("values:"):
                        m = re.search(r'\[(.*?)\]', txt)
                        if m:
                            inside = m.group(1)
                            for v in inside.split(","):
                                vals.add(re.sub(r'[\[\]\s"\']','',v))
                    if txt.startswith("default:"):
                        default = re.sub(r'[:\s"\']','', txt.split("default:")[-1])
                if vals: self.entity_enum_vals[key]=vals
                if default is not None: self.entity_enum_defs[key]=default

    def exitEblDefinition(self, ctx):
        for ent,ref in self.pending:
            if ref not in self.dataobjs:
                self.errors.append(f"Entity '{ent}' references missing DataObject '{ref}' (dataRef).")
        for key, default in self.entity_enum_defs.items():
            vals = self.entity_enum_vals.get(key, set())
            if vals and default not in vals:
                self.errors.append(f"Enum default '{default}' not in values for {key}")

    def enterItAsset(self, ctx): self.itassets.add(ctx.IDENTIFIER(0).getText())

    def enterProcess(self, ctx):
        txt = ctx.getText()
        declared=set()
        m = re.search(r'Actors:\[([^\]]+)\]', txt)
        if m:
            for s in m.group(1).split(","):
                t = re.sub(r'[^A-Za-z0-9_]','', s)
                if t: declared.add(t)
        self.proc_stack.append([declared,set()])

    def exitProcess(self, ctx):
        declared, used = self.proc_stack.pop()
        for a in declared:
            if a not in used:
                self.warnings.append(f"Process: actor '{a}' declared but never used in Actions.")

    def enterAction(self, ctx):
        line = ctx.getText()
        m = re.match(r'^\s*-\s*([A-Za-z_][A-Za-z0-9_]*)\s+([A-Za-z][A-Za-z0-9_]*)\b', line)
        if not m:
            self.warnings.append("Action missing explicit 'Actor Verb' prefix; use '- <Actor> <Verb> ...'")
            return
        actor, verb = m.group(1), m.group(2)
        if self.proc_stack:
            self.proc_stack[-1][1].add(actor)
        if not self.d.has_actor(actor): self.warnings.append(f"Action actor '{actor}' not in dictionary.")
        if not self.d.has_verb(verb): self.warnings.append(f"Verb '{verb}' not in domain verb list.")
        if not self.d.permitted_any(verb): self.warnings.append(f"Verb '{verb}' is never permitted by any actor in the domain whitelist.")
        if not self.d.actor_allows(actor, verb): self.warnings.append(f"Actor '{actor}' not allowed to perform '{verb}'.")
        need = self.d.perm_for(verb)
        for dobj, io in re.findall(r'\b(DO_[A-Za-z0-9_]+)\s*(Input|Output)?\b', line):
            if not io and need: io = "Input" if need == "write" else "Output"
            if io == "Input" and not self.d.can_write(actor, dobj):
                self.warnings.append(f"Actor '{actor}' lacks WRITE permission on '{dobj}' (verb '{verb}').")
            if io == "Output" and not self.d.can_read(actor, dobj):
                self.warnings.append(f"Actor '{actor}' lacks READ permission on '{dobj}' (verb '{verb}').")

    def _check_text(self, where, text):
        if not text: return
        for kw in self.d.reserved:
            if re.search(rf'\\b{re.escape(kw)}\\b', text, flags=re.I):
                self.warnings.append(f"{where}: free-text contains reserved keyword '{kw}'; consider quoting or using structured fields.")

    def enterValidation(self, ctx):
        t = re.sub(r'^\\s*-\\s*','', ctx.getText())
        self._check_text("Validation", t)

    def enterRuleDef(self, ctx):
        desc = ctx.STRING(0).getText()
        trig = ctx.TEXT(0).getText()
        self._check_text("Rule.Description", desc)
        self._check_text("Rule.Trigger", trig)

    def enterReport(self, ctx):
        q = ctx.TEXT(0).getText()
        self._check_text("Report.Query", q)

    def enterRelationshipDef(self, ctx):
        name = ctx.IDENTIFIER(0).getText()
        from_ = ctx.IDENTIFIER(1).getText()
        to    = ctx.IDENTIFIER(2).getText()
        typ   = ctx.IDENTIFIER(3).getText()
        known = set(list(self.entities)+list(self.itassets)+list(self.d.actors))
        if self.warn_unknown_assets:
            if from_ not in known: self.warnings.append(f"Relationship '{name}': From='{from_}' not a known Entity/ITAsset/Actor.")
            if to not in known: self.warnings.append(f"Relationship '{name}': To='{to}' not a known Entity/ITAsset/Actor.")
        if not self.d.is_rel(typ):
            self.warnings.append(f"Relationship '{name}': Type '{typ}' is not allowed.")
        if typ == "hosted_on":
            if "DO_ApplicationCatalog" not in self.dataobjs and "DO_PlatformRegistry" not in self.dataobjs:
                self.warnings.append(f"Relationship '{name}': hosted_on used but neither DO_ApplicationCatalog nor DO_PlatformRegistry defined.")

def main():
    if len(sys.argv) < 3:
        print("Usage: python ebl_validator.py EBL_Dictionary_v1.3.1.json <file.ebl>")
        sys.exit(1)
    with open(sys.argv[1], "r", encoding="utf-8") as f:
        d = Dict(json.load(f))
    s = FileStream(sys.argv[2], encoding="utf-8")
    l = EBLLexer(s); t = CommonTokenStream(l); p = EBLParser(t)
    tree = p.eblDefinition()
    v = Validator(d, warn_unknown_assets=True)
    ParseTreeWalker().walk(v, tree)
    if v.warnings: print("Warnings:"); [print(" -", w) for w in v.warnings]
    if v.errors: print("Errors:"); [print(" -", e) for e in v.errors]); sys.exit(2)
    print("Semantic validation passed.")

if __name__ == "__main__":
    main()
