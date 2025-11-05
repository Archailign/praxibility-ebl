/*
 * Banking & Payments Domain Specific Language (EBL v0.85)
 * Vertical: Banking
 * Description: Grammar for Banking, Payments, Cards, Lending, Treasury, and Trade Finance
 */

grammar Banking_v0_85;

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
    | 'IBAN'        // Banking-specific
    | 'SWIFT'       // Banking-specific
    | 'BIC'         // Banking-specific
    | 'CardNumber'  // Banking-specific
    | 'CVV'         // Banking-specific
    | 'AccountNumber' // Banking-specific
    ;

fieldAttr
    : 'required'
    | 'unique'
    | 'min' '=' NUMBER
    | 'max' '=' NUMBER
    | 'values' '=' '[' value (',' value)* ']'
    | 'masked'      // Banking-specific for PII/PCI
    | 'encrypted'   // Banking-specific for sensitive data
    | 'pci_compliant' // Banking-specific
    ;

value
    : STRING
    | NUMBER
    | UUID
    | DATE
    | ENUM
    | BOOLEAN
    ;

// ===== BANKING-SPECIFIC KEYWORDS =====

// Reserved keywords from dictionary
SWIFT_CODE: 'SWIFT' | 'SWIFT_BIC';
IBAN_CODE: 'IBAN';
RTGS: 'RTGS' | 'REAL_TIME_GROSS_SETTLEMENT';
ACH: 'ACH' | 'AUTOMATED_CLEARING_HOUSE';
SEPA: 'SEPA' | 'SEPA_CREDIT_TRANSFER' | 'SEPA_DIRECT_DEBIT';
FEDWIRE: 'FEDWIRE';
CHAPS: 'CHAPS';
TARGET2: 'TARGET2';
CHIPS: 'CHIPS';

PCI_DSS: 'PCI_DSS' | 'PCI_COMPLIANT';
PII: 'PII' | 'PERSONALLY_IDENTIFIABLE_INFORMATION';
KYC: 'KYC' | 'KNOW_YOUR_CUSTOMER';
AML: 'AML' | 'ANTI_MONEY_LAUNDERING';
CFT: 'CFT' | 'COUNTER_TERRORIST_FINANCING';

CARD_NETWORK: 'VISA' | 'MASTERCARD' | 'AMEX' | 'DISCOVER' | 'JCB' | 'UNIONPAY';
EMV: 'EMV' | 'EMV_CHIP';
NFC: 'NFC' | 'CONTACTLESS';
TOKENIZATION: 'TOKENIZATION' | 'TOKEN';
PAN: 'PAN' | 'PRIMARY_ACCOUNT_NUMBER';
CVV_KEYWORD: 'CVV' | 'CVV2' | 'CVC' | 'CVC2';

TRANSACTION_STATUS: 'PENDING' | 'AUTHORIZED' | 'SETTLED' | 'DECLINED' | 'REVERSED' | 'CHARGEBACK';
PAYMENT_METHOD: 'CARD' | 'ACH' | 'WIRE' | 'CHECK' | 'CASH' | 'DIGITAL_WALLET';

APR: 'APR' | 'ANNUAL_PERCENTAGE_RATE';
APY: 'APY' | 'ANNUAL_PERCENTAGE_YIELD';
DTI: 'DTI' | 'DEBT_TO_INCOME';
LTV: 'LTV' | 'LOAN_TO_VALUE';
FICO: 'FICO' | 'CREDIT_SCORE';

BASEL_III: 'BASEL_III' | 'BASEL3';
DODD_FRANK: 'DODD_FRANK';
SOX: 'SOX' | 'SARBANES_OXLEY';
FATCA: 'FATCA';
FBAR: 'FBAR';

T_PLUS_ZERO: 'T+0';
T_PLUS_ONE: 'T+1';
T_PLUS_TWO: 'T+2';

ISO20022: 'ISO20022' | 'ISO_20022';
FIX: 'FIX_PROTOCOL';
MT: 'MT103' | 'MT202' | 'MT700' | 'MT' [0-9]+;
MX: 'MX' | 'MX_MESSAGE';

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
