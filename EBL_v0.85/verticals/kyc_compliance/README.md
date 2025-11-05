# KYC & Compliance Vertical - Archailign Business Engineering EBL v0.85

## Overview

The **KYC & Compliance vertical** provides EBL definitions for Know Your Customer (KYC) onboarding, identity verification, compliance workflows, and governance controls including Segregation of Duties (SoD).

## Directory Structure

```
kyc_compliance/
├── README.md                                # This file
├── examples/                                # KYC/Compliance EBL examples
│   ├── KYC_Onboarding.ebl                  # Customer onboarding workflow
│   ├── KYC_Verb_NeverPermitted.ebl         # Validation demonstration
│   └── Governance_SoD_Traceability.ebl     # SoD controls
├── dictionary/                              # Domain vocabulary
│   └── kyc_compliance_dictionary_v0.85.json
└── data_model/
    ├── kyc_compliance_erm_base.sql
    └── kyc_compliance_erm_extended.sql
```

## Domain Dictionary

### Actors
- **Customer** - Individual being onboarded
- **Registrar** - Initial data capture
- **KYCAnalyst** - Identity verification specialist
- **ComplianceOfficer** - Final approval authority
- **Auditor** - Compliance reviewer
- **RiskManager** - Risk assessment

### Key Verbs
- **Capture** (write) - Collect customer data
- **Verify** (read) - Validate identity documents
- **Screen** (read) - Check against watchlists
- **Approve** (write) - Authorize customer onboarding
- **Reject** (write) - Decline application
- **Review** (read) - Audit compliance
- **Escalate** (write) - Raise to higher authority

### Key Entities
- KYCApplication, Customer, IdentityDocument
- VerificationResult, ScreeningResult
- ComplianceRecord, AuditTrail
- RiskProfile, ApprovalDecision

## Examples

### 1. KYC_Onboarding.ebl
**Purpose:** Complete customer onboarding with KYC compliance

**Workflow:**
```
Customer Submit → Registrar Capture → KYCAnalyst Verify
→ KYCAnalyst Screen → ComplianceOfficer Approve
```

**Key Features:**
- Document collection (passport, utility bills, etc.)
- Identity verification (ID validation, liveness check)
- Watchlist screening (PEP, sanctions, adverse media)
- Risk-based decisioning
- Audit trail maintenance

**Compliance Checks:**
```ebl
Rule PEPScreening {
  Trigger: Application.Status changes to InReview
  Conditions:
    - Customer.CountryOfResidence IN high_risk_list
    - Customer.PEPStatus == Unknown
  Actions:
    - KYCAnalyst Screen for PEP via DO_ScreeningService
    - Log PEPScreeningAttempt
}
```

### 2. KYC_Verb_NeverPermitted.ebl
**Purpose:** Demonstrates validation warnings

**What it shows:**
- Actor using non-whitelisted verb triggers warning
- Example of validation system catching permission violations
- Helps developers understand dictionary enforcement

### 3. Governance_SoD_Traceability.ebl
**Purpose:** Segregation of Duties controls

**Features:**
- SoD relationship enforcement
- Role-based access controls
- Approval workflows with maker-checker
- Traceability of who did what when

**SoD Rules:**
```ebl
Relationship SoD_Approval {
  From: TransactionInitiator
  To: TransactionApprover
  Type: segregation_of_duties
}

Rule MakerCheckerEnforcement {
  Trigger: Transaction.Status changes to PendingApproval
  Validation:
    - Transaction.InitiatedBy != Transaction.ApprovedBy
  Actions:
    - IF validation fails THEN Reject transaction
    - Log SoDViolation
}
```

## Data Model Extensions

### KYC-Specific Tables

```sql
-- KYC Applications
CREATE TABLE KYCApplication (
    ApplicationID UUID PRIMARY KEY,
    CustomerID UUID,
    SubmissionDate TIMESTAMP,
    Status VARCHAR(50),
    RiskLevel VARCHAR(20),
    ApprovedBy VARCHAR(100),
    ApprovalDate TIMESTAMP
);

-- Identity Documents
CREATE TABLE IdentityDocument (
    DocumentID UUID PRIMARY KEY,
    ApplicationID UUID REFERENCES KYCApplication(ApplicationID),
    DocumentType VARCHAR(50),  -- Passport, DriversLicense, etc.
    DocumentNumber VARCHAR(100),
    IssueDate DATE,
    ExpiryDate DATE,
    VerificationStatus VARCHAR(20),
    VerifiedBy VARCHAR(100),
    VerifiedDate TIMESTAMP
);

-- Screening Results
CREATE TABLE ScreeningResult (
    ScreeningID UUID PRIMARY KEY,
    ApplicationID UUID REFERENCES KYCApplication(ApplicationID),
    ScreeningType VARCHAR(50),  -- PEP, Sanctions, AdverseMedia
    Result VARCHAR(20),          -- Pass, Fail, Review
    MatchDetails JSON,
    ScreenedBy VARCHAR(100),
    ScreenedDate TIMESTAMP
);

-- Segregation of Duties Log
CREATE TABLE SoDLog (
    LogID UUID PRIMARY KEY,
    EntityType VARCHAR(50),
    EntityID UUID,
    ActionType VARCHAR(50),
    Actor1 VARCHAR(100),
    Actor2 VARCHAR(100),
    Relationship VARCHAR(100),
    ViolationDetected BOOLEAN,
    Timestamp TIMESTAMP
);
```

## Regulatory Compliance

### Global Regulations
- **FATF** - Financial Action Task Force recommendations
- **EU AML Directives** - 4th, 5th, 6th AML Directives
- **BSA/AML** - US Bank Secrecy Act
- **KYC Guidelines** - Basel Committee standards

### Regional Requirements
- **GDPR** - EU data privacy (right to be forgotten, consent)
- **CCPA** - California Consumer Privacy Act
- **PDPA** - Singapore Personal Data Protection Act
- **POPIA** - South Africa Protection of Personal Information Act

### Industry Standards
- **SWIFT KYC Registry** - Financial institution KYC
- **ISO 20022** - Financial services messaging
- **GLEIF** - Legal Entity Identifier system

## Validation Examples

```bash
# Validate KYC onboarding
python ../../ebl_validator.py \
  dictionary/kyc_compliance_dictionary_v0.85.json \
  examples/KYC_Onboarding.ebl

# Expected: ✅ 4 actors validated, 4 actions with permissions

# Validate SoD example
python ../../ebl_validator.py \
  dictionary/kyc_compliance_dictionary_v0.85.json \
  examples/Governance_SoD_Traceability.ebl

# Intentional warning example
python ../../ebl_validator.py \
  dictionary/kyc_compliance_dictionary_v0.85.json \
  examples/KYC_Verb_NeverPermitted.ebl

# Expected: ⚠ Warning about unused actor (demonstrates linting)
```

## Integration Points

### KYC Providers
- **Jumio** - Identity verification
- **Onfido** - Document authentication
- **ComplyAdvantage** - Watchlist screening
- **Trulioo** - Global identity verification
- **LexisNexis** - Risk assessment

### Workflow Systems
- **Camunda** - BPM for approval workflows
- **Pega** - Case management
- **ServiceNow** - Compliance tracking

### Data Sources
- **OFAC SDN List** - Sanctions screening
- **World-Check** - PEP and sanctions database
- **Dow Jones Watchlist** - Risk intelligence

## Best Practices

### Data Retention
- Retain KYC records for 5-7 years (varies by jurisdiction)
- Secure deletion after retention period
- Encrypted storage for PII
- Access logging and audit trails

### Risk-Based Approach
- **Low Risk:** Simplified due diligence
- **Medium Risk:** Standard KYC
- **High Risk:** Enhanced due diligence (EDD)
- **PEP:** Always enhanced due diligence

### Continuous Monitoring
- Periodic KYC refresh (annually or bi-annually)
- Transaction monitoring for behavioral changes
- Adverse media scanning
- Automated watchlist screening

## Getting Started

1. **Understand Regulatory Requirements**
   ```bash
   # Review your jurisdiction's KYC/AML requirements
   # Configure risk levels and screening thresholds
   ```

2. **Deploy KYC Workflow**
   ```bash
   # Set up identity verification providers
   # Configure watchlist screening
   # Implement approval workflows
   ```

3. **Enable Audit Logging**
   ```bash
   # Deploy SoD logging
   # Configure compliance dashboards
   # Set up regulatory reporting
   ```

## Resources

- [KYC Dictionary](dictionary/kyc_compliance_dictionary_v0.85.json)
- [Main Documentation](../../README.md)
- [FATF Recommendations](https://www.fatf-gafi.org/)
- [GDPR Guidelines](https://gdpr.eu/)

---

**Version:** 0.85
**Compliance:** FATF, BSA/AML, GDPR, KYC Standards
**Last Updated:** 05-11-2025
