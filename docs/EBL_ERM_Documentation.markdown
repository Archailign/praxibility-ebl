# Enterprise Business Language (EBL) and Entity-Relationship Model (ERM) Documentation

## 1. Introduction

This document consolidates the design and implementation details for an Enterprise Business Language (EBL) and its corresponding Entity-Relationship Model (ERM) for enterprise architecture. The EBL is a natural language-like, domain-driven, declarative language that bridges business requirements and technical implementation, using a standardized lexicon to ensure consistency. The ERM provides a structured data model to support EBL, mapping business concepts to a relational database schema. The framework is designed to be open-source under the Apache 2.0 license, supporting standardized business terminology across domains (e.g., banking, pharmaceutical, retail, insurance, manufacturing, public sector, aviation).

### Key Objectives
- Define an enhanced ERM incorporating business goals, objectives, processes, requirements, capabilities, metrics, risks, and controls, with explicit mappings to EBL and the Enterprise Business Lexicon.
- Provide a comprehensive SQL schema for the ERM, including new entities like `Risk`, `Control`, and `Metric`.
- Develop EBL examples for banking (BAIN), pharmaceutical, retail (CG & FMCG), insurance, manufacturing (MRP), public sector grants, and aviation (MRO), aligned with the lexicon’s controlled vocabulary.
- Create a formal BNF grammar for EBL using ANTLR, incorporating lexicon-defined terms and sentence frames.
- Implement a uniqueness check for `EBLDefinition` to ensure semantic consistency using lexicon-guided validation.
- Ensure alignment with ArchiMate for enterprise model generation.

### Document Structure
- **Section 2**: Enhanced ERM with lexicon-aligned entities and relationships.
- **Section 3**: SQL schema for the ERM.
- **Section 4**: EBL specification and examples for multiple domains.
- **Section 5**: BNF grammar for EBL using ANTLR.
- **Section 6**: Implementation guidance for EBL definition uniqueness check.
- **Section 7**: Next steps and open-source considerations.

### Updates (October 17, 2025)
- Integrated the Enterprise Business Lexicon to standardize terminology, adding entities like `Risk`, `Control`, `Metric`, and `SLA`.
- Expanded EBL examples to include insurance, manufacturing (MRP), public sector grants, and aviation (MRO), using lexicon-defined terms and verbs.
- Updated the ANTLR grammar to support lexicon keywords (e.g., `SHALL`, `MUST NOT`) and domain-specific constructs.
- Enhanced the uniqueness check with lexicon-guided semantic validation (e.g., unit mismatches, undefined symbols).
- Strengthened ArchiMate mappings for enterprise model generation.
- Maintained ontology for IT architecture (Applications, Systems, Platforms) with added relationships like `Segregation of Duties` and `Traceability`.

---

## 2. Improved Entity-Relationship Model (ERM)

The ERM defines relationships between business entities, ensuring traceability from business goals to technical implementations. It has been enhanced with lexicon-defined entities (`Risk`, `Control`, `Metric`, `SLA`) and relationships (e.g., `Segregation of Duties`, `Traceability`) to align with the Enterprise Business Lexicon. The model retains the IT architecture ontology (Applications, Systems, Platforms) for a structured view of the IT landscape.

### Core Entities and Relationships
1. **Organisation**
   - **Attributes**: `OrganisationID` (PK), `Name`, `Description`, `CreatedAt`, `UpdatedAt`
   - **Relationships**: One-to-many with `Domain`
   - **Purpose**: Represents the enterprise, scoping multiple domains.

2. **Domain**
   - **Attributes**: `DomainID` (PK), `OrganisationID` (FK), `Name`, `Description`, `CreatedAt`, `UpdatedAt`
   - **Relationships**: One-to-many with `Project`, many-to-one with `Organisation`
   - **Purpose**: Groups projects by business domain (e.g., banking, retail).

3. **Project**
   - **Attributes**: `ProjectID` (PK), `DomainID` (FK), `Name`, `Description`, `Stage` (ENUM: Planning, Execution, Monitoring, Closed), `StartDate`, `EndDate`, `CreatedAt`, `UpdatedAt`
   - **Relationships**: One-to-many with `BusinessGoal`, `Capability`, `Actor`, `Metric`, `SLA`; many-to-one with `Domain`
   - **Purpose**: Scopes entities and ensures measurable outcomes.

4. **BusinessGoal**
   - **Attributes**: `GoalID` (PK), `ProjectID` (FK), `Name`, `Description`, `Priority`, `Owner`, `CreatedAt`, `UpdatedAt`
   - **Relationships**: One-to-many with `Objective`, many-to-one with `Project`
   - **Purpose**: Defines strategic goals (e.g., "Increase Customer Retention by 20%").

5. **Objective**
   - **Attributes**: `ObjectiveID` (PK), `GoalID` (FK), `Name`, `Description`, `Priority`, `Status` (ENUM: Defined, In Progress, Achieved), `TargetDate`, `CreatedAt`, `UpdatedAt`
   - **Relationships**: Many-to-one with `BusinessGoal`, many-to-many with `Actor`, one-to-many with `BusinessProcess`
   - **Purpose**: Specifies measurable objectives (e.g., "Achieve 90% onboarding completion rate").

6. **Actor**
   - **Attributes**: `ActorID` (PK), `Name`, `Role`, `Department`, `AccessLevel` (ENUM: Admin, User, Guest), `CreatedAt`, `UpdatedAt`
   - **Relationships**: Many-to-many with `Objective`, `Project`, `BusinessProcess` (via `Segregation of Duties`)
   - **Purpose**: Represents stakeholders (e.g., Underwriter, Inventory Planner).

7. **BusinessProcess**
   - **Attributes**: `ProcessID` (PK), `ObjectiveID` (FK), `Name`, `Description`, `Version`, `Status` (ENUM: Draft, Active, Retired), `CreatedAt`, `UpdatedAt`
   - **Relationships**: Many-to-one with `Objective`, one-to-many with `Requirement`, many-to-many with `Capability`, `Actor` (via `Segregation of Duties`)
   - **Purpose**: Defines processes (e.g., "Customer Onboarding").

8. **EBLClass**
   - **Attributes**: `EBLClassID` (PK), `Name`, `Type` (ENUM: Functional, Non-Functional), `Version`, `Description`, `CreatedAt`, `UpdatedAt`
   - **Relationships**: One-to-many with `Requirement`, many-to-many with `DataObject`, `Policy`
   - **Purpose**: Categorizes requirements into standardized classes.

9. **Requirement**
   - **Attributes**: `RequirementID` (PK), `ProcessID` (FK), `EBLClassID` (FK), `Description`, `EBLDefinition` (TEXT, UNIQUE), `Priority`, `Status` (ENUM: Draft, Approved, Implemented), `Modality` (ENUM: SHALL, MUST_NOT, SHOULD, MAY, CAN), `CreatedAt`, `UpdatedAt`
   - **Relationships**: Many-to-one with `BusinessProcess`, `EBLClass`; one-to-many with `Capability`, `TraceLink`, `Metric`
   - **Purpose**: Stores requirements with unique EBL definitions using lexicon modality.

10. **Capability**
    - **Attributes**: `CapabilityID` (PK), `ProjectID` (FK), `RequirementID` (FK), `Name`, `OutcomeDescription`, `Status` (ENUM: Planned, Active, Retired), `MaturityLevel` (ENUM: Emerging, Mature, Optimized), `CreatedAt`, `UpdatedAt`
    - **Relationships**: Many-to-one with `Project`, `Requirement`; many-to-many with `DataObject`, `BusinessProcess`, `Policy`, `Application`, `Metric`
    - **Purpose**: Represents business capabilities (e.g., "Real-time Customer Insights").

11. **DataObject**
    - **Attributes**: `DataObjectID` (PK), `Name`, `SchemaType`, `DataOwner`, `SensitivityLevel` (ENUM: Public, Confidential, Restricted), `SourceSystem`, `DataQuality` (TEXT), `CreatedAt`, `UpdatedAt`
    - **Relationships**: Many-to-many with `EBLClass`, `Capability`, `Application`, `Metric`
    - **Purpose**: Represents data entities (e.g., customer records) with quality attributes.

12. **Policy**
    - **Attributes**: `PolicyID` (PK), `Name`, `Ruleset`, `PolicyType` (ENUM: Governance, Compliance, Operational), `EnforcementLevel` (ENUM: Mandatory, Advisory), `CreatedAt`, `UpdatedAt`
    - **Relationships**: Many-to-many with `EBLClass`, `Capability`, `Application`, `Metric`
    - **Purpose**: Defines governance and compliance rules.

13. **Application**
    - **Attributes**: `ApplicationID` (PK), `Name`, `AlternateNames` (TEXT), `Description`, `Purpose`, `Status` (ENUM: Active, Retired), `Version`, `Owner`, `DataSteward`, `TechnicalCustodian`, `GovernanceModel`, `StatusPage`, `SLA`, `PerformanceMetricsEndpoint`, `LinkToDocumentation`, `ArchitecturalDiagram`, `BusinessCapabilitySupported`, `BusinessProcessSupported`, `UserBase`, `TechnologyStack`, `ProgrammingLanguage`, `FunctionalitySummary`, `CreatedAt`, `UpdatedAt`
    - **Relationships**: Many-to-many with `Capability`, `DataObject`, `Policy`, `System` (integrates_with), `Platform` (deployed_on), `Application` (communicates_with)
    - **Purpose**: Represents software for specific tasks (e.g., CRM tool).

14. **System**
    - **Attributes**: `SystemID` (PK), `ProjectID` (FK), `Name`, `AlternateNames`, `Description`, `Purpose`, `Status` (ENUM: Active, Retired), `Version`, `Owner`, `DataSteward`, `TechnicalCustodian`, `GovernanceModel`, `StatusPage`, `SLA`, `PerformanceMetricsEndpoint`, `LinkToDocumentation`, `ArchitecturalDiagram`, `BusinessScope`, `DomainAffected`, `InputDataSources`, `OutputDataSinks`, `DataFlowDiagram`, `ArchitecturalStyle` (ENUM: Monolithic, Microservices, Event-Driven), `CreatedAt`, `UpdatedAt`
    - **Relationships**: Many-to-many with `Application` (consists_of), `DataObject` (consists_of), `Capability`, `System` (depends_on), `Platform` (depends_on); many-to-one with `Project`
    - **Purpose**: Represents integrated components (e.g., e-commerce system).

15. **Platform**
    - **Attributes**: `PlatformID` (PK), `Name`, `AlternateNames`, `Description`, `Purpose`, `Status` (ENUM: Active, Retired), `Version`, `Owner`, `DataSteward`, `TechnicalCustodian`, `GovernanceModel`, `StatusPage`, `SLA`, `PerformanceMetricsEndpoint`, `LinkToDocumentation`, `ArchitecturalDiagram`, `ServicesProvided`, `APICatalog`, `DevelopmentCapabilities`, `EcosystemComponents`, `ManagementCapabilities`, `CreatedAt`, `UpdatedAt`
    - **Relationships**: Many-to-many with `Application` (hosts), `System` (hosts), `Capability`, `Platform` (runs_on)
    - **Purpose**: Represents foundational infrastructure (e.g., AWS).

16. **ArchitecturePattern**
    - **Attributes**: `PatternID` (PK), `Name`, `Type` (ENUM: AaaS, IaaS, PaaS), `Description`, `DeploymentMetadata` (JSON), `CreatedAt`, `UpdatedAt`
    - **Relationships**: Many-to-many with `Capability`, `BusinessProcess`, `DataObject`, `Policy`, `System`, `Platform`
    - **Purpose**: Defines reusable architecture patterns.

17. **TraceLink**
    - **Attributes**: `TraceLinkID` (PK), `SourceEntity`, `SourceID`, `TargetEntity`, `TargetID`, `RelationshipType`, `CreatedAt`
    - **Relationships**: Links entities for traceability (e.g., `Requirement` to `Capability`)
    - **Purpose**: Ensures auditing and impact analysis.

18. **CapabilityPerformance**
    - **Attributes**: `PerformanceID` (PK), `CapabilityID` (FK), `MetricName`, `MetricValue`, `Timestamp`
    - **Relationships**: Many-to-one with `Capability`
    - **Purpose**: Tracks capability metrics.

19. **Metric** (New Entity)
    - **Attributes**: `MetricID` (PK), `ProjectID` (FK), `Name`, `Description`, `Unit` (VARCHAR), `Threshold` (FLOAT), `MeasureType` (ENUM: KPI, SLA, Operational), `CreatedAt`, `UpdatedAt`
    - **Relationships**: Many-to-one with `Project`, many-to-many with `Capability`, `DataObject`, `Policy`, `Application`
    - **Purpose**: Defines measurable indicators (e.g., LTV, Service Level).

20. **SLA** (New Entity)
    - **Attributes**: `SLAID` (PK), `ProjectID` (FK), `Name`, `Description`, `ServiceLevel` (TEXT), `BreachAction` (TEXT), `CreatedAt`, `UpdatedAt`
    - **Relationships**: Many-to-one with `Project`, many-to-many with `Metric`, `Application`, `System`, `Platform`
    - **Purpose**: Defines service level agreements (e.g., "Process claims within 24h").

21. **Risk** (New Entity)
    - **Attributes**: `RiskID` (PK), `ProjectID` (FK), `Name`, `Description`, `RiskScore` (FLOAT), `Likelihood` (FLOAT), `Impact` (FLOAT), `CreatedAt`, `UpdatedAt`
    - **Relationships**: Many-to-one with `Project`, one-to-many with `Control`, many-to-many with `Policy`
    - **Purpose**: Represents risks (e.g., "Fraudulent transaction").

22. **Control