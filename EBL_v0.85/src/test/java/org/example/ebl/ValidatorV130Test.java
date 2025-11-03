package org.example.ebl;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.nio.file.Path;

public class ValidatorV130Test {

    private EBLSemanticValidator run(String dict, String ebl) throws Exception {
        CharStream input = CharStreams.fromPath(Path.of(ebl));
        EBLLexer lexer = new EBLLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        EBLParser parser = new EBLParser(tokens);
        ParseTree tree = parser.eblDefinition();
        EBLDictionarySymbols symbols = EBLDictionarySymbols.fromPath(dict);
        EBLSemanticValidator v = new EBLSemanticValidator(symbols);
        ParseTreeWalker.DEFAULT.walk(v, tree);
        return v;
    }

    @Test public void subro_counterparty_relationship_ok() throws Exception {
        var v = run("EBL_Dictionary_v1.3.0.json", "examples/Insurance_Subrogation_Counterparty.ebl");
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected: " + v.getErrors());
        assertFalse(v.getWarnings().isEmpty(), "Expect at least one warning (unused actor).");
    }

    @Test public void kyc_verb_never_permitted_warns() throws Exception {
        var v = run("EBL_Dictionary_v1.3.0.json", "examples/KYC_Verb_NeverPermitted.ebl");
        assertTrue(v.getWarnings().stream().anyMatch(w -> w.contains("never permitted by any actor")));
    }
}
