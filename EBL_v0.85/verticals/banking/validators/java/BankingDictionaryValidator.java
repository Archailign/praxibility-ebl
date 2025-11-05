package com.archailign.ebl.banking.validators;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Banking Vertical - Dictionary Validator (Java)
 * Validates Banking EBL files against the banking_dictionary_v0.85.json
 *
 * @version 0.85
 * @author Archailign Business Engineering
 */
public class BankingDictionaryValidator {

    private final JsonNode dictionary;
    private final Set<String> actors;
    private final Set<String> verbs;
    private final Set<String> entities;
    private final Set<String> dataObjects;
    private final Map<String, List<String>> actorVerbs;
    private final Map<String, Map<String, List<String>>> actorDataPerms;
    private final Set<String> relationshipTypes;
    private final Set<String> bankingKeywords;

    private final List<ValidationIssue> errors;
    private final List<ValidationIssue> warnings;

    public BankingDictionaryValidator(String dictionaryPath) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        this.dictionary = mapper.readTree(new File(dictionaryPath));

        // Load dictionary components
        this.actors = loadSet(dictionary.path("domain").path("actors"));
        this.verbs = loadSet(dictionary.path("domain").path("verbs"));
        this.entities = loadSet(dictionary.path("domain").path("entities"));
        this.dataObjects = loadSet(dictionary.path("domain").path("dataObjects"));
        this.actorVerbs = loadActorVerbs(dictionary.path("domain").path("actorVerbs"));
        this.actorDataPerms = loadActorDataPerms(dictionary.path("domain").path("actorDataPerms"));
        this.relationshipTypes = loadSet(dictionary.path("core").path("relationshipTypes"));
        this.bankingKeywords = loadSet(dictionary.path("core").path("keywords").path("banking_specific"));

        this.errors = new ArrayList<>();
        this.warnings = new ArrayList<>();
    }

    /**
     * Validate an EBL file against the banking dictionary
     */
    public boolean validateFile(String eblFilePath) throws IOException {
        String content = Files.readString(Path.of(eblFilePath));
        return validateContent(content);
    }

    /**
     * Validate EBL content
     */
    public boolean validateContent(String content) {
        errors.clear();
        warnings.clear();

        validateActors(content);
        validateVerbs(content);
        validateEntities(content);
        validateDataObjects(content);
        validateRelationships(content);

        return errors.isEmpty();
    }

    private void validateActors(String content) {
        Pattern actorPattern = Pattern.compile("Actors\\s*:\\s*\\[([^\\]]+)\\]");
        Matcher matcher = actorPattern.matcher(content);

        while (matcher.find()) {
            String actorsList = matcher.group(1);
            String[] actorsInFile = actorsList.split(",");

            for (String actor : actorsInFile) {
                String trimmedActor = actor.trim();
                if (!trimmedActor.isEmpty() && !actors.contains(trimmedActor)) {
                    errors.add(new ValidationIssue(
                        "ERROR",
                        "Unknown actor '" + trimmedActor + "' not in banking dictionary",
                        "Available actors: " + actors.toString().substring(0, Math.min(200, actors.toString().length()))
                    ));
                }
            }
        }
    }

    private void validateVerbs(String content) {
        Pattern actionPattern = Pattern.compile("-\\s+(\\w+)\\s+");
        Matcher matcher = actionPattern.matcher(content);

        Set<String> systemKeywords = Set.of("Metadata", "DataObject", "Entity", "Process", "Step");

        while (matcher.find()) {
            String verb = matcher.group(1);
            if (!verbs.contains(verb) && !systemKeywords.contains(verb)) {
                warnings.add(new ValidationIssue(
                    "WARNING",
                    "Verb '" + verb + "' not found in banking dictionary",
                    "Common banking verbs: Transfer, Authorize, Settle, Screen, etc."
                ));
            }
        }
    }

    private void validateEntities(String content) {
        Pattern entityPattern = Pattern.compile("Entity\\s+(\\w+)\\s*\\{");
        Matcher matcher = entityPattern.matcher(content);

        while (matcher.find()) {
            String entity = matcher.group(1);
            if (!entities.contains(entity)) {
                warnings.add(new ValidationIssue(
                    "WARNING",
                    "Entity '" + entity + "' not in banking dictionary",
                    "Consider adding to dictionary if this is a new banking entity"
                ));
            }
        }
    }

    private void validateDataObjects(String content) {
        Pattern doPattern = Pattern.compile("DataObject\\s+(\\w+)\\s*\\{");
        Pattern dataRefPattern = Pattern.compile("dataRef\\s*:\\s*(\\w+)");

        // Check DataObject declarations
        Matcher doMatcher = doPattern.matcher(content);
        while (doMatcher.find()) {
            String dataObject = doMatcher.group(1);
            if (!dataObjects.contains(dataObject)) {
                warnings.add(new ValidationIssue(
                    "WARNING",
                    "DataObject '" + dataObject + "' not in banking dictionary",
                    "Banking DataObjects should start with DO_ prefix"
                ));
            }
        }

        // Check dataRef references
        Matcher refMatcher = dataRefPattern.matcher(content);
        while (refMatcher.find()) {
            String ref = refMatcher.group(1);
            if (!dataObjects.contains(ref)) {
                errors.add(new ValidationIssue(
                    "ERROR",
                    "dataRef '" + ref + "' references unknown DataObject",
                    "DataObject " + ref + " must be defined in the file"
                ));
            }
        }
    }

    private void validateRelationships(String content) {
        Pattern relTypePattern = Pattern.compile("Type\\s*:\\s*(\\w+)");
        Matcher matcher = relTypePattern.matcher(content);

        Set<String> systemTypes = Set.of("Application", "System", "Platform");

        while (matcher.find()) {
            String relType = matcher.group(1);
            if (!relationshipTypes.contains(relType) && !systemTypes.contains(relType)) {
                warnings.add(new ValidationIssue(
                    "WARNING",
                    "Relationship type '" + relType + "' not in banking dictionary",
                    "Valid types: " + String.join(", ", relationshipTypes)
                ));
            }
        }
    }

    public String getValidationReport() {
        StringBuilder report = new StringBuilder();
        report.append("=".repeat(80)).append("\n");
        report.append("BANKING DICTIONARY VALIDATION REPORT\n");
        report.append("=".repeat(80)).append("\n");

        if (errors.isEmpty() && warnings.isEmpty()) {
            report.append("\n✅ VALIDATION PASSED - No errors or warnings\n");
        } else {
            if (!errors.isEmpty()) {
                report.append(String.format("\n❌ ERRORS (%d):\n", errors.size()));
                for (int i = 0; i < errors.size(); i++) {
                    ValidationIssue error = errors.get(i);
                    report.append(String.format("\n  %d. %s\n", i + 1, error.message));
                    if (error.context != null) {
                        report.append(String.format("     Context: %s\n", error.context));
                    }
                }
            }

            if (!warnings.isEmpty()) {
                report.append(String.format("\n⚠️  WARNINGS (%d):\n", warnings.size()));
                for (int i = 0; i < warnings.size(); i++) {
                    ValidationIssue warning = warnings.get(i);
                    report.append(String.format("\n  %d. %s\n", i + 1, warning.message));
                    if (warning.context != null) {
                        report.append(String.format("     Context: %s\n", warning.context));
                    }
                }
            }
        }

        report.append("\n").append("=".repeat(80)).append("\n");
        return report.toString();
    }

    public List<ValidationIssue> getErrors() {
        return Collections.unmodifiableList(errors);
    }

    public List<ValidationIssue> getWarnings() {
        return Collections.unmodifiableList(warnings);
    }

    // Helper methods
    private Set<String> loadSet(JsonNode node) {
        Set<String> result = new HashSet<>();
        if (node.isArray()) {
            node.forEach(item -> result.add(item.asText()));
        }
        return result;
    }

    private Map<String, List<String>> loadActorVerbs(JsonNode node) {
        Map<String, List<String>> result = new HashMap<>();
        node.fields().forEachRemaining(entry -> {
            List<String> verbs = new ArrayList<>();
            entry.getValue().forEach(verb -> verbs.add(verb.asText()));
            result.put(entry.getKey(), verbs);
        });
        return result;
    }

    private Map<String, Map<String, List<String>>> loadActorDataPerms(JsonNode node) {
        Map<String, Map<String, List<String>>> result = new HashMap<>();
        node.fields().forEachRemaining(entry -> {
            Map<String, List<String>> perms = new HashMap<>();
            entry.getValue().fields().forEachRemaining(permEntry -> {
                List<String> objects = new ArrayList<>();
                permEntry.getValue().forEach(obj -> objects.add(obj.asText()));
                perms.put(permEntry.getKey(), objects);
            });
            result.put(entry.getKey(), perms);
        });
        return result;
    }

    /**
     * Validation issue record
     */
    public static class ValidationIssue {
        public final String severity;
        public final String message;
        public final String context;

        public ValidationIssue(String severity, String message, String context) {
            this.severity = severity;
            this.message = message;
            this.context = context;
        }
    }

    /**
     * Main method for command-line usage
     */
    public static void main(String[] args) {
        if (args.length < 2) {
            System.err.println("Usage: java BankingDictionaryValidator <ebl_file> <dictionary_json>");
            System.exit(1);
        }

        String eblFile = args[0];
        String dictFile = args[1];

        try {
            BankingDictionaryValidator validator = new BankingDictionaryValidator(dictFile);
            boolean isValid = validator.validateFile(eblFile);
            System.out.println(validator.getValidationReport());
            System.exit(isValid ? 0 : 1);
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
            System.exit(1);
        }
    }
}
