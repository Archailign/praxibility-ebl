package org.example.ebl;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.nio.file.Path;

/**
 * IT Infrastructure Vertical Integration Tests for EBL v0.85
 *
 * Tests the IT Infrastructure vertical examples against the IT Infrastructure domain dictionary.
 * This ensures that all IT Infrastructure-specific actors, verbs, and constructs are valid.
 *
 * The IT Infrastructure vertical includes:
 * - Application lifecycle management
 * - Infrastructure provisioning (IaC)
 * - System topology mapping
 * - SLA management and monitoring
 * - SOC 2, ISO 27001, ITIL, and CIS Controls compliance
 */
public class ITInfrastructureValidatorTest {

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
     * Test that the IT application onboarding example compiles without errors.
     * This example demonstrates application lifecycle management including
     * provisioning, deployment, configuration, and monitoring setup.
     */
    @Test
    public void it_application_onboarding_no_errors() throws Exception {
        var v = run(
            "verticals/it_infrastructure/dictionary/it_infrastructure_dictionary_v0.85.json",
            "verticals/it_infrastructure/examples/IT_Application_Onboarding.ebl"
        );
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected in IT application onboarding.");
    }

    /**
     * Test that the IT topology relationships example compiles without errors.
     * This example demonstrates system topology mapping, dependency relationships,
     * and SLA tracking for IT infrastructure management.
     */
    @Test
    public void it_topology_relationships_no_errors() throws Exception {
        var v = run(
            "verticals/it_infrastructure/dictionary/it_infrastructure_dictionary_v0.85.json",
            "verticals/it_infrastructure/examples/IT-TopologyRelationships.ebl"
        );
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected in IT topology relationships.");
    }
}
