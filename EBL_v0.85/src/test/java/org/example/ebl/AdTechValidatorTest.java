package org.example.ebl;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.nio.file.Path;

/**
 * AdTech Vertical Integration Tests for EBL v0.85
 *
 * Tests the AdTech vertical examples against the AdTech domain dictionary.
 * This ensures that all AdTech-specific actors, verbs, and constructs are valid.
 *
 * The AdTech vertical includes:
 * - Campaign management workflows
 * - Dynamic marketing cycles
 * - Audience targeting and personalization
 * - GDPR/CCPA compliance requirements
 */
public class AdTechValidatorTest {

    /**
     * Helper method to run validator on an EBL file with a dictionary.
     *
     * @param dict Path to the dictionary JSON file
     * @param ebl Path to the EBL file
     * @return EBLSemanticValidator instance with validation results
     * @throws Exception if file reading or parsing fails
     */
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

    /**
     * Test that the full AdTech dynamic marketing cycle example compiles without errors.
     * This is a comprehensive example demonstrating event-driven campaign optimization.
     */
    @Test
    public void full_adtech_example_has_no_errors() throws Exception {
        var v = run(
            "verticals/adtech/dictionary/adtech_dictionary_v0.85.json",
            "verticals/adtech/examples/AdTech_Dynamic_Marketing_Cycle_Full.ebl"
        );
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected.");
    }

    /**
     * Test that the AdTech campaign management example compiles without errors.
     * This example demonstrates standard campaign lifecycle management.
     */
    @Test
    public void adtech_campaign_management_has_no_errors() throws Exception {
        var v = run(
            "verticals/adtech/dictionary/adtech_dictionary_v0.85.json",
            "verticals/adtech/examples/AdCampaignManagement.ebl"
        );
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected.");
    }
}
