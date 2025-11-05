# EBL Utilities

This directory contains utility scripts used for project maintenance and automation.

## Scripts

### generate_vertical_parsers.sh
**Purpose:** Generates ANTLR parsers for all verticals from their grammars.

**Usage:**
```bash
# From EBL_v0.85/ directory
./utilities/generate_vertical_parsers.sh

# Or from utilities/ directory
cd utilities && ./generate_vertical_parsers.sh
```

**What it does:**
- Downloads ANTLR 4.13.1 JAR if not present
- Generates Python parsers for all 8 verticals
- Generates Java parsers for all 8 verticals
- Places parsers in `verticals/[vertical]/generated/python/` and `generated/java/`

**When to use:**
- After updating a vertical grammar file
- When setting up a new development environment
- After adding a new vertical

**Output:**
```
verticals/[vertical]/generated/
├── python/
│   ├── [Vertical]_v0_85Lexer.py
│   ├── [Vertical]_v0_85Parser.py
│   ├── [Vertical]_v0_85Listener.py
│   └── [Vertical]_v0_85Visitor.py
└── java/
    └── (Java parsers with package structure)
```

---

## Workflow for Adding a New Vertical

1. **Create vertical structure:**
   ```bash
   mkdir -p verticals/my_vertical/{grammar,dictionary,validators/{python,java},tests/{python,java},examples,data_model,generated/{python,java}}
   ```

2. **Create grammar:** `verticals/my_vertical/grammar/MyVertical_v0_85.g4`

3. **Create dictionary:** `verticals/my_vertical/dictionary/my_vertical_dictionary_v0.85.json`
   - Define vertical-specific actors, verbs, entities, and DataObjects

4. **Generate parsers:**
   ```bash
   ./utilities/generate_vertical_parsers.sh
   ```

5. **Create validators:**
   - Copy `verticals/banking/validators/python/dictionary_validator.py` as template
   - Customize for vertical-specific validation rules
   - Update imports to use vertical-specific generated parsers

6. **Create tests:**
   - Copy test structure from Banking vertical
   - Create test cases for vertical-specific validation rules

7. **Add examples:**
   - Create `.ebl` example files in `verticals/my_vertical/examples/`

---

## Notes

- **The parser generation script should be run from the `EBL_v0.85/` directory** (parent of utilities/)
- The script automatically handles relative paths and can also be run from within `utilities/`
- The parser generation script is critical for the ANTLR-based architecture
- After grammar changes, always regenerate parsers before running validators

---

**Version:** 0.85
**Architecture:** ANTLR-Based Vertical Independence
**Last Updated:** 05-11-2025
