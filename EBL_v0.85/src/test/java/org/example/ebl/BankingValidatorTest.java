package org.example.ebl;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.nio.file.Path;

/**
 * Banking Vertical Integration Tests for EBL v0.85
 *
 * Tests the Banking vertical examples against the Banking domain dictionary.
 * This ensures that all Banking-specific actors, verbs, and constructs are valid.
 *
 * The Banking vertical includes:
 * - Mortgage loan application workflows
 * - Payment screening (OFAC, sanctions)
 * - Anti-Financial Crime (AFC) and SAR filing
 * - BSA/AML compliance requirements
 */
public class BankingValidatorTest {

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
     * Test that the mortgage loan application example compiles without errors.
     * This example demonstrates loan origination with LTV (Loan-to-Value) validation
     * and credit risk assessment workflows.
     */
    @Test
    public void mortgage_loan_application_no_errors() throws Exception {
        var v = run(
            "verticals/banking/dictionary/banking_dictionary_v0.85.json",
            "verticals/banking/examples/MortgageLoanApplication.ebl"
        );
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected in mortgage loan application.");
    }

    /**
     * Test that the payments screening example compiles without errors.
     * This example demonstrates OFAC sanctions screening and watchlist validation
     * for payment transactions.
     */
    @Test
    public void payments_screening_no_errors() throws Exception {
        var v = run(
            "verticals/banking/dictionary/banking_dictionary_v0.85.json",
            "verticals/banking/examples/Payments_Screening.ebl"
        );
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected in payments screening.");
    }

    /**
     * Test that the AFC (Anti-Financial Crime) fraud and SAR filing example compiles without errors.
     * This example demonstrates suspicious activity detection and Suspicious Activity Report
     * (SAR) filing workflows for BSA/AML compliance.
     */
    @Test
    public void afc_fraud_sar_no_errors() throws Exception {
        var v = run(
            "verticals/banking/dictionary/banking_dictionary_v0.85.json",
            "verticals/banking/examples/AFC_Fraud_SAR.ebl"
        );
        if (!v.getErrors().isEmpty()) {
            v.getErrors().forEach(System.err::println);
        }
        assertTrue(v.getErrors().isEmpty(), "No semantic errors expected in AFC fraud SAR filing.");
    }
}
