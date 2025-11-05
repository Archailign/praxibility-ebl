"""
Banking Vertical - Semantic Validator
Validates semantic consistency and business logic in Banking EBL files
"""

import json
import re
from typing import Dict, List, Set, Optional
from dataclasses import dataclass
from enum import Enum


class Severity(Enum):
    ERROR = "error"
    WARNING = "warning"
    INFO = "info"


@dataclass
class SemanticIssue:
    """Represents a semantic validation issue"""
    severity: Severity
    rule: str
    message: str
    location: Optional[str] = None
    suggestion: Optional[str] = None


class BankingSemanticValidator:
    """
    Validates semantic rules for Banking vertical:
    - PCI-DSS compliance requirements
    - SWIFT/Wire transfer validation
    - Fraud detection rules
    - Regulatory compliance (SOX, Basel III, etc.)
    - Actor authorization constraints
    """

    def __init__(self, dictionary_path: str):
        """
        Initialize semantic validator

        Args:
            dictionary_path: Path to banking_dictionary_v0.85.json
        """
        with open(dictionary_path, 'r') as f:
            self.dictionary = json.load(f)

        self.issues: List[SemanticIssue] = []
        self.actor_verbs = self.dictionary['domain']['actorVerbs']
        self.actor_data_perms = self.dictionary['domain']['actorDataPerms']
        self.verb_permissions = self.dictionary['core']['verbPermissions']

    def validate(self, ebl_content: str) -> bool:
        """
        Run all semantic validation rules

        Args:
            ebl_content: Content of EBL file

        Returns:
            True if no errors, False otherwise
        """
        self.issues = []

        self._validate_pci_compliance(ebl_content)
        self._validate_wire_transfers(ebl_content)
        self._validate_fraud_detection(ebl_content)
        self._validate_sox_compliance(ebl_content)
        self._validate_actor_authorization(ebl_content)
        self._validate_sensitive_data_handling(ebl_content)
        self._validate_transaction_integrity(ebl_content)
        self._validate_audit_trail(ebl_content)

        # Return False if any ERROR severity issues
        return not any(issue.severity == Severity.ERROR for issue in self.issues)

    def _validate_pci_compliance(self, content: str):
        """Validate PCI-DSS compliance requirements"""

        # Rule 1: CardNumber fields must be encrypted or tokenized
        if 'CardNumber' in content or 'PAN' in content or 'card_number' in content.lower():
            if 'encrypted' not in content.lower() and 'token' not in content.lower():
                self.issues.append(SemanticIssue(
                    severity=Severity.ERROR,
                    rule="PCI-DSS-001",
                    message="Card numbers must be encrypted or tokenized",
                    suggestion="Add 'encrypted: true' or use tokenization for card data"
                ))

        # Rule 2: CVV must never be stored
        if 'CVV' in content or 'CVV2' in content or 'CVC' in content:
            if 'persist' in content.lower() or 'store' in content.lower():
                self.issues.append(SemanticIssue(
                    severity=Severity.ERROR,
                    rule="PCI-DSS-002",
                    message="CVV/CVC data must never be stored after authorization",
                    suggestion="Remove CVV storage; collect only for authorization"
                ))

        # Rule 3: Payment processing must have proper actor authorization
        payment_patterns = ['ProcessPayment', 'AuthorizeCard', 'CapturePayment']
        for pattern in payment_patterns:
            if pattern in content:
                # Check if proper actor is assigned
                if 'PaymentProcessor' not in content and 'PaymentGateway' not in content:
                    self.issues.append(SemanticIssue(
                        severity=Severity.WARNING,
                        rule="PCI-DSS-003",
                        message=f"Payment operation '{pattern}' should be performed by PaymentProcessor or PaymentGateway",
                        suggestion="Assign to PaymentProcessor or PaymentGateway actor"
                    ))

    def _validate_wire_transfers(self, content: str):
        """Validate wire transfer semantic rules"""

        # Rule 1: Wire transfers require dual authorization for amounts > threshold
        if 'WireTransfer' in content or 'SWIFT' in content or 'Fedwire' in content:
            if 'Approve' in content and 'Actors' in content:
                actors_match = re.search(r'Actors\s*:\s*\[(.*?)\]', content)
                if actors_match:
                    actors = [a.strip() for a in actors_match.group(1).split(',')]
                    if len(actors) < 2:
                        self.issues.append(SemanticIssue(
                            severity=Severity.WARNING,
                            rule="WIRE-001",
                            message="Wire transfers typically require dual authorization",
                            suggestion="Consider adding second approver for high-value transfers"
                        ))

        # Rule 2: SWIFT messages must include proper validation
        if 'SWIFT' in content or 'MT103' in content or 'MT202' in content:
            if 'Validate' not in content and 'Verify' not in content:
                self.issues.append(SemanticIssue(
                    severity=Severity.WARNING,
                    rule="WIRE-002",
                    message="SWIFT messages should include validation step",
                    suggestion="Add validation for SWIFT message format and completeness"
                ))

    def _validate_fraud_detection(self, content: str):
        """Validate fraud detection requirements"""

        # Rule 1: High-risk transactions must have fraud screening
        high_risk_patterns = ['Transfer', 'Payment', 'Withdrawal']
        for pattern in high_risk_patterns:
            if pattern in content:
                if 'FraudCheck' not in content and 'Screen' not in content and 'Fraud' not in content:
                    self.issues.append(SemanticIssue(
                        severity=Severity.WARNING,
                        rule="FRAUD-001",
                        message=f"Transaction type '{pattern}' should include fraud screening",
                        suggestion="Add FraudDetectionEngine or FraudAnalyst to actors"
                    ))

        # Rule 2: AML screening for international transfers
        if ('International' in content or 'Cross-Border' in content) and 'Transfer' in content:
            if 'AML' not in content and 'Sanction' not in content and 'Screen' not in content:
                self.issues.append(SemanticIssue(
                    severity=Severity.ERROR,
                    rule="FRAUD-002",
                    message="International transfers must include AML/sanctions screening",
                    suggestion="Add sanctions screening and AML checks"
                ))

    def _validate_sox_compliance(self, content: str):
        """Validate Sarbanes-Oxley compliance"""

        # Rule 1: Segregation of duties
        if 'Process' in content:
            # Check if same actor has conflicting permissions
            if 'CreateTransaction' in content and 'ApproveTransaction' in content:
                # Would need full parsing to check if same actor
                self.issues.append(SemanticIssue(
                    severity=Severity.INFO,
                    rule="SOX-001",
                    message="Verify segregation of duties: creator should not be approver",
                    suggestion="Ensure different actors for transaction creation and approval"
                ))

        # Rule 2: Audit trail requirements
        if 'Delete' in content or 'Update' in content:
            if 'Audit' not in content and 'Log' not in content:
                self.issues.append(SemanticIssue(
                    severity=Severity.WARNING,
                    rule="SOX-002",
                    message="Data modifications should be audited",
                    suggestion="Add audit logging for compliance"
                ))

    def _validate_actor_authorization(self, content: str):
        """Validate actors are authorized for their actions"""

        # Extract process blocks and validate actor-verb combinations
        process_pattern = r'Process\s+\w+\s*\{[^}]*Actors\s*:\s*\[(.*?)\][^}]*\}'
        matches = re.finditer(process_pattern, content, re.DOTALL)

        for match in matches:
            actors_str = match.group(1)
            actors = [a.strip() for a in actors_str.split(',')]
            process_content = match.group(0)

            # Check if actors can perform verbs in this process
            action_pattern = r'-\s+(\w+)'
            actions = re.findall(action_pattern, process_content)

            for actor in actors:
                if actor in self.actor_verbs:
                    allowed_verbs = set(self.actor_verbs[actor])
                    for action in actions:
                        if action in self.dictionary['domain']['verbs']:
                            if action not in allowed_verbs:
                                self.issues.append(SemanticIssue(
                                    severity=Severity.ERROR,
                                    rule="AUTH-001",
                                    message=f"Actor '{actor}' not authorized for verb '{action}'",
                                    suggestion=f"Allowed verbs for {actor}: {', '.join(sorted(allowed_verbs)[:5])}..."
                                ))

    def _validate_sensitive_data_handling(self, content: str):
        """Validate sensitive banking data is properly protected"""

        sensitive_fields = ['SSN', 'TIN', 'AccountNumber', 'RoutingNumber', 'IBAN', 'SWIFT']

        for field in sensitive_fields:
            if field in content:
                # Check if marked as encrypted or masked
                if 'encrypted' not in content.lower() and 'masked' not in content.lower():
                    self.issues.append(SemanticIssue(
                        severity=Severity.WARNING,
                        rule="DATA-001",
                        message=f"Sensitive field '{field}' should be encrypted or masked",
                        suggestion="Add encryption or masking to sensitive data fields"
                    ))

    def _validate_transaction_integrity(self, content: str):
        """Validate transaction integrity constraints"""

        # Rule 1: Transactions should be atomic
        if 'Transaction' in content or 'Transfer' in content:
            if 'Rollback' not in content and 'Compensate' not in content:
                self.issues.append(SemanticIssue(
                    severity=Severity.INFO,
                    rule="TXN-001",
                    message="Consider adding rollback/compensation logic for transaction integrity",
                    suggestion="Add error handling with rollback or compensating transactions"
                ))

        # Rule 2: Validate balance checks
        if 'Debit' in content or 'Withdraw' in content:
            if 'CheckBalance' not in content and 'ValidateBalance' not in content:
                self.issues.append(SemanticIssue(
                    severity=Severity.WARNING,
                    rule="TXN-002",
                    message="Debit operations should validate sufficient balance",
                    suggestion="Add balance validation before debit"
                ))

    def _validate_audit_trail(self, content: str):
        """Validate audit trail requirements"""

        # Critical operations must be audited
        critical_ops = ['Transfer', 'Approve', 'Authorize', 'Update', 'Delete']

        for op in critical_ops:
            if op in content:
                if 'Audit' not in content and 'Log' not in content:
                    self.issues.append(SemanticIssue(
                        severity=Severity.WARNING,
                        rule="AUDIT-001",
                        message=f"Critical operation '{op}' should have audit logging",
                        suggestion="Add audit trail for regulatory compliance"
                    ))

    def get_validation_report(self) -> str:
        """Generate formatted validation report"""
        report = []
        report.append("=" * 80)
        report.append("BANKING SEMANTIC VALIDATION REPORT")
        report.append("=" * 80)

        if not self.issues:
            report.append("\n✅ SEMANTIC VALIDATION PASSED - No issues found")
        else:
            # Group by severity
            errors = [i for i in self.issues if i.severity == Severity.ERROR]
            warnings = [i for i in self.issues if i.severity == Severity.WARNING]
            infos = [i for i in self.issues if i.severity == Severity.INFO]

            if errors:
                report.append(f"\n❌ ERRORS ({len(errors)}):")
                for i, issue in enumerate(errors, 1):
                    report.append(f"\n  {i}. [{issue.rule}] {issue.message}")
                    if issue.suggestion:
                        report.append(f"     💡 {issue.suggestion}")

            if warnings:
                report.append(f"\n⚠️  WARNINGS ({len(warnings)}):")
                for i, issue in enumerate(warnings, 1):
                    report.append(f"\n  {i}. [{issue.rule}] {issue.message}")
                    if issue.suggestion:
                        report.append(f"     💡 {issue.suggestion}")

            if infos:
                report.append(f"\nℹ️  INFORMATION ({len(infos)}):")
                for i, issue in enumerate(infos, 1):
                    report.append(f"\n  {i}. [{issue.rule}] {issue.message}")
                    if issue.suggestion:
                        report.append(f"     💡 {issue.suggestion}")

        report.append("\n" + "=" * 80)
        return "\n".join(report)


def validate_banking_semantics(ebl_file_path: str, dictionary_path: str) -> bool:
    """
    Convenience function to validate banking EBL semantics

    Args:
        ebl_file_path: Path to .ebl file
        dictionary_path: Path to banking dictionary JSON

    Returns:
        True if valid (no errors), False otherwise
    """
    validator = BankingSemanticValidator(dictionary_path)

    with open(ebl_file_path, 'r') as f:
        content = f.read()

    is_valid = validator.validate(content)
    print(validator.get_validation_report())

    return is_valid


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 3:
        print("Usage: python semantic_validator.py <ebl_file> <dictionary_json>")
        sys.exit(1)

    ebl_file = sys.argv[1]
    dict_file = sys.argv[2]

    is_valid = validate_banking_semantics(ebl_file, dict_file)
    sys.exit(0 if is_valid else 1)
