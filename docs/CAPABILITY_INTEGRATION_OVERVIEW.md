# EBL Capability Integration - ArchiMate Alignment

**Date**: 05-11-2025
**Status**: Proposed Changes
**Impact**: Data Model + All EBL Files Across Verticals

---

## Executive Summary

This document proposes enhancements to the EBL architecture to properly integrate **Capabilities** as first-class citizens in the traceability model, aligned with ArchiMate 3.1 specifications. Currently, Capabilities exist in the data model but are not properly linked to Business Objectives and Goals, and are not referenced in EBL file metadata.

**Key Changes**:
1. Add Capability-to-Objective and Capability-to-Goal relationships in data model
2. Add **CapabilityID** field to EBL file Metadata sections
3. Ensure Requirements reference Capabilities (already exists via Requirement_Capability table)
4. Establish complete traceability: Goal → Objective → Capability → Requirement → Process

---

## Current State Analysis

### Data Model - UUID Schema

#### ✅ What Exists
```sql
-- Capability Table (Lines 88-100)
CREATE TABLE Capability (
    ID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    OutcomeDescription TEXT,
    MaturityLevel VARCHAR(50),
    Owner UUID,
    ProjectID UUID NOT NULL,  -- Links to Project
    FOREIGN KEY (ProjectID) REFERENCES Project(ID) ON DELETE CASCADE
);

-- Requirement_Capability (Lines 102-109) ✅
CREATE TABLE Requirement_Capability (
    RequirementID UUID,
    CapabilityID UUID,
    FOREIGN KEY (RequirementID) REFERENCES Requirement(ID),
    FOREIGN KEY (CapabilityID) REFERENCES Capability(ID)
);

-- BusinessProcess_Capability (Lines 111-118) ✅
CREATE TABLE BusinessProcess_Capability (
    BusinessProcessID UUID,
    CapabilityID UUID,
    FOREIGN KEY (BusinessProcessID) REFERENCES BusinessProcess(ID),
    FOREIGN KEY (CapabilityID) REFERENCES Capability(ID)
);
```

#### ❌ What's Missing
1. **NO direct link from Capability to Objective** (violates ArchiMate "realizes" relationship)
2. **NO direct link from Capability to BusinessGoal** (missing strategic alignment)
3. **Capability only links to Project**, not to strategic elements

### Data Model - INT Schema

#### Current State (Lines 119-134)
```sql
CREATE TABLE Capability (
    CapabilityID INT PRIMARY KEY AUTO_INCREMENT,
    ProjectID INT NOT NULL,
    RequirementID INT NOT NULL,  -- ONE-TO-MANY (too restrictive)
    Name VARCHAR(255) NOT NULL,
    ...
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID),
    FOREIGN KEY (RequirementID) REFERENCES Requirement(RequirementID)
);
```

#### Issues
- **RequirementID as FK** makes it one-to-many (one Capability, one Requirement only)
- Should be many-to-many via junction table (multiple Requirements can share a Capability)
- Still missing Capability → Objective and Capability → BusinessGoal links

### EBL Files - All Verticals

#### Current Metadata Structure
```ebl
Metadata:
  EBLClass: MortgageOriginationWorkflow
  RequirementID: REQ-BAIN-MLO-001
  ProjectID: PRJ-BAIN-MORTGAGE-2025
  BusinessUnit: ResidentialLending
  Owner: ChiefLendingOfficer
  CreatedAt: 05-11-2025
  UpdatedAt: 05-11-2025
  Version: 0.85
```

#### ❌ What's Missing
- **NO CapabilityID** field in Metadata

#### Current Process Structure
```ebl
Process MortgageLoanOriginationWorkflow {
  Description: "..."
  ObjectiveID: OBJ-BAIN-MLO-001     ✅ Present
  BusinessGoalID: BG-BAIN-GROWTH-2025  ✅ Present
  Actors: [...]
  erMap: MortgageLoanOriginationProcess
  ...
}
```

#### Issue
- Process links to ObjectiveID and BusinessGoalID ✅
- But **NO explicit Capability reference** to show which capabilities the process uses

---

## ArchiMate 3.1 Alignment

### Core Relationships (ArchiMate Spec)

```
                    ┌─────────────────┐
                    │ BusinessGoal    │
                    └────────┬────────┘
                             │ influences
                    ┌────────▼────────┐
                    │  Objective      │
                    └────────┬────────┘
                             │ realized-by
                    ┌────────▼────────┐
                    │   Capability    │◄──────────┐
                    └────────┬────────┘           │
                             │ realizes           │ serves
                    ┌────────▼────────┐  ┌────────┴────────┐
                    │  Requirement    │  │ BusinessProcess │
                    └─────────────────┘  └─────────────────┘
```

### ArchiMate Relationship Types

| Relationship | From | To | Meaning |
|--------------|------|----|---------  |
| **Realization** | Capability | Objective | Capability realizes business objective |
| **Association** | Capability | BusinessGoal | Capability supports strategic goal |
| **Realization** | Requirement | Capability | Requirement realizes/implements capability |
| **Serving** | Capability | BusinessProcess | Capability serves/enables process |
| **Assignment** | Resource/Application | Capability | Tech asset assigned to capability |

---

## Proposed Changes

### 1. Data Model Enhancements

#### UUID Schema - Add These Tables

```sql
-- Capability_Objective (Many-to-Many)
-- One Capability can realize multiple Objectives
CREATE TABLE Capability_Objective (
    CapabilityID UUID,
    ObjectiveID UUID,
    RealizationLevel VARCHAR(50) CHECK (RealizationLevel IN ('Primary', 'Supporting', 'Enabling')),
    PRIMARY KEY (CapabilityID, ObjectiveID),
    FOREIGN KEY (CapabilityID) REFERENCES Capability(ID) ON DELETE CASCADE,
    FOREIGN KEY (ObjectiveID) REFERENCES Objective(ID) ON DELETE CASCADE
);

-- Capability_BusinessGoal (Many-to-Many)
-- One Capability can support multiple Business Goals
CREATE TABLE Capability_BusinessGoal (
    CapabilityID UUID,
    BusinessGoalID UUID,
    ContributionType VARCHAR(50) CHECK (ContributionType IN ('Direct', 'Indirect', 'Enabling')),
    PRIMARY KEY (CapabilityID, BusinessGoalID),
    FOREIGN KEY (CapabilityID) REFERENCES Capability(ID) ON DELETE CASCADE,
    FOREIGN KEY (BusinessGoalID) REFERENCES BusinessGoal(ID) ON DELETE CASCADE
);

-- Add Indexes for Performance
CREATE INDEX idx_capability_objective ON Capability_Objective(ObjectiveID);
CREATE INDEX idx_capability_businessgoal ON Capability_BusinessGoal(BusinessGoalID);
```

#### INT Schema - Changes

```sql
-- Remove RequirementID FK from Capability table (move to junction)
ALTER TABLE Capability DROP FOREIGN KEY Capability_ibfk_2;
ALTER TABLE Capability DROP COLUMN RequirementID;

-- Add Capability_Requirement junction table (if not exists)
CREATE TABLE Capability_Requirement (
    CapabilityID INT,
    RequirementID INT,
    RealizationType VARCHAR(50) CHECK (RealizationType IN ('Implements', 'Supports', 'Enables')),
    PRIMARY KEY (CapabilityID, RequirementID),
    FOREIGN KEY (CapabilityID) REFERENCES Capability(CapabilityID) ON DELETE CASCADE,
    FOREIGN KEY (RequirementID) REFERENCES Requirement(RequirementID) ON DELETE CASCADE
);

-- Add Capability_Objective junction
CREATE TABLE Capability_Objective (
    CapabilityID INT,
    ObjectiveID INT,
    RealizationLevel ENUM('Primary', 'Supporting', 'Enabling') NOT NULL,
    PRIMARY KEY (CapabilityID, ObjectiveID),
    FOREIGN KEY (CapabilityID) REFERENCES Capability(CapabilityID) ON DELETE CASCADE,
    FOREIGN KEY (ObjectiveID) REFERENCES Objective(ObjectiveID) ON DELETE CASCADE
);

-- Add Capability_BusinessGoal junction
CREATE TABLE Capability_BusinessGoal (
    CapabilityID INT,
    GoalID INT,
    ContributionType ENUM('Direct', 'Indirect', 'Enabling') NOT NULL,
    PRIMARY KEY (CapabilityID, GoalID),
    FOREIGN KEY (CapabilityID) REFERENCES Capability(CapabilityID) ON DELETE CASCADE,
    FOREIGN KEY (GoalID) REFERENCES BusinessGoal(GoalID) ON DELETE CASCADE
);
```

### 2. EBL Metadata Changes

#### Required Addition to ALL .ebl Files

```ebl
Metadata:
  EBLClass: MortgageOriginationWorkflow
  RequirementID: REQ-BAIN-MLO-001
  ProjectID: PRJ-BAIN-MORTGAGE-2025
  CapabilityID: CAP-BAIN-MLO-001          # ✅ NEW - REQUIRED
  BusinessUnit: ResidentialLending
  Owner: ChiefLendingOfficer
  ComplianceFrameworks: [TILA, RESPA, HMDA]
  CreatedAt: 05-11-2025
  UpdatedAt: 05-11-2025
  Version: 0.85
```

#### Capability ID Naming Convention

Format: **`CAP-<DOMAIN>-<ID>`**

Examples:
- Banking: `CAP-BAIN-MLO-001` (Mortgage Loan Origination)
- Healthcare: `CAP-HLTH-CTE-001` (Clinical Trial Enrollment)
- Retail: `CAP-RETL-INV-001` (Inventory Management)
- Insurance: `CAP-INSR-CLM-001` (Claims Processing)
- KYC: `CAP-KYC-ONB-001` (Customer Onboarding)
- AdTech: `CAP-ADTC-CAM-001` (Campaign Management)
- Logistics: `CAP-LOGI-SHP-001` (Shipment Management)
- IT: `CAP-ITIF-TOP-001` (IT Topology Management)

### 3. Optional: Capability Block in Process

For explicit capability declaration within processes:

```ebl
Process MortgageLoanOriginationWorkflow {
  Description: "..."
  ObjectiveID: OBJ-BAIN-MLO-001
  BusinessGoalID: BG-BAIN-GROWTH-2025
  CapabilityID: CAP-BAIN-MLO-001              # ✅ NEW - Explicit capability reference

  Capabilities:                                # ✅ NEW - Optional capabilities used
    - CAP-BAIN-CREDIT-001: Credit Assessment
    - CAP-BAIN-UNDERWRT-001: Loan Underwriting
    - CAP-BAIN-COMPLY-001: Regulatory Compliance

  Actors: [...]
  erMap: MortgageLoanOriginationProcess
  ...
}
```

---

## Impact Analysis

### Files Requiring Changes

#### Data Model Files (2 files)
- `/docs/data_model/entity_relationship_model.txt` - Add 2 new junction tables
- `/docs/data_model/erm_schema.txt` - Add 3 new junction tables, alter Capability table

#### EBL Example Files (All Verticals)

**Banking** (3 files):
- `verticals/banking/examples/MortgageLoanApplication.ebl` - Add CapabilityID
- `verticals/banking/examples/AFC_Fraud_SAR.ebl` - Add CapabilityID
- `verticals/banking/examples/Payments_Screening.ebl` - Add CapabilityID

**Healthcare** (2 files):
- `verticals/healthcare/examples/ClinicalTrialEnrollment.ebl` - Add CapabilityID
- `verticals/healthcare/examples/Healthcare_Patient_SAE.ebl` - Add CapabilityID

**Insurance** (1 file):
- `verticals/insurance/examples/Insurance_ClaimLifecycle.ebl` - Add CapabilityID

**KYC Compliance** (1 file):
- `verticals/kyc_compliance/examples/KYC_Onboarding.ebl` - Add CapabilityID

**Retail** (1 file):
- `verticals/retail/examples/InventoryReplenishment.ebl` - Add CapabilityID

**AdTech** (1 file):
- `verticals/adtech/examples/AdCampaignManagement.ebl` - Add CapabilityID

**Logistics** (if exists):
- Check for examples and add CapabilityID

**IT Infrastructure** (1 file):
- `verticals/it_infrastructure/examples/IT-TopologyRelationships.ebl` - Add CapabilityID

**Total**: ~12-15 .ebl files across 8 verticals

### Documentation Files Requiring Updates

- `docs/ebl-classes.md` - Add Capability class documentation
- `docs/ebl-overview.md` - Update traceability section
- `docs/data_model/README.md` - Document new relationships
- `GETTING_STARTED.md` - Update examples with CapabilityID
- `EBL_v0.85/HOWTO.md` - Update quick reference

---

## Traceability Benefits

### Before (Current State)
```
BusinessGoal
    └─ Objective
           └─ BusinessProcess
                  └─ Requirement
                         └─ EBLClass
                                └─ DataObject

Capability (isolated, only links to Project)
```

**Problem**: Cannot trace which Capabilities realize which Objectives/Goals

### After (Proposed)
```
BusinessGoal
    ├─ Objective
    │      ├─ Capability (realizes objective)
    │      │      ├─ Requirement (implements capability)
    │      │      ├─ BusinessProcess (uses capability)
    │      │      ├─ Application (provides capability)
    │      │      └─ DataObject (supports capability)
    │      └─ BusinessProcess
    │             └─ Requirement
    └─ Capability (supports goal)

EBL File Metadata → CapabilityID → Capability Table → Objective/Goal
```

**Benefit**: Complete end-to-end traceability from strategy to implementation

---

## ArchiMate Model Generation

With these changes, EBL can generate complete ArchiMate models:

```xml
<!-- ArchiMate Export Example -->
<element xsi:type="Capability" id="CAP-BAIN-MLO-001" name="Mortgage Loan Origination">
  <property key="maturity" value="Mature"/>
  <property key="owner" value="ChiefLendingOfficer"/>
</element>

<element xsi:type="Objective" id="OBJ-BAIN-MLO-001" name="Streamline Loan Approval"/>

<relationship xsi:type="Realization" source="CAP-BAIN-MLO-001" target="OBJ-BAIN-MLO-001">
  <property key="realizationLevel" value="Primary"/>
</relationship>
```

---

## Implementation Recommendations

### Phase 1: Data Model (Week 1)
1. Create new junction tables in both UUID and INT schemas
2. Update data model README with new relationships
3. Run validation scripts to ensure referential integrity

### Phase 2: EBL Files - Banking Vertical (Week 1)
1. Add CapabilityID to all 3 Banking examples
2. Define capability IDs following naming convention
3. Test validators with new metadata field

### Phase 3: EBL Files - All Other Verticals (Week 2)
1. Add CapabilityID to Healthcare, Insurance, Retail examples
2. Add CapabilityID to KYC, AdTech, Logistics, IT examples
3. Update all vertical README files

### Phase 4: Documentation (Week 2)
1. Update ebl-classes.md with Capability documentation
2. Update ebl-overview.md with traceability diagrams
3. Update GETTING_STARTED.md with new examples
4. Create Capability modeling guidelines

### Phase 5: Validation & Testing (Week 3)
1. Update validators to require CapabilityID in Metadata
2. Add semantic validation for Capability → Objective → Goal links
3. Test ArchiMate model generation with new relationships
4. Create sample queries demonstrating traceability

---

## Example: Complete Traceability Query

With these changes, you can query the complete chain:

```sql
-- Find all Capabilities that realize a specific Business Goal
SELECT
    bg.Name AS BusinessGoal,
    o.Name AS Objective,
    c.Name AS Capability,
    r.Description AS Requirement,
    bp.Name AS BusinessProcess,
    app.Name AS Application
FROM BusinessGoal bg
JOIN Objective o ON o.BusinessGoalID = bg.ID
JOIN Capability_Objective co ON co.ObjectiveID = o.ID
JOIN Capability c ON c.ID = co.CapabilityID
JOIN Requirement_Capability rc ON rc.CapabilityID = c.ID
JOIN Requirement r ON r.ID = rc.RequirementID
JOIN BusinessProcess bp ON bp.ID = r.BusinessProcessID
JOIN Capability_Application ca ON ca.CapabilityID = c.ID
JOIN Application app ON app.ID = ca.ApplicationID
WHERE bg.Name = 'Increase Mortgage Origination Volume by 25%';
```

Result:
```
BusinessGoal: Increase Mortgage Origination Volume by 25%
  ├─ Objective: Streamline Loan Approval Process
  │      └─ Capability: Mortgage Loan Origination (CAP-BAIN-MLO-001)
  │             ├─ Requirement: REQ-BAIN-MLO-001 (Automated credit decisioning)
  │             ├─ BusinessProcess: MortgageLoanOriginationWorkflow
  │             └─ Application: Encompass LOS, Credit Bureau API
```

---

## Compliance & Governance Benefits

### 1. Regulatory Traceability
- **PCI-DSS**: Trace card encryption capability to payment processing requirements
- **HIPAA**: Trace PHI protection capability to clinical trial processes
- **SOX**: Trace dual authorization capability to wire transfer controls

### 2. Impact Analysis
- **Question**: "Which capabilities are affected if Objective OBJ-BAIN-001 changes?"
- **Answer**: Query Capability_Objective table → find all dependent capabilities

### 3. Capability Maturity Assessment
- **Question**: "Which immature capabilities support critical business goals?"
- **Answer**: Query Capability table WHERE MaturityLevel = 'Conceptual' AND linked to high-priority goals

### 4. Audit Trails
- Every EBL file now explicitly declares its capability context
- Can trace from deployed code → EBL file → CapabilityID → Objective → Goal
- Complete lineage for regulatory audits

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Breaking changes to existing EBL files | Medium | Add CapabilityID as optional initially, make required in v0.86 |
| Data model migration complexity | Medium | Provide SQL migration scripts for both UUID and INT schemas |
| Validator updates required | Low | Add CapabilityID to schema, update validation rules |
| Documentation overhead | Low | Spread updates across 2-3 weeks |
| ArchiMate tool compatibility | Low | Test with open-source Archi tool first |

---

## Success Criteria

1. ✅ All EBL files have CapabilityID in Metadata
2. ✅ Data model has Capability_Objective and Capability_BusinessGoal tables
3. ✅ Can query complete traceability chain: Goal → Objective → Capability → Requirement
4. ✅ Validators enforce CapabilityID presence
5. ✅ Documentation updated across all files
6. ✅ ArchiMate export includes Capability realization relationships
7. ✅ Sample queries demonstrate end-to-end traceability

---

## References

- **ArchiMate 3.1 Specification** - Capability modeling and relationships
- **TOGAF Capability-Based Planning** - Capability definition and maturity
- **EBL v0.85 Specification** - Current metadata and class definitions
- **Data Model Documentation** - docs/data_model/README.md

---

**Prepared by**: EBL Architecture Team
**Review Date**: 05-11-2025
**Next Review**: After Phase 1 completion

---

## Appendix A: Capability Examples by Vertical

### Banking
- **CAP-BAIN-MLO-001**: Mortgage Loan Origination
- **CAP-BAIN-CREDIT-001**: Credit Risk Assessment
- **CAP-BAIN-FRAUD-001**: Fraud Detection & Prevention
- **CAP-BAIN-COMPLY-001**: Regulatory Compliance Management
- **CAP-BAIN-PAYMENT-001**: Payment Processing & Screening

### Healthcare
- **CAP-HLTH-CTE-001**: Clinical Trial Enrollment
- **CAP-HLTH-SAE-001**: Serious Adverse Event Reporting
- **CAP-HLTH-CONSENT-001**: Informed Consent Management
- **CAP-HLTH-HIPAA-001**: HIPAA Privacy & Security

### Retail
- **CAP-RETL-INV-001**: Inventory Management
- **CAP-RETL-ORDER-001**: Order Fulfilment
- **CAP-RETL-PRICE-001**: Dynamic Pricing

### Insurance
- **CAP-INSR-CLM-001**: Claims Processing
- **CAP-INSR-UNDERWRT-001**: Risk Underwriting
- **CAP-INSR-FRAUD-001**: Claims Fraud Detection

---

**Status**: ✅ Ready for Review and Approval
