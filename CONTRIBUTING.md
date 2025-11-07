# Contributing to Enterprise Business Language (EBL)

Thank you for your interest in contributing to EBL! This document provides guidelines and instructions for contributing to the project.

EBL is part of the **Archailign Business Engineering** framework, integrating ArchiMate 3.1 capabilities with executable business logic. Your contributions help advance the state of enterprise architecture and business process automation.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Requirements](#testing-requirements)
- [Submitting Changes](#submitting-changes)
- [Community](#community)

## Code of Conduct

This project adheres to the Contributor Covenant [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behaviour to info@praxibility.com.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the [issue tracker](https://github.com/Archailign/praxibility-ebl/issues) to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected vs actual behaviour**
- **EBL version** you're using
- **Environment details** (OS, Java/Python version)
- **Sample EBL file** that demonstrates the issue (if applicable)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Clear use case** and motivation
- **Proposed solution** or approach
- **Alternative solutions** you've considered
- **Impact on existing functionality**

### Contributing Code

We welcome pull requests for:

- Bug fixes
- New features
- Documentation improvements
- Domain dictionary additions
- Example EBL files
- Test coverage improvements
- Performance optimisations

**Important**: EBL v0.85 uses a **vertical-based architecture** where each domain (Banking, Healthcare, Insurance, etc.) is self-contained with its own ANTLR grammar, validators, tests, and examples. See [verticals/README.md](EBL_v0.85/verticals/README.md) for details.

## Getting Started

### Prerequisites

- **JDK 11 or higher** (for ANTLR parser generation and Java validators)
- **Maven 3.6+** or **Gradle 7+** (for Java builds)
- **Python 3.8+** with `antlr4-python3-runtime` (for Python validators)
- **ANTLR 4.13.1** (included in `EBL_v0.85/antlr-4.13.1-complete.jar`)
- **Git**
- **A GitHub account**

### Setup Development Environment

1. **Fork the repository** on GitHub

2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/praxibility-ebl.git
   cd praxibility-ebl
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/Archailign/praxibility-ebl.git
   ```

4. **Install Python dependencies**:
   ```bash
   pip install antlr4-python3-runtime pytest
   ```

5. **Build the project** (optional, for Java development):
   ```bash
   cd EBL_v0.85
   mvn clean install
   # or
   gradle build
   ```

6. **Verify installation by running tests**:
   ```bash
   # Java tests
   cd EBL_v0.85
   mvn test
   # or
   gradle test

   # Python validator test (Banking vertical)
   cd verticals/banking/tests/python
   python3 test_banking_validator.py
   ```

## Development Workflow

### Branching Strategy

- `main` - Stable release branch
- `develop` - Development branch (if using GitFlow)
- `feature/*` - Feature branches
- `bugfix/*` - Bug fix branches
- `hotfix/*` - Hotfix branches

### Making Changes

1. **Create a branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following our coding standards

3. **Test your changes**:
   ```bash
   mvn test
   # Or for Python validator (from vertical directory)
   cd EBL_v0.85/verticals/[vertical]
   python3 validators/python/dictionary_validator.py \
     examples/YourExample.ebl \
     dictionary/[vertical]_dictionary_v0.85.json
   ```

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Brief description of changes"
   ```

   Commit message format:
   ```
   <type>: <subject>

   <body>

   <footer>
   ```

   Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

   Example:
   ```
   feat: Add support for nested DataObject definitions

   - Added grammar rules for nested objects
   - Updated validator to handle nesting
   - Added examples and tests

   Closes #123
   ```

5. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request** on GitHub

## Coding Standards

### Java Code

- Follow [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- Use meaningful variable and method names
- Add JavaDoc comments for public APIs
- Keep methods focused and concise
- Maximum line length: 120 characters

### Python Code

- Follow [PEP 8](https://pep8.org/) style guide
- Use type hints where applicable
- Add docstrings for functions and classes
- Maximum line length: 100 characters

### ANTLR Grammar

- Use clear, descriptive rule names (camelCase for parser rules, UPPER_CASE for lexer rules)
- Add comments for complex rules
- Organise rules logically (top-down)
- Test grammar changes thoroughly

### Documentation

- Use GitHub-flavoured Markdown
- Keep documentation up-to-date with code changes
- Include code examples in documentation
- Use clear, concise language
- **Use British English** spelling throughout (behaviour, organisation, licence, etc.)

## Testing Requirements

### Test Coverage

- All new features must include tests
- Bug fixes should include regression tests
- Aim for >80% code coverage
- Test both success and failure cases

### Test Types

1. **Unit Tests**: Test individual components
   ```java
   @Test
   public void testDataObjectValidation() {
       // Test implementation
   }
   ```

2. **Integration Tests**: Test EBL file parsing
   ```bash
   cd EBL_v0.85/verticals/[vertical]
   python3 validators/python/dictionary_validator.py \
     examples/NewFeature.ebl \
     dictionary/[vertical]_dictionary_v0.85.json
   ```

3. **Grammar Tests**: Test ANTLR grammar rules

### Running Tests

```bash
# Java tests (from project root)
cd EBL_v0.85
mvn test

# Python validator - test specific vertical
cd EBL_v0.85/verticals/banking
for file in examples/*.ebl; do
  python3 validators/python/dictionary_validator.py \
    "$file" dictionary/banking_dictionary_v0.85.json
done

# Run Python test suite for a vertical
cd EBL_v0.85/verticals/banking/tests/python
python3 test_banking_validator.py

# Specific Java test class
cd EBL_v0.85
mvn test -Dtest=BankingValidatorTest
```

## Submitting Changes

### Pull Request Process

1. **Update documentation** to reflect changes
2. **Add/update tests** as needed
3. **Update CHANGELOG.md** following [Keep a Changelog](https://keepachangelog.com/) format
4. **Ensure all tests pass**
5. **Update README.md** if adding new features
6. **Submit PR** with clear description

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] All existing tests pass
- [ ] Added new tests
- [ ] Manually tested

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed code
- [ ] Commented complex code
- [ ] Updated documentation
- [ ] Updated CHANGELOG.md
- [ ] No new warnings

## Related Issues
Closes #(issue number)
```

### Review Process

- Maintainers will review your PR within 1 week
- Address review comments promptly
- Keep discussions constructive and respectful
- PRs require at least one approval before merging

## Domain Dictionary Contributions

When adding to `EBL_Dictionary_*.json`:

1. **Follow existing structure**:
   ```json
   {
     "actors": ["NewRole"],
     "verbs": [
       {
         "verb": "newAction",
         "permission": "write",
         "description": "Description of action"
       }
     ]
   }
   ```

2. **Document industry context** in PR description
3. **Provide example usage** in an EBL file
4. **Ensure compatibility** with existing grammar
5. **Update dictionary version** if making significant changes

## Adding Examples

When contributing example EBL files to `verticals/[vertical]/examples/`:

1. **Choose or create a vertical**: Place your example in the appropriate industry vertical
2. **Use clear, realistic scenarios** from that industry domain
3. **Follow naming convention**: `Domain_UseCase.ebl` (e.g., `Insurance_ClaimLifecycle.ebl`)
4. **Include inline comments** explaining key concepts
5. **Include required metadata** (new in v0.85):
   - `CapabilityID`: Links to ArchiMate 3.1 Capability (REQUIRED)
   - `ObjectiveID`: Links to Business Objective
   - `BusinessGoalID`: Links to Business Goal
   - `erMap`: Links to ArchiMate elements for model generation
6. **Ensure dictionary compatibility**: Use only actors/verbs defined in the vertical's dictionary
7. **Test with validator** before submitting:
   ```bash
   cd EBL_v0.85/verticals/[vertical]
   python3 validators/python/dictionary_validator.py \
     examples/YourExample.ebl \
     dictionary/[vertical]_dictionary_v0.85.json
   ```
8. **Add description** in PR explaining the use case and industry context

If your example spans multiple verticals, consider:
- Creating it in the primary vertical
- Documenting cross-vertical dependencies in the PR
- Or proposing a new vertical if appropriate

## Community

### Getting Help

- **GitHub Discussions**: For questions and discussions
- **GitHub Issues**: For bugs and feature requests
- **Email**: info@praxibility.com for private inquiries

### Recognition

Contributors will be recognized in:
- CHANGELOG.md (for significant contributions)
- GitHub contributors page
- Project documentation (for major features)

## Licence

By contributing to EBL, you agree that your contributions will be licensed under the Apache Licence 2.0.

---

Thank you for contributing to EBL! Your efforts help make enterprise business language more accessible and powerful.
