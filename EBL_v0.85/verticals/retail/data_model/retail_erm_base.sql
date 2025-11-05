-- Core Entities and Relationships for the ERM

-- BusinessGoal Table
CREATE TABLE BusinessGoal (
    ID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    StrategicPriority VARCHAR(50) CHECK (StrategicPriority IN ('High', 'Medium', 'Low')),
    Timeframe VARCHAR(50) CHECK (Timeframe IN ('Short-Term', 'Long-Term')),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP
);

-- Objective Table
CREATE TABLE Objective (
    ID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Priority VARCHAR(50) CHECK (Priority IN ('High', 'Medium', 'Low')),
    SuccessCriteria TEXT, -- JSON or TEXT for KPIs/Metrics
    Status VARCHAR(50) CHECK (Status IN ('Planned', 'In Progress', 'Achieved')),
    BusinessGoalID UUID NOT NULL,
    FOREIGN KEY (BusinessGoalID) REFERENCES BusinessGoal(ID) ON DELETE CASCADE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP
);

-- Actor Table
CREATE TABLE Actor (
    ID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Role VARCHAR(100),
    Department VARCHAR(100),
    ContactInfo VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP
);

-- Objective_Actor (Many-to-Many Relationship)
CREATE TABLE Objective_Actor (
    ObjectiveID UUID,
    ActorID UUID,
    InteractionType VARCHAR(50) CHECK (InteractionType IN ('Owner', 'Contributor', 'Reviewer')),
    PRIMARY KEY (ObjectiveID, ActorID),
    FOREIGN KEY (ObjectiveID) REFERENCES Objective(ID) ON DELETE CASCADE,
    FOREIGN KEY (ActorID) REFERENCES Actor(ID) ON DELETE CASCADE
);

-- BusinessProcess Table
CREATE TABLE BusinessProcess (
    ID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    ProcessOwner UUID, -- References Actor
    Version VARCHAR(50),
    ObjectiveID UUID NOT NULL,
    FOREIGN KEY (ObjectiveID) REFERENCES Objective(ID) ON DELETE CASCADE,
    FOREIGN KEY (ProcessOwner) REFERENCES Actor(ID) ON DELETE SET NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP
);

-- Requirement Table
CREATE TABLE Requirement (
    ID UUID PRIMARY KEY,
    Description TEXT NOT NULL,
    Priority VARCHAR(50) CHECK (Priority IN ('High', 'Medium', 'Low')),
    Type VARCHAR(50) CHECK (Type IN ('Functional', 'Non-Functional')),
    Status VARCHAR(50) CHECK (Status IN ('Draft', 'Approved', 'Implemented')),
    BusinessProcessID UUID NOT NULL,
    EBLClassID UUID NOT NULL,
    FOREIGN KEY (BusinessProcessID) REFERENCES BusinessProcess(ID) ON DELETE CASCADE,
    FOREIGN KEY (EBLClassID) REFERENCES EBLClass(ID) ON DELETE RESTRICT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP
);

-- EBLClass Table
CREATE TABLE EBLClass (
    ID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(100),
    Description TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP
);

-- Capability Table
CREATE TABLE Capability (
    ID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    OutcomeDescription TEXT,
    MaturityLevel VARCHAR(50) CHECK (MaturityLevel IN ('Conceptual', 'Developing', 'Mature')),
    Owner UUID, -- References Actor
    ProjectID UUID NOT NULL,
    FOREIGN KEY (Owner) REFERENCES Actor(ID) ON DELETE SET NULL,
    FOREIGN KEY (ProjectID) REFERENCES Project(ID) ON DELETE CASCADE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP
);

-- Requirement_Capability (Many-to-One Relationship from Requirement to Capability)
CREATE TABLE Requirement_Capability (
    RequirementID UUID,
    CapabilityID UUID,
    PRIMARY KEY (RequirementID, CapabilityID),
    FOREIGN KEY (RequirementID) REFERENCES Requirement(ID) ON DELETE CASCADE,
    FOREIGN KEY (CapabilityID) REFERENCES Capability(ID) ON DELETE CASCADE
);

-- BusinessProcess_Capability (Many-to-Many Relationship)
CREATE TABLE BusinessProcess_Capability (
    BusinessProcessID UUID,
    CapabilityID UUID,
    PRIMARY KEY (BusinessProcessID, CapabilityID),
    FOREIGN KEY (BusinessProcessID) REFERENCES BusinessProcess(ID) ON DELETE CASCADE,
    FOREIGN KEY (CapabilityID) REFERENCES Capability(ID) ON DELETE CASCADE
);

-- Project Table
CREATE TABLE Project (
    ID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(50) CHECK (Status IN ('Initiated', 'In Progress', 'Completed', 'Cancelled')),
    ArchitectureAsCode TEXT, -- Stores ArchiMate model (e.g., XML/JSON)
    CloudArchitectureAsCode TEXT, -- Stores IaC (e.g., Terraform JSON)
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP
);

-- Project_Actor (Many-to-Many Relationship)
CREATE TABLE Project_Actor (
    ProjectID UUID,
    ActorID UUID,
    Role VARCHAR(50) CHECK (Role IN ('Stakeholder', 'Implementer', 'Manager')),
    PRIMARY KEY (ProjectID, ActorID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ID) ON DELETE CASCADE,
    FOREIGN KEY (ActorID) REFERENCES Actor(ID) ON DELETE CASCADE
);

-- DataObject Table
CREATE TABLE DataObject (
    ID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    SchemaType VARCHAR(100), -- e.g., JSON, SQL, CSV
    SourceSystem VARCHAR(100),
    SensitivityLevel VARCHAR(50) CHECK (SensitivityLevel IN ('Public', 'Confidential', 'Restricted')),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP
);

-- Policy Table (OPA - Open Policy Agent)
CREATE TABLE Policy (
    ID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Ruleset TEXT, -- Stores OPA Rego policy
    Version VARCHAR(50),
    EnforcementScope VARCHAR(100), -- e.g., Project, Capability, Application
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP
);

-- Application Table
CREATE TABLE Application (
    ID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(50) CHECK (Type IN ('New', 'Existing')),
    DeploymentTarget VARCHAR(100), -- e.g., AWS, GCP, Azure
    Vendor VARCHAR(100),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP
);

-- EBLClass_DataObject (Many-to-Many per Project)
CREATE TABLE EBLClass_DataObject (
    EBLClassID UUID,
    DataObjectID UUID,
    ProjectID UUID,
    PRIMARY KEY (EBLClassID, DataObjectID, ProjectID),
    FOREIGN KEY (EBLClassID) REFERENCES EBLClass(ID) ON DELETE CASCADE,
    FOREIGN KEY (DataObjectID) REFERENCES DataObject(ID) ON DELETE CASCADE,
    FOREIGN KEY (ProjectID) REFERENCES Project(ID) ON DELETE CASCADE
);

-- EBLClass_Policy (Many-to-Many per Project)
CREATE TABLE EBLClass_Policy (
    EBLClassID UUID,
    PolicyID UUID,
    ProjectID UUID,
    PRIMARY KEY (EBLClassID, PolicyID, ProjectID),
    FOREIGN KEY (EBLClassID) REFERENCES EBLClass(ID) ON DELETE CASCADE,
    FOREIGN KEY (PolicyID) REFERENCES Policy(ID) ON DELETE CASCADE,
    FOREIGN KEY (ProjectID) REFERENCES Project(ID) ON DELETE CASCADE
);

-- Capability_DataObject (Many-to-Many)
CREATE TABLE Capability_DataObject (
    CapabilityID UUID,
    DataObjectID UUID,
    PRIMARY KEY (CapabilityID, DataObjectID),
    FOREIGN KEY (CapabilityID) REFERENCES Capability(ID) ON DELETE CASCADE,
    FOREIGN KEY (DataObjectID) REFERENCES DataObject(ID) ON DELETE CASCADE
);

-- Capability_Policy (Many-to-Many)
CREATE TABLE Capability_Policy (
    CapabilityID UUID,
    PolicyID UUID,
    PRIMARY KEY (CapabilityID, PolicyID),
    FOREIGN KEY (CapabilityID) REFERENCES Capability(ID) ON DELETE CASCADE,
    FOREIGN KEY (PolicyID) REFERENCES Policy(ID) ON DELETE CASCADE
);

-- Capability_Application (Many-to-Many)
CREATE TABLE Capability_Application (
    CapabilityID UUID,
    ApplicationID UUID,
    PRIMARY KEY (CapabilityID, ApplicationID),
    FOREIGN KEY (CapabilityID) REFERENCES Capability(ID) ON DELETE CASCADE,
    FOREIGN KEY (ApplicationID) REFERENCES Application(ID) ON DELETE CASCADE
);

-- Application_DataObject (Many-to-Many)
CREATE TABLE Application_DataObject (
    ApplicationID UUID,
    DataObjectID UUID,
    PRIMARY KEY (ApplicationID, DataObjectID),
    FOREIGN KEY (ApplicationID) REFERENCES Application(ID) ON DELETE CASCADE,
    FOREIGN KEY (DataObjectID) REFERENCES DataObject(ID) ON DELETE CASCADE
);

-- Application_Policy (Many-to-Many)
CREATE TABLE Application_Policy (
    ApplicationID UUID,
    PolicyID UUID,
    PRIMARY KEY (ApplicationID, PolicyID),
    FOREIGN KEY (ApplicationID) REFERENCES Application(ID) ON DELETE CASCADE,
    FOREIGN KEY (PolicyID) REFERENCES Policy(ID) ON DELETE CASCADE
);

-- ArchitecturePattern Table (Derived Output)
CREATE TABLE ArchitecturePattern (
    ID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(50) CHECK (Type IN ('AaaS', 'IaaS')),
    Description TEXT,
    CapabilityID UUID,
    BusinessProcessID UUID,
    DataObjectID UUID,
    PolicyID UUID,
    CloudPlatformCode TEXT, -- Stores AWS CDK, Azure ARM, or GCP DM code
    ProjectID UUID NOT NULL,
    FOREIGN KEY (CapabilityID) REFERENCES Capability(ID) ON DELETE SET NULL,
    FOREIGN KEY (BusinessProcessID) REFERENCES BusinessProcess(ID) ON DELETE SET NULL,
    FOREIGN KEY (DataObjectID) REFERENCES DataObject(ID) ON DELETE SET NULL,
    FOREIGN KEY (PolicyID) REFERENCES Policy(ID) ON DELETE SET NULL,
    FOREIGN KEY (ProjectID) REFERENCES Project(ID) ON DELETE CASCADE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP
);

-- Constraints
ALTER TABLE Requirement
ADD CONSTRAINT unique_requirement_eblclass CHECK (
    (SELECT COUNT(*) FROM Requirement WHERE EBLClassID = EBLClassID) >= 1
);

ALTER TABLE Capability
ADD CONSTRAINT capability_project CHECK (
    (SELECT COUNT(*) FROM Capability WHERE ProjectID = ProjectID) >= 1
);

ALTER TABLE Capability_Application
ADD CONSTRAINT capability_application CHECK (
    (SELECT COUNT(*) FROM Capability_Application WHERE CapabilityID = CapabilityID) >= 1
);

-- Indexes for Performance
CREATE INDEX idx_businessgoal_id ON BusinessGoal(ID);
CREATE INDEX idx_objective_businessgoalid ON Objective(BusinessGoalID);
CREATE INDEX idx_businessprocess_objectiveid ON BusinessProcess(ObjectiveID);
CREATE INDEX idx_requirement_businessprocessid ON Requirement(BusinessProcessID);
CREATE INDEX idx_requirement_eblclassid ON Requirement(EBLClassID);
CREATE INDEX idx_capability_projectid ON Capability(ProjectID);