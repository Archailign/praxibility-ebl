# Enterprise Business Lexicon (EBL)

*A compact, encyclopedic dictionary of business-requirements terms designed to support an ANTLR grammar for the Enterprise Business Language (EBL).*

---

## 1) Purpose & Scope
The EBL dictionary standardises business terminology—actors, events, processes, data, rules, metrics—so natural business sentences can be parsed, compiled or interpreted into data and architectural models. It is domain-agnostic with annexes for specific industries. The dictionary aligns to common architecture meta-models (e.g., ArchiMate) and is intended to be the authoritative lexicon for EBL grammar construction.

**Intended uses**
- Constrain vocabulary for controlled natural language
- Map business statements to tokens/nonterminals in an ANTLR grammar
- Generate enterprise models (capabilities, processes, data, services, policies)
- Drive code/artifact generation (schemas, APIs, workflows, IaC)

**Entry structure**
- **Term** — canonical label used in EBL (singular)
- **Category** — one of: *Actor, Role, System, Capability, Process, Task, Action, Event, State, Entity, Attribute, Relationship, Rule, Policy, Constraint, Requirement, Metric, Measure, SLA, Risk, Control, Decision, DataType, Identifier, Location, Channel, Time, Unit*.
- **Definition** — normative description
- **Aliases** — accepted synonyms (optional)
- **Grammar** — suggested token class / hints for ANTLR
- **Example (EBL)** — short, parsable example using the term
- **Notes** — implementation guidance and modelling tips

---

## 2) Foundational Modelling Concepts
- **Universe of Discourse** *(Scope)* — the bounded domain the model covers.
- **Canonical Term** — the single, preferred label used in EBL; aliases map to it.
- **Identity vs. State** — attributes that uniquely identify an entity vs. mutable properties that can change over time.
- **Event-Condition-Action (ECA)** — rule form: *ON <Event> WHEN <Condition> THEN <Action>.*
- **Modality** — requirement force: *SHALL, MUST NOT, SHOULD, MAY, CAN*.
- **Determinism** — avoid ambiguity; quantify thresholds, units, and time windows.

---

## 3) Core Lexicon (A–Z, grouped)
### 3.1 Actors & Roles
Defines **Actor, Role, Organisation, System, External Party**.

### 3.2 Events & States
Defines **Business Event, Temporal Event, Exception Event, State**.

### 3.3 Processes & Actions
Defines **Capability, Process, Activity, Action, Decision, Workflow**.

### 3.4 Data, Entities & Relationships
Defines **Entity, Attribute, Identifier, Relationship, Reference Data, Derived Measure**.

### 3.5 Rules, Policies & Constraints
Defines **Business Rule, Policy, Constraint, Compliance Requirement, Guard, Exception**.

### 3.6 Metrics & Service Levels
Defines **Metric, SLA, KPI, Unit**.

### 3.7 Time & Temporal Logic
Defines **Time Window, Effective Date, Business Day**.

### 3.8 Risk & Control
Defines **Risk, Control, Audit Trail**.

### 3.9 Channels, Locations & Interfaces
Defines **Channel, Location, Interface**.

---

## 4) Controlled Language Building Blocks (for Grammar)
- Canonical sentence frames (Requirement, Derivation, Rule, Structure, Relationship).
- Modality keywords (SHALL, MUST NOT, SHOULD, MAY, CAN).
- Quantifiers & Comparators.
- Temporal expressions (BY, BEFORE, WITHIN, UNTIL, EVERY, ON).
- Literals & Types (DATE, TIME, DURATION, CURRENCY, PERCENT, ID).

---

## 5) Domain Annexes

### 5.1 Banking — Mortgage
**Core Entities**: Borrower, Co-Borrower, Mortgage Application, Property, Loan Offer, Disbursement, Repayment, Escrow, Valuation, Credit Report.  
**Actors**: Borrower, Broker, Underwriter, Lender, Appraiser, Regulator.  
**Measures**: Loan Amount, Property Value, LTV, DTI, Credit Score, APR, Arrears Age.  
**Events**: Application Received, Credit Check Passed/Failed, Valuation Completed, Offer Issued, Funds Disbursed, Payment Missed.  
**Rules (examples)**:  
- *LTV SHALL NOT exceed 80% for First-Time Buyer.*  
- *Underwriter SHALL obtain Income Verification BEFORE Offer Issued.*  
- *ON Payment Missed WHEN Arrears Age ≥ 30 days THEN Notify Collections.*  
**Controlled Verbs**: Apply, Assess, Approve, Reject, Disburse, Notify.

### 5.2 Pharmaceutical — Clinical Trials
**Core Entities**: Subject, Informed Consent, Screening, Inclusion Criteria, Exclusion Criteria, Randomisation, Visit, Dose, Adverse Event, Serious Adverse Event, Protocol, Site, Investigator, eCRF/EDC.  
**Actors**: Subject, Principal Investigator, Sub-Investigator, CRA/Monitor, Sponsor, IRB/IEC, Pharmacovigilance.  
**Measures**: Age, BMI, Lab Values, AE Severity/Relatedness, Compliance Rate.  
**Events**: Consent Signed, Screening Complete, Randomised, Dose Administered, AE Reported, SAE Reported, Protocol Deviation.  
**Rules (examples)**:  
- *Subject SHALL be Eligible WHEN ALL Inclusion TRUE AND ALL Exclusion FALSE.*  
- *SAE SHALL be reported WITHIN 24h to Sponsor and IRB.*  
- *Medication Accountability SHALL reconcile 100% of dispensed units.*  
**Controlled Verbs**: Consent, Screen, Randomise, Dose, Report, Reconcile.

### 5.3 Retail (CG & FMCG) — Inventory/Replenishment
**Core Entities**: SKU, Product, Supplier, Purchase Order, Sales Order, Forecast, Stock Ledger, Warehouse, Replenishment Plan.  
**Actors**: Inventory Planner, Buyer, Supplier, Warehouse Operative, Store Manager.  
**Measures**: On Hand, On Order, Allocated, Reorder Point (ROP), Safety Stock, Lead Time, Service Level, Fill Rate, Forecast Error.  
**Events**: Sales Posted, Stockout, Goods Received, Stock Adjusted, PO Placed, Backorder Created.  
**Rules (examples)**:  
- *WHEN On Hand + On Order − Allocated ≤ ROP THEN create Purchase Order.*  
- *Target Service Level SHALL be ≥ 95% per SKU per Week.*  
- *Goods Receipt SHALL be recorded WITHIN 2 hours of delivery.*  
**Controlled Verbs**: Forecast, Order, Receive, Replenish, Adjust, Fulfil.

### 5.4 Payments & KYC
**Core Entities**: Payment, Account, Transaction, Customer, Beneficiary, Counterparty, SanctionsList, IdentityDocument, RiskProfile.  
**Actors**: Payer, Payee, Bank, PaymentProcessor, Regulator, ComplianceOfficer.  
**Measures**: TransactionAmount, DailyLimit, RiskRating, FalsePositiveRate.  
**Events**: PaymentInitiated, PaymentSettled, PaymentRejected, IdentityVerified, AlertRaised.  
**Rules (examples)**:  
- *Payment SHALL NOT be released IF Counterparty IN SanctionsList.*  
- *Customer MUST provide Valid ID before Account Opening.*  
- *ON AlertRaised WHEN RiskRating > Threshold THEN escalate to ComplianceOfficer.*  
**Controlled Verbs**: Disburse, Verify, Screen, Approve, Reject, Escalate, Settle.

### 5.5 Insurance — Claims
**Core Entities**: Claim, Policy, Policyholder, Beneficiary, ClaimAssessment, Payment, AdjusterReport.  
**Actors**: Policyholder, ClaimsAdjuster, Underwriter, Regulator.  
**Measures**: ClaimAmount, SettlementAmount, ProcessingTime, FraudScore.  
**Events**: ClaimFiled, ClaimAssessed, ClaimApproved, ClaimRejected, ClaimPaid.  
**Rules (examples)**:  
- *Claim SHALL be acknowledged WITHIN 24h of submission.*  
- *FraudScore > 80 SHALL trigger manual review.*  
- *ON ClaimApproved THEN Disburse SettlementAmount.*  
**Controlled Verbs**: File, Assess, Approve, Reject, Investigate, Disburse.

### 5.6 Manufacturing — MRP (Materials Requirements Planning)
**Core Entities**: BillOfMaterials, Component, WorkOrder, ProductionPlan, Inventory, Supplier, PurchaseOrder.  
**Actors**: ProductionPlanner, Supplier, WarehouseManager, MachineOperator.  
**Measures**: LeadTime, SafetyStock, ROP, UtilisationRate, Yield.  
**Events**: WorkOrderCreated, MaterialShortage, POIssued, GoodsReceived, ProductionCompleted.  
**Rules (examples)**:  
- *WHEN OnHand + OnOrder < ROP THEN generate PurchaseOrder.*  
- *UtilisationRate SHALL NOT exceed 85% for sustained periods.*  
- *ON GoodsReceived THEN Update Inventory.*  
**Controlled Verbs**: Replenish, Manufacture, Assemble, Procure, Schedule, Inspect.

### 5.7 Public Sector — Grants
**Core Entities**: Grant, Application, Applicant, Reviewer, Award, Disbursement, ComplianceReport.  
**Actors**: GrantApplicant, Reviewer, FundingAgency, Auditor.  
**Measures**: GrantAmount, ReviewScore, DisbursementRate, ComplianceScore.  
**Events**: ApplicationSubmitted, ReviewCompleted, AwardGranted, FundsDisbursed, ComplianceCheck.  
**Rules (examples)**:  
- *Applications SHALL be reviewed WITHIN 30 days.*  
- *ON Non-Compliance THEN Suspend Disbursement.*  
- *Reviewer SHALL record ReviewScore BEFORE AwardGranted.*  
**Controlled Verbs**: Apply, Review, Award, Disburse, Suspend, Audit.

### 5.8 Aviation — MRO (Maintenance, Repair & Overhaul)
**Core Entities**: Aircraft, MaintenanceTask, WorkOrder, Part, InspectionReport, FlightLog, Certification.  
**Actors**: MaintenanceEngineer, QualityInspector, AirlineOperator, Regulator, OEM.  
**Measures**: MTBF, Downtime, TAT (Turnaround Time), ComplianceRate.  
**Events**: InspectionScheduled, FaultDetected, WorkOrderIssued, TaskCompleted, AirworthinessCertified.  
**Rules (examples)**:  
- *Inspection SHALL be performed EVERY 500 flight hours.*  
- *TaskCompleted MUST be certified by QualityInspector.*  
- *ON FaultDetected THEN Ground Aircraft.*  
**Controlled Verbs**: Inspect, Repair, Replace, Certify, Log, Ground.

---

## 6) Crosswalk to ArchiMate (for model generation)
- **Actor/Role** → *Business Actor, Business Role*  
- **Process/Activity/Workflow** → *Business Process, Business Function*  
- **Event** → *Business Event*  
- **Entity/Data** → *Business Object / Data Object*  
- **System/Interface** → *Application Component / Application Service / Interface*  
- **Rule/Policy/Constraint** → *Business Rule (Motivation), Constraint*  
- **SLA/KPI/Metric** → *Assessment / Goal*  
- **Risk/Control** → *Risk / Control (extension or Motivation mapping)*

---

## 7) Reserved Keywords (initial set)
`ACTOR, ROLE, SYSTEM, PROCESS, ACTIVITY, ACTION, EVENT, STATE, ENTITY, ATTRIBUTE, IDENTIFIER, RELATES_TO, DEFINE, MEASURE, RULE, POLICY, CONSTRAINT, REQUIREMENT, RISK, CONTROL, KPI, SLA, METRIC, UNIT, LOCATION, CHANNEL, INTERFACE, ON, WHEN, THEN, ELSE, WITHIN, BEFORE, AFTER, BY, UNTIL, SINCE, EVERY, SHALL, MUST, MUST NOT, SHOULD, MAY, CAN, TRUE, FALSE, AND, OR, NOT, IN, BETWEEN, EXISTS, FORALL, THEREEXISTS`.

---

## 8) Notation & Style Guide
- Singular nouns for canonical terms; plural only for sets (*e.g.,* *ALL Payments*).  
- Capitalise defined terms and keywords; use quotes for multi-word identifiers.  
- Avoid vague words: *quickly, soon, appropriate*; replace with quantified metrics.  
- Always include units and time windows.  
- Provide source/authority for Compliance Requirements.

---

## 9) Mini Glossary (selected A–Z)
**Approval** — formal acceptance changing State to *Approved*.  
**Assessment** — evaluation producing a Score or Decision.  
**Audit Trail** — immutable sequence of recorded Actions.  
**Backorder** — demand cannot be fulfilled from On Hand.  
**Baseline** — snapshot used for comparison.  
**Breach** — violation of a Policy or SLA.  
**Consent** — documented permission; may expire.  
**Cut-off Time** — latest time for same-day processing.  
**Data Quality** — completeness, accuracy, timeliness, validity.  
**Eligibility** — result of criteria evaluation.  
**Escalation** — route to higher authority after SLA breach.  
**Exception** — permitted deviation requiring justification.  
**Forecast** — predicted demand by time bucket.  
**Fulfilment** — processes that satisfy demand.  
**KYC** — identity verification and risk assessment.  
**Master Data** — core reference entities (Customer, Product).  
**Observation** — recorded measurement at time t.  
**Outcome** — business value delivered by a Process.  
**Reconciliation** — compare and resolve differences in records.  
**Segregation of Duties (SoD)** — prevent conflict of interest.  
**Threshold** — numeric bound triggering behaviour.  
**Traceability** — link from Requirement to Implementation and Test.  
**Validation** — confirm data correctness or rule compliance.  
**Verification** — confirm outputs meet specified requirements.

---

## 10) Example Parsable Snippets (EBL-ready)
1. *DEFINE LTV AS Loan Amount / Property Value (%).*  
2. *ON Application Received WHEN Borrower Credit Score ≥ 700 THEN Auto-Approve ELSE route to Underwriter.*  
3. *Inventory Planner SHALL create Purchase Order WHEN On Hand + On Order − Allocated ≤ ROP.*  
4. *Investigator SHALL report SAE WITHIN 24h TO Sponsor AND IRB.*  
5. *System "Order Service" SHALL expose Interface "CreatePO" VIA API.*

---

## 11) Implementation Hints for ANTLR
- **Lexer**: keep a closed class of keywords (Modality, Temporal, Logical). Treat domain nouns/verbs as identifiers bound by the dictionary at compile-time.  
- **Parser**: start with productions for *Requirement*, *Rule (ECA)*, *Derivation*, *Structure*, *Relationship*.  
- **Symbol Table**: register defined **Actors, Entities, Measures, States** before parsing rules that reference them.  
- **Type System**: numeric vs. boolean vs. enum vs. date vs. duration; enforce unit compatibility.  
- **Semantic Checks**: undefined symbols, unit mismatches, unreachable events, missing SLAs, cyclic dependencies.

---

## 12) Roadmap & Extensions
- Annexes extended to **Payments/KYC, Insurance Claims, Manufacturing (MRP), Public Sector Grants, Aviation MRO**.  
- Controlled verb lists introduced per domain for consistency.  
- JSON/YAML export of the dictionary for toolchain integration.  
- Versioning and change control process for canonical terms (semantic versioning, change logs, deprecation notices).  
- Future work: domain-specific ontologies, mappings to regulatory frameworks, test suites for grammar validation.

---

*End of EBL Encyclopedic Dictionary — v1.1 (Extended Annexes, Verb Lists, Export & Version Control).*

