package org.example.ebl;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.nio.file.Path;

public class AdTechValidatorTest {
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

    @Test
    public void full_adtech_example_has_no_errors() throws Exception {
        var v = run("EBL_Dictionary_v1.3.1.json", "examples/AdTech_Dynamic_Marketing_Cycle_Full.ebl");
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected.");
    }
}
