"""
Banking Vertical - ANTLR-Based Dictionary Validator
Validates that Banking EBL files conform to the Banking dictionary constraints

Uses ANTLR-generated parsers for proper syntax parsing
"""

import sys
import json
import re
from pathlib import Path
from typing import Dict, List, Set, Optional
from dataclasses import dataclass

# Add generated parsers to path
generated_path = Path(__file__).parent.parent.parent / 'generated' / 'python'
sys.path.insert(0, str(generated_path))

from antlr4 import FileStream, CommonTokenStream, ParseTreeWalker
from Banking_v0_85Lexer import Banking_v0_85Lexer
from Banking_v0_85Parser import Banking_v0_85Parser
from Banking_v0_85Listener import Banking_v0_85Listener


def canonicalize(s: str) -> str:
    """Canonicalize string for comparison (lowercase, alphanumeric only)"""
    return re.sub(r'[^A-Za-z0-9_]+', '', s or '').lower()


@dataclass
class ValidationIssue:
    """Represents a validation issue"""
    severity: str  # 'error' or 'warning'
    rule: str      # Rule identifier (e.g., 'DICT-001')
    message: str
    suggestion: Optional[str] = None
    line: Optional[int] = None


class BankingDictionary:
    """Loads and provides access to Banking dictionary"""

    def __init__(self, dictionary_path: str):
        """Load banking dictionary from JSON file"""
        with open(dictionary_path, 'r') as f:
            self.dict = json.load(f)

        # Load core components
        core = self.dict.get("core", {})
        self.reserved_keywords = set(k.upper() for k in core.get("keywords", {}).get("reserved", []))
        self.verb_permissions = {canonicalize(k): v.lower() for k, v in core.get("verbPermissions", {}).items()}
        self.relationship_types = set(canonicalize(x) for x in core.get("relationshipTypes", []))

        # Load domain components
        domain = self.dict.get("domain", {})
        self.actors = set(canonicalize(a) for a in domain.get("actors", []))
        self.verbs = set(canonicalize(v) for v in domain.get("verbs", []))
        self.entities = set(canonicalize(e) for e in domain.get("entities", []))
        self.data_objects = set(canonicalize(d) for d in domain.get("dataObjects", []))

        # Actor-verb mappings
        self.actor_verbs: Dict[str, Set[str]] = {}
        for actor, verb_list in domain.get("actorVerbs", {}).items():
            self.actor_verbs[canonicalize(actor)] = set(canonicalize(v) for v in verb_list)

        # Actor data permissions
        self.actor_read_perms: Dict[str, Set[str]] = {}
        self.actor_write_perms: Dict[str, Set[str]] = {}
        for actor, perms in domain.get("actorDataPerms", {}).items():
            actor_canon = canonicalize(actor)
            if "read" in perms:
                self.actor_read_perms[actor_canon] = set(canonicalize(d) for d in perms["read"])
            if "write" in perms:
                self.actor_write_perms[actor_canon] = set(canonicalize(d) for d in perms["write"])

        # Union of all permitted verbs
        self.all_permitted_verbs = set()
        for verb_set in self.actor_verbs.values():
            self.all_permitted_verbs.update(verb_set)

    def has_actor(self, actor: str) -> bool:
        """Check if actor exists in dictionary"""
        return canonicalize(actor) in self.actors

    def has_verb(self, verb: str) -> bool:
        """Check if verb exists in dictionary"""
        return canonicalize(verb) in self.verbs

    def has_entity(self, entity: str) -> bool:
        """Check if entity exists in dictionary"""
        return canonicalize(entity) in self.entities

    def has_data_object(self, data_object: str) -> bool:
        """Check if DataObject exists in dictionary"""
        return canonicalize(data_object) in self.data_objects

    def actor_allows_verb(self, actor: str, verb: str) -> bool:
        """Check if actor is allowed to perform verb"""
        actor_canon = canonicalize(actor)
        allowed_verbs = self.actor_verbs.get(actor_canon)
        if not allowed_verbs:  # If no whitelist, allow all
            return True
        return canonicalize(verb) in allowed_verbs

    def verb_permitted_by_any(self, verb: str) -> bool:
        """Check if verb is permitted by at least one actor"""
        return canonicalize(verb) in self.all_permitted_verbs if self.all_permitted_verbs else True

    def actor_can_read(self, actor: str, data_object: str) -> bool:
        """Check if actor has read permission on DataObject"""
        actor_canon = canonicalize(actor)
        read_perms = self.actor_read_perms.get(actor_canon)
        if not read_perms:  # If no explicit perms, allow
            return True
        return canonicalize(data_object) in read_perms

    def actor_can_write(self, actor: str, data_object: str) -> bool:
        """Check if actor has write permission on DataObject"""
        actor_canon = canonicalize(actor)
        write_perms = self.actor_write_perms.get(actor_canon)
        if not write_perms:  # If no explicit perms, allow
            return True
        return canonicalize(data_object) in write_perms

    def is_relationship_type(self, rel_type: str) -> bool:
        """Check if relationship type is valid"""
        return canonicalize(rel_type) in self.relationship_types

    def get_verb_permission(self, verb: str) -> Optional[str]:
        """Get required permission (read/write) for verb"""
        return self.verb_permissions.get(canonicalize(verb))


class BankingDictionaryValidator(Banking_v0_85Listener):
    """ANTLR-based Banking dictionary validator"""

    def __init__(self, dictionary: BankingDictionary):
        """Initialize validator with banking dictionary"""
        self.dictionary = dictionary
        self.errors: List[ValidationIssue] = []
        self.warnings: List[ValidationIssue] = []

        # Track defined elements for cross-reference validation
        self.defined_data_objects = set()
        self.defined_entities = set()
        self.defined_it_assets = set()

        # Track process scope for actor usage validation
        self.process_stack = []  # Stack of (declared_actors, used_actors)

    def enterDataObject(self, ctx: Banking_v0_85Parser.DataObjectContext):
        """Validate DataObject definition"""
        if ctx.IDENTIFIER():
            data_object_name = ctx.IDENTIFIER(0).getText()
            self.defined_data_objects.add(data_object_name)

            # Check if DataObject is in dictionary
            if not self.dictionary.has_data_object(data_object_name):
                self.warnings.append(ValidationIssue(
                    severity='warning',
                    rule='DICT-DO-001',
                    message=f"DataObject '{data_object_name}' not found in banking dictionary",
                    suggestion="Consider adding to dictionary if this is a standard banking DataObject"
                ))

    def enterEntity(self, ctx: Banking_v0_85Parser.EntityContext):
        """Validate Entity definition"""
        if ctx.IDENTIFIER():
            entity_name = ctx.IDENTIFIER(0).getText()
            self.defined_entities.add(entity_name)

            # Check if Entity is in dictionary
            if not self.dictionary.has_entity(entity_name):
                self.warnings.append(ValidationIssue(
                    severity='warning',
                    rule='DICT-ENT-001',
                    message=f"Entity '{entity_name}' not found in banking dictionary",
                    suggestion="Consider adding to dictionary if this is a standard banking entity"
                ))

            # Validate dataRef
            if len(ctx.IDENTIFIER()) > 1:
                data_ref = ctx.IDENTIFIER(1).getText()
                if data_ref not in self.defined_data_objects:
                    self.errors.append(ValidationIssue(
                        severity='error',
                        rule='DICT-ENT-002',
                        message=f"Entity '{entity_name}' references undefined DataObject '{data_ref}'",
                        suggestion=f"Define DataObject '{data_ref}' before referencing it"
                    ))

    def enterItAsset(self, ctx: Banking_v0_85Parser.ItAssetContext):
        """Validate ITAsset definition"""
        if ctx.IDENTIFIER():
            asset_name = ctx.IDENTIFIER(0).getText()
            self.defined_it_assets.add(asset_name)

    def enterProcess(self, ctx: Banking_v0_85Parser.ProcessContext):
        """Validate Process and track declared actors"""
        declared_actors = set()
        used_actors = set()

        # Extract declared actors from Actors: [...]
        text = ctx.getText()
        actors_match = re.search(r'Actors:\[(.*?)\]', text)
        if actors_match:
            actors_str = actors_match.group(1)
            for actor in actors_str.split(','):
                actor = actor.strip()
                if actor:
                    declared_actors.add(actor)

                    # Validate actor exists in dictionary
                    if not self.dictionary.has_actor(actor):
                        self.errors.append(ValidationIssue(
                            severity='error',
                            rule='DICT-ACT-001',
                            message=f"Actor '{actor}' not found in banking dictionary",
                            suggestion="Check spelling or add actor to banking dictionary"
                        ))

        self.process_stack.append((declared_actors, used_actors))

    def exitProcess(self, ctx: Banking_v0_85Parser.ProcessContext):
        """Check for unused actors at end of process"""
        if self.process_stack:
            declared_actors, used_actors = self.process_stack.pop()
            unused_actors = declared_actors - used_actors

            for actor in unused_actors:
                self.warnings.append(ValidationIssue(
                    severity='warning',
                    rule='DICT-ACT-002',
                    message=f"Actor '{actor}' declared in Process but never used in Actions",
                    suggestion="Remove unused actor or add actions using this actor"
                ))

    def enterAction(self, ctx: Banking_v0_85Parser.ActionContext):
        """Validate Action (actor-verb-dataobject patterns)"""
        text = ctx.getText()

        # Extract actor and verb from action pattern: "- Actor Verb ..."
        action_match = re.match(r'^-\s*([A-Za-z_][A-Za-z0-9_]*)\s+([A-Za-z][A-Za-z0-9_]*)\b', text)

        if not action_match:
            self.warnings.append(ValidationIssue(
                severity='warning',
                rule='DICT-ACT-003',
                message="Action missing explicit 'Actor Verb' prefix",
                suggestion="Use format: '- Actor Verb ...' for better clarity"
            ))
            return

        actor, verb = action_match.groups()

        # Mark actor as used
        if self.process_stack:
            _, used_actors = self.process_stack[-1]
            used_actors.add(actor)

        # Validate actor
        if not self.dictionary.has_actor(actor):
            self.warnings.append(ValidationIssue(
                severity='warning',
                rule='DICT-ACT-004',
                message=f"Actor '{actor}' in Action not found in banking dictionary"
            ))

        # Validate verb
        if not self.dictionary.has_verb(verb):
            self.warnings.append(ValidationIssue(
                severity='warning',
                rule='DICT-VERB-001',
                message=f"Verb '{verb}' not found in banking dictionary",
                suggestion="Common banking verbs: Transfer, Authorize, Settle, Screen, etc."
            ))

        # Check if verb is permitted by any actor
        if not self.dictionary.verb_permitted_by_any(verb):
            self.warnings.append(ValidationIssue(
                severity='warning',
                rule='DICT-VERB-002',
                message=f"Verb '{verb}' is never permitted by any actor in banking dictionary",
                suggestion="Add verb permission to at least one actor"
            ))

        # Check if this specific actor can perform this verb
        if not self.dictionary.actor_allows_verb(actor, verb):
            self.warnings.append(ValidationIssue(
                severity='warning',
                rule='DICT-VERB-003',
                message=f"Actor '{actor}' not permitted to perform verb '{verb}' by whitelist",
                suggestion=f"Add '{verb}' to actor '{actor}' permissions in dictionary"
            ))

        # Validate DataObject permissions
        required_perm = self.dictionary.get_verb_permission(verb)
        dataobject_pattern = r'\b(DO_[A-Za-z0-9_]+)\s*(Input|Output)?'
        for match in re.finditer(dataobject_pattern, text):
            data_object = match.group(1)
            io_qualifier = match.group(2)

            # Determine if Input (write) or Output (read)
            if io_qualifier is None and required_perm:
                io_qualifier = "Input" if required_perm == "write" else "Output"

            # Check permissions
            if io_qualifier == "Input":
                if not self.dictionary.actor_can_write(actor, data_object):
                    self.warnings.append(ValidationIssue(
                        severity='warning',
                        rule='DICT-PERM-001',
                        message=f"Actor '{actor}' lacks WRITE permission on '{data_object}'",
                        suggestion=f"Add write permission for '{actor}' on '{data_object}'"
                    ))
            elif io_qualifier == "Output":
                if not self.dictionary.actor_can_read(actor, data_object):
                    self.warnings.append(ValidationIssue(
                        severity='warning',
                        rule='DICT-PERM-002',
                        message=f"Actor '{actor}' lacks READ permission on '{data_object}'",
                        suggestion=f"Add read permission for '{actor}' on '{data_object}'"
                    ))

    def enterRelationshipDef(self, ctx: Banking_v0_85Parser.RelationshipDefContext):
        """Validate Relationship definition"""
        if ctx.IDENTIFIER() and len(ctx.IDENTIFIER()) >= 4:
            rel_name = ctx.IDENTIFIER(0).getText()
            from_entity = ctx.IDENTIFIER(1).getText()
            to_entity = ctx.IDENTIFIER(2).getText()
            rel_type = ctx.IDENTIFIER(3).getText()

            # Validate relationship type
            if not self.dictionary.is_relationship_type(rel_type):
                self.warnings.append(ValidationIssue(
                    severity='warning',
                    rule='DICT-REL-001',
                    message=f"Relationship '{rel_name}': Type '{rel_type}' not in banking dictionary",
                    suggestion=f"Valid types: {', '.join(sorted([t for t in self.dictionary.relationship_types]))}"
                ))

            # Validate from/to entities exist
            if from_entity not in self.defined_entities and from_entity not in self.defined_it_assets:
                self.warnings.append(ValidationIssue(
                    severity='warning',
                    rule='DICT-REL-002',
                    message=f"Relationship '{rel_name}': From '{from_entity}' not a defined Entity/ITAsset"
                ))

            if to_entity not in self.defined_entities and to_entity not in self.defined_it_assets:
                self.warnings.append(ValidationIssue(
                    severity='warning',
                    rule='DICT-REL-003',
                    message=f"Relationship '{rel_name}': To '{to_entity}' not a defined Entity/ITAsset"
                ))

    def get_errors(self) -> List[ValidationIssue]:
        """Get all validation errors"""
        return self.errors

    def get_warnings(self) -> List[ValidationIssue]:
        """Get all validation warnings"""
        return self.warnings


def validate_banking_file(ebl_file_path: str, dictionary_path: str) -> bool:
    """
    Validate a Banking EBL file against the banking dictionary

    Args:
        ebl_file_path: Path to .ebl file
        dictionary_path: Path to banking_dictionary_v0.85.json

    Returns:
        True if valid (no errors), False otherwise
    """
    # Load dictionary
    dictionary = BankingDictionary(dictionary_path)

    # Parse EBL file
    input_stream = FileStream(ebl_file_path, encoding='utf-8')
    lexer = Banking_v0_85Lexer(input_stream)
    token_stream = CommonTokenStream(lexer)
    parser = Banking_v0_85Parser(token_stream)
    tree = parser.eblDefinition()

    # Run validator
    validator = BankingDictionaryValidator(dictionary)
    walker = ParseTreeWalker()
    walker.walk(validator, tree)

    # Print report
    print("=" * 80)
    print("BANKING DICTIONARY VALIDATION REPORT")
    print("=" * 80)
    print(f"File: {ebl_file_path}")
    print(f"Dictionary: {dictionary_path}")
    print("=" * 80)

    errors = validator.get_errors()
    warnings = validator.get_warnings()

    if not errors and not warnings:
        print("\n✅ VALIDATION PASSED - No errors or warnings\n")
        print("=" * 80)
        return True

    if errors:
        print(f"\n❌ ERRORS ({len(errors)}):")
        for i, error in enumerate(errors, 1):
            print(f"\n  {i}. [{error.rule}] {error.message}")
            if error.suggestion:
                print(f"     💡 {error.suggestion}")

    if warnings:
        print(f"\n⚠️  WARNINGS ({len(warnings)}):")
        for i, warning in enumerate(warnings, 1):
            print(f"\n  {i}. [{warning.rule}] {warning.message}")
            if warning.suggestion:
                print(f"     💡 {warning.suggestion}")

    print("\n" + "=" * 80)

    return len(errors) == 0


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python dictionary_validator.py <ebl_file> <dictionary_json>")
        print("\nExample:")
        print("  python dictionary_validator.py ../../examples/MortgageLoanApplication.ebl ../../dictionary/banking_dictionary_v0.85.json")
        sys.exit(1)

    ebl_file = sys.argv[1]
    dict_file = sys.argv[2]

    is_valid = validate_banking_file(ebl_file, dict_file)
    sys.exit(0 if is_valid else 1)
