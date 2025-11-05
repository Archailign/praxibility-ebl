/*
 * Healthcare & Life Sciences Domain Specific Language (EBL v0.85)
 * Vertical: Healthcare
 * Description: Grammar for Clinical Care, EHR, Pharmacy, Medical Devices, Clinical Trials, and Health Insurance
 */

grammar Healthcare_v0_85;

// ===== PARSER RULES =====

eblDefinition
    : metadata dataObject+ entity+ (itAsset | process | ruleDef | relationshipDef | report | integration)* EOF
    ;

metadata
    : 'Metadata' ':' NL+ (metadataField NL+)*
    ;

metadataField
    : IDENTIFIER ':' value
    ;

dataObject
    : 'DataObject' IDENTIFIER '{' NL+
      'Schema' ':' NL+
      fieldDef+
      'Policies' ':' NL+
      policyDef+
      'Resources' ':' NL+
      resourceBlock
      'erMap' ':' IDENTIFIER NL+
      '}'
    ;

fieldDef
    : IDENTIFIER ':' type (',' fieldAttr)* NL+
    ;

policyDef
    : '-' TEXT NL+
    ;

resourceBlock
    : 'Input' ':' resourceDef NL+
      'Output' ':' resourceDef NL+
    ;

resourceDef
    : '{' 'Channel' ':' IDENTIFIER ','
      'Protocol' ':' IDENTIFIER ','
      'Endpoint' ':' STRING ','
      'Auth' ':' IDENTIFIER ','
      'Format' ':' IDENTIFIER ','
      'SLA' ':' STRING '}'
    ;

entity
    : 'Entity' IDENTIFIER '{' NL+
      'dataRef' ':' IDENTIFIER NL+
      'Properties' ':' NL+
      property+
      ('Rules' ':' NL+ ruleStatement+)?
      'erMap' ':' IDENTIFIER NL+
      '}'
    ;

property
    : IDENTIFIER ':' propertyDef NL+
    ;

propertyDef
    : '{' 'type' ':' type (',' propertyAttr)* '}'
    ;

propertyAttr
    : 'required' ':' BOOLEAN
    | 'unique' ':' BOOLEAN
    | 'default' ':' value
    | 'values' ':' '[' value (',' value)* ']'
    ;

ruleStatement
    : '-' STRING NL+
    ;

itAsset
    : 'ITAsset' IDENTIFIER '{' NL+
      'Kind' ':' ('Application'|'System'|'Platform') NL+
      'Attributes' ':' NL+
      kvPair+
      ('Relationships' ':' NL+ relRef+)?
      ('erMap' ':' IDENTIFIER NL+)?
      '}'
    ;

kvPair
    : IDENTIFIER ':' TEXT NL+
    ;

relRef
    : '-' IDENTIFIER '(' IDENTIFIER (',' IDENTIFIER)? ')' 'Type' ':' IDENTIFIER NL+
    ;

relationshipDef
    : 'Relationship' IDENTIFIER '{' NL+
      'From' ':' IDENTIFIER NL+
      'To' ':' IDENTIFIER NL+
      'Type' ':' IDENTIFIER NL+
      ('Attributes' ':' NL+ kvPair+)?
      ('erMap' ':' IDENTIFIER NL+)?
      '}'
    ;

process
    : 'Process' IDENTIFIER '{' NL+
      'Description' ':' STRING NL+
      'ObjectiveID' ':' IDENTIFIER NL+
      'BusinessGoalID' ':' IDENTIFIER NL+
      'Actors' ':' '[' IDENTIFIER (',' IDENTIFIER)* ']' NL+
      'erMap' ':' IDENTIFIER NL+
      'Starts With' ':' event NL+
      step+
      'Ends With' ':' event NL+
      '}'
    ;

step
    : 'Step' IDENTIFIER '{' NL+
      ('Inputs' ':' NL+ inputItem+)?
      ('Validation' ':' NL+ validation+)?
      ('Condition' ':' TEXT NL+)?
      ('Actions' ':' NL+ action+)?
      ('ErrorHandling' ':' NL+ errorAction+)?
      ('Output' ':' output NL+)?
      '}'
    ;

inputItem
    : '-' IDENTIFIER ('.' IDENTIFIER)* NL+
    ;

validation
    : '-' TEXT NL+
    ;

action
    : '-' TEXT NL+
    ;

errorAction
    : '-' TEXT NL+
    ;

output
    : IDENTIFIER ':' typeDef
    ;

typeDef
    : type
    | 'Partial' '<' IDENTIFIER '>'
    | '{' IDENTIFIER ':' type '}'
    ;

event
    : 'Event' IDENTIFIER '(' (IDENTIFIER (',' IDENTIFIER)*)? ')'
    ;

ruleDef
    : 'Rule' IDENTIFIER '{' NL+
      'Description' ':' STRING NL+
      'Trigger' ':' TEXT NL+
      ('Conditions' ':' NL+ TEXT NL+)*
      'Actions' ':' NL+
      action+
      'erMap' ':' IDENTIFIER NL+
      '}'
    ;

report
    : 'Report' IDENTIFIER '{' NL+
      'Description' ':' STRING NL+
      'Query' ':' TEXT NL+
      'Schedule' ':' STRING NL+
      'erMap' ':' IDENTIFIER NL+
      '}'
    ;

integration
    : 'Integration' IDENTIFIER '{' NL+
      'Provider' ':' IDENTIFIER NL+
      'Credentials' ':' IDENTIFIER NL+
      'Operations' ':' NL+
      operation+
      'ErrorHandling' ':' NL+
      errorAction+
      'erMap' ':' IDENTIFIER NL+
      '}'
    ;

operation
    : '-' IDENTIFIER '(' (IDENTIFIER (',' IDENTIFIER)*)? ')' NL+
    ;

// ===== TYPE SYSTEM =====

type
    : 'UUID'
    | 'String'
    | 'Integer'
    | 'Currency'
    | 'Ratio'
    | 'Date'
    | 'Enum'
    | 'JSON'
    | 'Boolean'
    | 'MRN'         // Healthcare-specific: Medical Record Number
    | 'ICD10'       // Healthcare-specific: Diagnosis code
    | 'CPT'         // Healthcare-specific: Procedure code
    | 'NDC'         // Healthcare-specific: Drug code
    | 'LOINC'       // Healthcare-specific: Lab test code
    | 'SNOMED'      // Healthcare-specific: Clinical terminology
    | 'NPI'         // Healthcare-specific: Provider ID
    | 'FHIR'        // Healthcare-specific: FHIR resource
    ;

fieldAttr
    : 'required'
    | 'unique'
    | 'min' '=' NUMBER
    | 'max' '=' NUMBER
    | 'values' '=' '[' value (',' value)* ']'
    | 'phi'           // Healthcare-specific: Protected Health Information
    | 'hipaa_compliant' // Healthcare-specific
    | 'de_identified' // Healthcare-specific
    | 'encrypted'     // Healthcare-specific
    ;

value
    : STRING
    | NUMBER
    | UUID
    | DATE
    | ENUM
    | BOOLEAN
    ;

// ===== HEALTHCARE-SPECIFIC KEYWORDS =====

// Clinical Keywords
STAT: 'STAT';
ASAP: 'ASAP';
PRN: 'PRN';
QD: 'QD';
BID: 'BID';
TID: 'TID';
QID: 'QID';
NPO: 'NPO';
DNR: 'DNR';
CODE_BLUE: 'CODE_BLUE';
LEVEL_1_TRAUMA: 'LEVEL_1_TRAUMA';

// HIPAA Keywords
HIPAA_COMPLIANT: 'HIPAA_COMPLIANT';
PHI: 'PHI' | 'PROTECTED_HEALTH_INFORMATION';
PII_HC: 'PII';
EPHI: 'ePHI' | 'ELECTRONIC_PHI';
BAA: 'BAA' | 'BUSINESS_ASSOCIATE_AGREEMENT';
NPP: 'NPP' | 'NOTICE_OF_PRIVACY_PRACTICES';
AUTHORIZATION: 'AUTHORIZATION' | 'HIPAA_AUTHORIZATION';
BREACH_NOTIFICATION: 'BREACH_NOTIFICATION';

// Standards
HL7: 'HL7' | 'HL7_V2' | 'HL7_V3';
FHIR_KW: 'FHIR' | 'FHIR_R4' | 'FHIR_R5';
DICOM: 'DICOM';
X12: 'X12' | 'EDI_X12';
CCD: 'CCD' | 'CONTINUITY_OF_CARE_DOCUMENT';
CCDA: 'CCDA' | 'CCD_A';

// Coding Systems
ICD10: 'ICD10' | 'ICD_10' | 'ICD_10_CM' | 'ICD_10_PCS';
ICD9: 'ICD9' | 'ICD_9';
CPT: 'CPT' | 'CPT_CODE';
HCPCS: 'HCPCS';
NDC: 'NDC' | 'NATIONAL_DRUG_CODE';
LOINC: 'LOINC';
SNOMED_CT: 'SNOMED' | 'SNOMED_CT';
RXNORM: 'RXNORM';

// Identifiers
NPI: 'NPI' | 'NATIONAL_PROVIDER_IDENTIFIER';
MRN: 'MRN' | 'MEDICAL_RECORD_NUMBER';
ENCOUNTER_ID: 'ENCOUNTER_ID';

// Claim Types
CMS_1500: 'CMS_1500';
UB_04: 'UB_04' | 'CMS_1450';
EDI_837: '837' | 'EDI_837' | '837I' | '837P';
EDI_835: '835' | 'EDI_835';
EDI_270: '270' | 'EDI_270';
EDI_271: '271' | 'EDI_271';

// Clinical Trial
ICH_GCP: 'ICH_GCP' | 'ICH_E6';
INFORMED_CONSENT: 'INFORMED_CONSENT';
IRB: 'IRB' | 'INSTITUTIONAL_REVIEW_BOARD';
SAE: 'SAE' | 'SERIOUS_ADVERSE_EVENT';
AE: 'AE' | 'ADVERSE_EVENT';

// ===== LEXER RULES =====

STRING
    : '"' (~["\r\n])* '"'
    ;

TEXT
    : ~[\r\n]+
    ;

ENUM
    : '[' IDENTIFIER (',' IDENTIFIER)* ']'
    ;

UUID
    : [0-9a-fA-F]{8} '-' [0-9a-fA-F]{4} '-' [0-9a-fA-F]{4} '-' [0-9a-fA-F]{4} '-' [0-9a-fA-F]{12}
    ;

DATE
    : [0-9]{4} '-' [0-9]{2} '-' [0-9]{2}
    ;

NUMBER
    : [0-9]+ ('.' [0-9]+)?
    ;

BOOLEAN
    : 'true'
    | 'false'
    ;

IDENTIFIER
    : [a-zA-Z_][a-zA-Z0-9_]*
    ;

NL
    : ('\r'? '\n')+
    ;

WS
    : [ \t]+ -> skip
    ;

LINE_COMMENT
    : '//' ~[\r\n]* -> skip
    ;

BLOCK_COMMENT
    : '/*' .*? '*/' -> skip
    ;
