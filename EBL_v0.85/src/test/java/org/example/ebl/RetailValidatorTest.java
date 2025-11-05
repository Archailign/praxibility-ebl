package org.example.ebl;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.nio.file.Path;

/**
 * Retail Vertical Integration Tests for EBL v0.85
 *
 * Tests the Retail vertical examples against the Retail domain dictionary.
 * This ensures that all Retail-specific actors, verbs, and constructs are valid.
 *
 * The Retail vertical includes:
 * - Order fulfillment workflows
 * - Inventory management and replenishment
 * - Returns and refunds processing
 * - PCI-DSS and consumer protection compliance
 */
public class RetailValidatorTest {

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
     * Test that the retail order inventory example compiles without errors.
     * This example demonstrates order fulfillment with inventory management,
     * picking, packing, and shipping workflows for e-commerce operations.
     */
    @Test
    public void retail_order_inventory_no_errors() throws Exception {
        var v = run(
            "verticals/retail/dictionary/retail_dictionary_v0.85.json",
            "verticals/retail/examples/Retail_Order_Inventory.ebl"
        );
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected in retail order inventory.");
    }

    /**
     * Test that the inventory replenishment example compiles without errors.
     * This example demonstrates automated inventory replenishment workflows,
     * including reorder point calculation, supplier management, and stock optimization.
     */
    @Test
    public void inventory_replenishment_no_errors() throws Exception {
        var v = run(
            "verticals/retail/dictionary/retail_dictionary_v0.85.json",
            "verticals/retail/examples/InventoryReplenishment.ebl"
        );
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected in inventory replenishment.");
    }
}
