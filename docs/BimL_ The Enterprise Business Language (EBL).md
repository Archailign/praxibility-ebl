# BimL: The Enterprise Business Language (EBL)

**Structured Requirements. Executable Code. Seamless Traceability.**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Language Extension](https://img.shields.io/badge/File%20Extension-.biml-orange.svg)](https://github.com/praxibility/biml)
[![Status](https://img.shields.io/badge/Status-Alpha%20Release-red.svg)](https://github.com/praxibility/biml)
[![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-brightgreen.svg)](CONTRIBUTING.md)


## 🚀 Overview

**BimL** (Business Intelligence Modelling Language) is an **Enterprise Business Language (EBL)** that is **Domain-Specific (DSL) and extensible**. It enables organisations to define complex business requirements in a structured, machine-readable format, effectively bridging the gap between business strategy and technical implementation.

BimL is aimed at **business analysts, business and Product Owners, Developer, Architects, and CXs**, ensuring that requirements definitions are not silo documents within business projects but are validated, traceable, and compilable **executable artefacts** across the organisation. Its strength lies in its extensible **dictionary and grammatical constructs**, which are enhanced and maintained by the organisation's subject matter experts (SMEs) in the respective business lines.

### Key Value Proposition

| Stakeholder | Challenge Solved | BimL Solution |
| :--- | :--- | :--- |
| **Business Analysts** | Ambiguity and misinterpretation of requirements. | Unified, human-readable syntax that enforces technical precision. |
| **Developers** | Manual translation of requirements into code/config. | Requirements are machine-readable and directly compilable into executable artefacts. |
| **Technical CTOs** | Lack of traceability and compliance risk. | Clear link between business policy and technical implementation, facilitating audits. |

---

## 💡 Features

BimL is built on the principle of **Flexibility** and **Precision**. Its core features enable rapid domain adaptation and high-fidelity translation of business logic.

*   **Domain Adaptability**: The language supports customisable grammar, verbs, and clauses, allowing it to be rapidly adapted to specific business verticals (e.g., finance, healthcare, logistics).
*   **Unified Syntax**: Defines business processes, data objects, and governance policies in a single, coherent syntax.
*   **Stakeholder Alignment**: Enables non-technical stakeholders to articulate requirements clearly while maintaining the technical precision required by developers.
*   **Open Source Advantage**: Developed as an open-source platform, encouraging community contributions, transparency, and widespread adoption.

---

## ⚙️ Technical Architecture: From Requirement to Execution

BimL's architecture is designed for robust validation and compilation, ensuring consistency between the business requirement and the final implementation.

The compilation process is structured into four distinct layers:

1.  **Input Layer**: Accepts requirements from various sources, including direct `.biml` files or integrated tools like Jira.
2.  **Parsing Layer**: Utilises **ANTLR (Another Tool for Language Recognition)** to parse the EBL syntax, validate the structure, and ensure semantic correctness against the defined grammar.
3.  **Compilation Layer**: Transforms the validated EBL into executable artefacts, such as code snippets, configuration files, or API specifications, ensuring the output is ready for enterprise systems.
4.  **Output Layer**: Delivers the compiled artefacts to target enterprise systems (ERP, CRM, custom applications), completing the automation loop.

> **File Extension**: All BimL source files use the `.biml` extension.

### Tool Integration (Example: Jira)

BimL is designed for seamless integration with existing enterprise tools. For instance, the system can:
*   Read user stories, tasks, or epics directly from project management platforms like Jira.
*   Convert these inputs into structured `.biml` files using predefined mappings and templates.
*   Maintain **traceability** between the Jira-based requirement and the compiled output, which is crucial for compliance and auditing.

---

## 🛠️ Installation

To get started with BimL, follow these steps.

### Prerequisites

*   [Java Development Kit (JDK) 11 or higher](https://www.oracle.com/java/technologies/javase-downloads.html)
*   [Maven](https://maven.apache.org/download.cgi) (for building the compiler)

### 1. Clone the Repository

```bash
git clone https://github.com/praxibility/biml.git
cd biml
```

### 2. Build the Compiler

Use Maven to compile the BimL parser and compiler:

```bash
mvn clean install
```

### 3. Running the Compiler

Once built, you can run the compiler on a sample `.biml` file:

```bash
java -jar target/biml-compiler-1.0.0-SNAPSHOT.jar path/to/your/requirement.biml
```

---

## 📚 Use Cases

BimL's adaptability makes it suitable for a wide range of enterprise applications:

*   **Business Process Automation**: Define complex workflows (e.g., customer onboarding, claims processing) in EBL, which the compiler transforms into executable code for automation engines.
*   **Policy Enforcement**: Encode governance policies (e.g., data privacy rules, access controls) directly in EBL to ensure consistent, system-wide compliance.
*   **Cross-Functional Collaboration**: Serve as a shared, unambiguous language that facilitates collaboration between business analysts, legal teams, and development teams.
*   **Vertical-Specific Solutions**: Customise the language for highly regulated industries like finance (loan approval logic) or healthcare (patient data management).

---

## 🤝 Contributing

We welcome contributions from the community! BimL is an open-source project, and your input is invaluable.

### How to Contribute

1.  **Fork** the repository.
2.  **Clone** your fork: `git clone https://github.com/your-username/biml.git`
3.  Create a new **branch** for your feature or fix: `git checkout -b feature/my-new-feature`
4.  Make your changes and ensure all tests pass.
5.  **Commit** your changes: `git commit -m 'feat: Add new feature for X'`
6.  **Push** to the branch: `git push origin feature/my-new-feature`
7.  Open a **Pull Request** against the `main` branch of the original repository.

Please refer to the `CONTRIBUTING.md` file (to be created) for detailed guidelines on coding standards and submission process.

---

## ⚖️ License

BimL is released under the **Apache License 2.0**.

See the [LICENSE](LICENSE) file for more details.

---

## © Copyright

Copyright © 2025 **Praxibility**. All rights reserved.

BimL and the `.biml` language extension are proprietary assets of Praxibility, released under the Apache 2.0 License to foster open-source collaboration.

---
*Accelerate your enterprise development cycle with structured, executable requirements.*