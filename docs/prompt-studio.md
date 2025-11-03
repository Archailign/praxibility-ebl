You are an expert in enterprise architecture, requirements engineering, and agile project management. Your task is to design and describe a complete, end-to-end system called "Requirements Studio." This system is an AI-powered tool that automates the transformation of unstructured business requirements into structured artifacts for software development, architecture, and project management. It leverages natural language processing (NLP), a custom Enterprise Business Lexicon (EBL) dictionary, a grammar for parsing requirements (based on the provided EBL.g4 ANTLR grammar), and integrations with tools like Jira and ArchiMate modeling.

The system must encapsulate the following capabilities:

1. **Ingestion and Analysis of Human Requirements:**
   - Accept input in various formats, such as Markdown documents (e.g., the provided "business-req-sample.md"), PDFs, or plain text.
   - Parse the input using NLP to extract key elements: problems, goals, objectives, scope (in-scope/out-of-scope), user stories, non-functional requirements, and specific business requirements.
   - Generate Agile artifacts: Break down the requirements into an Epic with associated User Stories, Tasks, and Sub-tasks. Include relevant Jira attributes such as Summary, Description, Priority (e.g., High/Medium/Low), Assignee, Labels, Components, Epic Link, Story Points (estimated using a Fibonacci scale), Acceptance Criteria, and Attachments (e.g., links to the original document).
   - Flag potential issues during parsing:
     - Reserved words from the EBL dictionary (e.g., "ON", "WHEN", "THEN", "SHALL", "MUST").
     - Verbs and nouns that match or are similar to those in the EBL dictionary (e.g., verbs like "Plan", "Bid", "Optimise"; nouns like "Campaign", "DataObject").
     - Unrecognized nouns or verbs that do not exist in the current EBL dictionary. Suggest additions (e.g., new verbs, entities, or actors) and route them through an approval workflow (e.g., simulate or describe integration with a tool like Slack or email for human approval by a domain expert).
   - If approved, automatically update the EBL dictionary (e.g., the provided "EBL_Dictionary_v1.3.1_all.json") and enhance the grammar (e.g., update the EBL.g4 file to include new terminals or rules).

2. **Generation of Business Flow and EBL Artifacts:**
   - Based on the parsed requirements, create the EBL business flow steps (that can be converted to BPMN or Archimate business process and capability relations) that maps the process steps, actors, and data flows.
   - Generate EBL-compliant code artifacts that match the structure in the EBL dictionary and grammar:
     - DataObjects (e.g., schemas with fields, policies, resources).
     - Entities (e.g., with properties, rules).
     - Processes (e.g., with steps, actions, actors, inputs/outputs).
     - Relationships (e.g., "communicates_with", "depends_on").
     - Ensure alignment with the provided domain-specific elements (e.g., for "adtech" domain: entities like "Campaign", verbs like "Plan", actors like "MarketingManager").
   - If the requirements introduce new concepts (e.g., a new domain like "marketing_agency" based on the sample), update the EBL dictionary accordingly (e.g., add new entities, verbs, actors, and actor permissions). Validate against the core constraints in the dictionary (e.g., "entity_requires_dataRef").

3. **Jira-Importable Output:**
   - Produce output in a format directly importable into Jira (e.g., CSV or JSON with fields like Issue Type, Summary, Description, Priority, Labels, etc.).
   - Include bulk import instructions or a script snippet for Jira (e.g., using Jira's CSV importer).
   - Link stories back to the original requirements for traceability.

4. **Correlation of Elements:**
   - Ensure all generated artifacts correlate seamlessly:
     - Goals and Objectives from the requirements map to Business Goals/Objectives in EBL Processes.
     - Capabilities (e.g., "Unified Dashboard") map to Process Steps, Actors/Roles (e.g., "Media Buyer"), Applications/Systems (e.g., "DSP", "AdServer"), Policies (e.g., data retention, compliance), and DataObjects (e.g., "DO_PerformanceMetrics").
     - Process flows include triggers, conditions, actions, and error handling, aligned with the EBL grammar.
     - Incorporate elements from provided documents (e.g., adtech process like "DynamicAdMarketingCycle" as a reference for similar flows).

5. **Support for ArchiMate Models:**
   - Generate ArchiMate-compatible models in XML or a descriptive format (e.g., using Archi tool export format).
   - Cover three layers:
     - **Business Layer:** Actors, Roles, Processes, Business Objects (e.g., mapping EBL Entities/DataObjects to ArchiMate Business Objects; Processes to Business Processes).
     - **Application Layer:** Applications, Systems, Interfaces (e.g., mapping EBL ITAssets, Integrations, Resources to Application Components, Interfaces, and Data Objects).
     - **Technology/Infrastructure Layer:** Nodes, Devices, Networks (e.g., inferring from EBL Resources like endpoints, protocols, SLAs).
   - Ensure traceability: Each ArchiMate element links back to the original requirement, EBL artifact, or Jira story.
   - Output visualizations if possible (e.g., describe SVG/PNG diagrams or integrate with a tool like PlantUML for rendering).

**Overall System Design Guidelines:**
- The Requirements Studio should be modular: Ingestion Module, Parsing/Analysis Module (using NLP and ANTLR for EBL.g4), Generation Module (for EBL, Jira, ArchiMate), Workflow Module (for approvals), and Validation Module (for correlations and compliance).
- Handle edge cases: Ambiguous language in requirements, conflicts with existing EBL (e.g., verb permission mismatches), or incomplete data.
- Use the provided documents as references:
  - "AdTech_Dynamic_Marketing_Cycle_Full.ebl" as a sample EBL output.
  - "EBL_Dictionary_v1.3.1_all.json" as the base lexicon.
  - "business-req-sample.md" as a test input to demonstrate the system.
  - "EBL.g4" for parsing/validation.
- Output Format: Provide a comprehensive description of the Requirements Studio, including:
  - High-level architecture diagram (text-based, e.g., using Mermaid syntax).
  - Step-by-step workflow example using the "business-req-sample.md" as input.
  - Sample outputs: EBL code snippet, Jira CSV, ArchiMate XML snippet.
  - Any necessary code snippets (e.g., Python for parsing with ANTLR).
- Ensure the system is extensible for future domains beyond "adtech" (e.g., retail, healthcare).

Demonstrate the Requirements Studio by processing the provided "business-req-sample.md" as an example input, and generate all relevant outputs.