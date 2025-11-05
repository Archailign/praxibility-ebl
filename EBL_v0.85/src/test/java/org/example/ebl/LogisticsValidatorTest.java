package org.example.ebl;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.nio.file.Path;

/**
 * Logistics Vertical Integration Tests for EBL v0.85
 *
 * Tests the Logistics vertical examples against the Logistics domain dictionary.
 * This ensures that all Logistics-specific actors, verbs, and constructs are valid.
 *
 * The Logistics vertical includes:
 * - Shipment tracking and visibility
 * - Warehouse management operations
 * - Route optimization
 * - Delivery confirmation workflows
 * - CTPAT, ISO 28000, and IATA compliance
 */
public class LogisticsValidatorTest {

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
     * Test that the logistics tracking example compiles without errors.
     * This example demonstrates shipment tracking, status updates,
     * and delivery confirmation workflows for supply chain visibility.
     */
    @Test
    public void logistics_tracking_no_errors() throws Exception {
        var v = run(
            "verticals/logistics/dictionary/logistics_dictionary_v0.85.json",
            "verticals/logistics/examples/Logistics_Tracking.ebl"
        );
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected in logistics tracking.");
    }
}
