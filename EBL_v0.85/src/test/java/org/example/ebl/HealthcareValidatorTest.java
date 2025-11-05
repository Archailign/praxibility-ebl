package org.example.ebl;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.nio.file.Path;

/**
 * Healthcare Vertical Integration Tests for EBL v0.85
 *
 * Tests the Healthcare vertical examples against the Healthcare domain dictionary.
 * This ensures that all Healthcare-specific actors, verbs, and constructs are valid.
 *
 * The Healthcare vertical includes:
 * - Patient intake and registration workflows
 * - Clinical trial participant enrollment
 * - Protocol compliance and consent management
 * - HIPAA, GDPR, and GCP compliance requirements
 */
public class HealthcareValidatorTest {

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
     * Test that the patient intake example compiles without errors.
     * This example demonstrates patient registration, insurance verification,
     * and initial assessment workflows for healthcare facilities.
     */
    @Test
    public void patient_intake_no_errors() throws Exception {
        var v = run(
            "verticals/healthcare/dictionary/healthcare_dictionary_v0.85.json",
            "verticals/healthcare/examples/Healthcare_PatientIntake.ebl"
        );
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected in patient intake.");
    }

    /**
     * Test that the clinical trial enrollment example compiles without errors.
     * This example demonstrates participant screening, informed consent,
     * protocol compliance, and regulatory requirements (GCP, FDA 21 CFR Part 11).
     */
    @Test
    public void clinical_trial_enrollment_no_errors() throws Exception {
        var v = run(
            "verticals/healthcare/dictionary/healthcare_dictionary_v0.85.json",
            "verticals/healthcare/examples/ClinicalTrialEnrollment.ebl"
        );
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected in clinical trial enrollment.");
    }
}
