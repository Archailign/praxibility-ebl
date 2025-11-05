# Banking & Financial Services Vertical - Archailign Business Engineering EBL v0.85

## Overview

The **Banking vertical** provides EBL definitions for financial services including lending, payments, anti-financial crime (AFC), and regulatory compliance. This vertical covers mortgage processing, payment screening, fraud detection, and suspicious activity reporting.

## Directory Structure

```
banking/
├── README.md                            # This file
├── examples/                            # Banking EBL examples
│   ├── MortgageLoanApplication.ebl     # Loan processing workflow
│   ├── Payments_Screening.ebl          # Payment sanctions screening
│   └── AFC_Fraud_SAR.ebl              # Fraud detection & SAR filing
├── dictionary/                          # Domain vocabulary
│   └── banking_dictionary_v0.85.json   # Banking-specific actors/verbs
└── data_model/                          # Database schemas
    ├── banking_erm_base.sql            # UUID-based schema
    └── banking_erm_extended.sql        # INT-based with compliance tracking
```

## Domain Dictionary

### Actors
- **Borrower** - Loan applicant
- **Broker** - Mortgage broker
- **Underwriter** - Loan risk assessor
- **Lender** - Loan approval authority
- **ComplianceOfficer** - Regulatory compliance reviewer
- **FraudAnalyst** - Suspicious activity investigator
- **PaymentProcessor** - Payment execution handler

### Key Verbs
- **Apply** (write) - Submit application
- **Assess** (read) - Evaluate risk
- **Approve** (write) - Authorize transaction
- **Reject** (write) - Decline request
- **Disburse** (write) - Release funds
- **Screen** (read) - Check against sanctions lists
- **Report** (write) - File regulatory reports
- **Investigate** (read) - Examine suspicious activity

### Key Entities
- LoanApplication, Borrower, Property, CreditReport
- Payment, Transaction, Account
- SuspiciousActivity, SAR (Suspicious Activity Report)
- SanctionsList, WatchlistMatch

## Examples

### 1. MortgageLoanApplication.ebl
**Purpose:** End-to-end mortgage loan processing

**Features:**
- Applicant data collection
- Credit score validation
- LTV (Loan-to-Value) ratio calculation
- Risk assessment and underwriting
- Regulatory compliance checks

**Key Business Rules:**
```ebl
Rule MortgageApproval {
  Trigger: Application.Status changes to UnderReview
  Conditions:
    - CreditScore >= 680
    - LTV <= 0.95
    - Income verification complete
  Actions:
    - Underwriter Approve application
}
```

### 2. Payments_Screening.ebl
**Purpose:** Real-time payment sanctions screening

**Features:**
- OFAC sanctions list screening
- PEP (Politically Exposed Persons) checks
- Watchlist matching
- Transaction blocking for hits

### 3. AFC_Fraud_SAR.ebl
**Purpose:** Anti-Financial Crime and SAR filing

**Features:**
- Transaction monitoring
- Anomaly detection
- Case investigation
- SAR filing workflow

## Data Model Extensions

### Banking-Specific Tables

```sql
-- Loan Applications
CREATE TABLE LoanApplication (
    ApplicationID UUID PRIMARY KEY,
    BorrowerID UUID,
    LoanAmount DECIMAL(15,2),
    PropertyValue DECIMAL(15,2),
    LTV DECIMAL(5,4),  -- Loan-to-Value ratio
    CreditScore INTEGER,
    Status VARCHAR(50),
    DecisionDate DATE
);

-- Payment Screening
CREATE TABLE PaymentScreening (
    ScreeningID UUID PRIMARY KEY,
    PaymentID UUID,
    ScreeningType VARCHAR(50),
    Result VARCHAR(20),
    MatchDetails JSON,
    ReviewedBy VARCHAR(100),
    ReviewDate TIMESTAMP
);

-- Suspicious Activity Reports
CREATE TABLE SuspiciousActivityReport (
    SARID UUID PRIMARY KEY,
    AccountID UUID,
    ActivityDate DATE,
    ActivityType VARCHAR(100),
    AmountUSD DECIMAL(15,2),
    Narrative TEXT,
    FiledDate DATE,
    RegulatoryBody VARCHAR(100)
);
```

## Regulatory Compliance

### Required Validations
1. **KYC/AML** - Know Your Customer and Anti-Money Laundering
2. **OFAC Screening** - Office of Foreign Assets Control sanctions
3. **BSA Compliance** - Bank Secrecy Act reporting
4. **Fair Lending** - Equal Credit Opportunity Act
5. **Data Privacy** - GDPR, GLBA compliance

### Reporting Requirements
- SAR filing within 30 days of detection
- Currency Transaction Reports (CTR) for amounts > $10,000
- Suspicious pattern reporting
- Audit trail retention (7 years minimum)

## Validation Example

```bash
# Validate mortgage application workflow
python ../../ebl_validator.py \
  dictionary/banking_dictionary_v0.85.json \
  examples/MortgageLoanApplication.ebl

# Validate payment screening
python ../../ebl_validator.py \
  dictionary/banking_dictionary_v0.85.json \
  examples/Payments_Screening.ebl
```

## Integration Points

### Core Banking Systems
- **Loan Origination System (LOS)** - Application processing
- **Core Banking Platform** - Account management
- **Payment Gateway** - Transaction processing
- **Compliance Platform** - Screening and monitoring

### External Services
- **Credit Bureaus** - Experian, Equifax, TransUnion
- **OFAC API** - Sanctions screening
- **FinCEN** - SAR filing
- **Property Valuation Services**

## Getting Started

1. **Review Regulatory Requirements**
   - Understand BSA, AML, OFAC compliance
   - Review fair lending guidelines

2. **Explore Examples**
   ```bash
   cd verticals/banking/examples
   cat MortgageLoanApplication.ebl
   ```

3. **Implement Screening**
   - Deploy sanctions screening logic
   - Configure watchlist sources
   - Set up alert thresholds

## Resources

- [Banking Dictionary](dictionary/banking_dictionary_v0.85.json)
- [Main Documentation](../../README.md)
- [Regulatory Guidelines](https://www.fincen.gov/)

---

**Version:** 0.85
**Regulatory Compliance:** BSA, AML, OFAC, Fair Lending
**Last Updated:** 05-11-2025
