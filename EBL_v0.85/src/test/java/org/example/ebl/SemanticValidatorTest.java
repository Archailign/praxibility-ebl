package org.example.ebl;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.nio.file.Path;

/**
 * Semantic Validator Tests for EBL v0.85
 *
 * Tests semantic validation features across multiple verticals:
 * - Unused actor warnings
 * - Never permitted verb warnings
 * - Cross-vertical validation
 * - Semantic error detection
 *
 * These tests demonstrate the validator's ability to catch semantic issues
 * that pass grammar validation but violate business logic rules.
 *
 * This test suite validates semantic features rather than just parsing,
 * ensuring that EBL files not only parse correctly but also adhere to
 * domain-specific business rules defined in vertical dictionaries.
 */
public class SemanticValidatorTest {

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
     * Test that validator warns about declared but unused actors.
     * Uses Insurance vertical subrogation example.
     */
    @Test
    public void subro_counterparty_relationship_ok() throws Exception {
        var v = run(
            "verticals/insurance/dictionary/insurance_dictionary_v0.85.json",
            "verticals/insurance/examples/Insurance_Subrogation_Counterparty.ebl"
        );
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected: " + v.getErrors());
        assertFalse(v.getWarnings().isEmpty(), "Expect at least one warning (unused actor).");
    }

    /**
     * Test that validator warns about verbs that are never permitted by any actor.
     * Uses KYC vertical example with intentionally invalid verb.
     */
    @Test
    public void kyc_verb_never_permitted_warns() throws Exception {
        var v = run(
            "verticals/kyc_compliance/dictionary/kyc_compliance_dictionary_v0.85.json",
            "verticals/kyc_compliance/examples/KYC_Verb_NeverPermitted.ebl"
        );
        assertTrue(
            v.getWarnings().stream().anyMatch(w -> w.contains("never permitted by any actor")),
            "Expected 'never permitted by any actor' warning"
        );
    }

    /**
     * Test that KYC onboarding example has no semantic errors.
     */
    @Test
    public void kyc_onboarding_no_errors() throws Exception {
        var v = run(
            "verticals/kyc_compliance/dictionary/kyc_compliance_dictionary_v0.85.json",
            "verticals/kyc_compliance/examples/KYC_Onboarding.ebl"
        );
        assertTrue(v.getErrors().isEmpty(), "Expected no errors: " + v.getErrors());
    }

    /**
     * Test that insurance claim lifecycle example has no semantic errors.
     */
    @Test
    public void insurance_claim_lifecycle_no_errors() throws Exception {
        var v = run(
            "verticals/insurance/dictionary/insurance_dictionary_v0.85.json",
            "verticals/insurance/examples/Insurance_ClaimLifecycle.ebl"
        );
        assertTrue(v.getErrors().isEmpty(), "Expected no errors: " + v.getErrors());
    }
}
