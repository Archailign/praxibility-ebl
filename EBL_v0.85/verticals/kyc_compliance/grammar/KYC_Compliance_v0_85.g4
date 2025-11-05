/*
 * KYC & AML Compliance Domain Specific Language (EBL v0.85)
 * Vertical: KYC/Compliance
 * Description: Grammar for KYC, AML, Sanctions Screening, Transaction Monitoring, and Regulatory Reporting
 */

grammar KYC_Compliance_v0_85;

eblDefinition: metadata dataObject+ entity+ (itAsset | process | ruleDef | relationshipDef | report | integration)* EOF;
metadata:'Metadata' ':' NL+ (metadataField NL+)*; metadataField: IDENTIFIER ':' value;
dataObject:'DataObject' IDENTIFIER '{' NL+ 'Schema' ':' NL+ fieldDef+ 'Policies' ':' NL+ policyDef+ 'Resources' ':' NL+ resourceBlock 'erMap' ':' IDENTIFIER NL+ '}';
fieldDef: IDENTIFIER ':' type (',' fieldAttr)* NL+; policyDef: '-' TEXT NL+;
resourceBlock:'Input' ':' resourceDef NL+ 'Output' ':' resourceDef NL+;
resourceDef:'{' 'Channel' ':' IDENTIFIER ',' 'Protocol' ':' IDENTIFIER ',' 'Endpoint' ':' STRING ',' 'Auth' ':' IDENTIFIER ',' 'Format' ':' IDENTIFIER ',' 'SLA' ':' STRING '}';
entity:'Entity' IDENTIFIER '{' NL+ 'dataRef' ':' IDENTIFIER NL+ 'Properties' ':' NL+ property+ ('Rules' ':' NL+ ruleStatement+)? 'erMap' ':' IDENTIFIER NL+ '}';
property: IDENTIFIER ':' propertyDef NL+; propertyDef:'{' 'type' ':' type (',' propertyAttr)* '}';
propertyAttr:'required' ':' BOOLEAN | 'unique' ':' BOOLEAN | 'default' ':' value | 'values' ':' '[' value (',' value)* ']';
ruleStatement: '-' STRING NL+;
itAsset:'ITAsset' IDENTIFIER '{' NL+ 'Kind' ':' ('Application'|'System'|'Platform') NL+ 'Attributes' ':' NL+ kvPair+ ('Relationships' ':' NL+ relRef+)? ('erMap' ':' IDENTIFIER NL+)? '}';
kvPair: IDENTIFIER ':' TEXT NL+; relRef: '-' IDENTIFIER '(' IDENTIFIER (',' IDENTIFIER)? ')' 'Type' ':' IDENTIFIER NL+;
relationshipDef:'Relationship' IDENTIFIER '{' NL+ 'From' ':' IDENTIFIER NL+ 'To' ':' IDENTIFIER NL+ 'Type' ':' IDENTIFIER NL+ ('Attributes' ':' NL+ kvPair+)? ('erMap' ':' IDENTIFIER NL+)? '}';
process:'Process' IDENTIFIER '{' NL+ 'Description' ':' STRING NL+ 'ObjectiveID' ':' IDENTIFIER NL+ 'BusinessGoalID' ':' IDENTIFIER NL+ 'Actors' ':' '[' IDENTIFIER (',' IDENTIFIER)* ']' NL+ 'erMap' ':' IDENTIFIER NL+ 'Starts With' ':' event NL+ step+ 'Ends With' ':' event NL+ '}';
step:'Step' IDENTIFIER '{' NL+ ('Inputs' ':' NL+ inputItem+)? ('Validation' ':' NL+ validation+)? ('Condition' ':' TEXT NL+)? ('Actions' ':' NL+ action+)? ('ErrorHandling' ':' NL+ errorAction+)? ('Output' ':' output NL+)? '}';
inputItem: '-' IDENTIFIER ('.' IDENTIFIER)* NL+; validation: '-' TEXT NL+; action: '-' TEXT NL+; errorAction: '-' TEXT NL+;
output: IDENTIFIER ':' typeDef; typeDef: type | 'Partial' '<' IDENTIFIER '>' | '{' IDENTIFIER ':' type '}'; event: 'Event' IDENTIFIER '(' (IDENTIFIER (',' IDENTIFIER)*)? ')';
ruleDef:'Rule' IDENTIFIER '{' NL+ 'Description' ':' STRING NL+ 'Trigger' ':' TEXT NL+ ('Conditions' ':' NL+ TEXT NL+)* 'Actions' ':' NL+ action+ 'erMap' ':' IDENTIFIER NL+ '}';
report:'Report' IDENTIFIER '{' NL+ 'Description' ':' STRING NL+ 'Query' ':' TEXT NL+ 'Schedule' ':' STRING NL+ 'erMap' ':' IDENTIFIER NL+ '}';
integration:'Integration' IDENTIFIER '{' NL+ 'Provider' ':' IDENTIFIER NL+ 'Credentials' ':' IDENTIFIER NL+ 'Operations' ':' NL+ operation+ 'ErrorHandling' ':' NL+ errorAction+ 'erMap' ':' IDENTIFIER NL+ '}';
operation: '-' IDENTIFIER '(' (IDENTIFIER (',' IDENTIFIER)*)? ')' NL+;

type:'UUID'|'String'|'Integer'|'Currency'|'Ratio'|'Date'|'Enum'|'JSON'|'Boolean'|'RiskScore'|'ScreeningResult';
fieldAttr:'required'|'unique'|'min' '=' NUMBER|'max' '=' NUMBER|'values' '=' '[' value (',' value)* ']'|'pii'|'encrypted'|'redacted';
value: STRING|NUMBER|UUID|DATE|ENUM|BOOLEAN;

// KYC/AML-specific keywords
KYC: 'KYC' | 'KNOW_YOUR_CUSTOMER';
CDD: 'CDD' | 'CUSTOMER_DUE_DILIGENCE';
EDD: 'EDD' | 'ENHANCED_DUE_DILIGENCE';
SDD: 'SDD' | 'SIMPLIFIED_DUE_DILIGENCE';
AML: 'AML' | 'ANTI_MONEY_LAUNDERING';
CFT: 'CFT' | 'COUNTER_TERRORIST_FINANCING';
PEP: 'PEP' | 'POLITICALLY_EXPOSED_PERSON';
UBO: 'UBO' | 'ULTIMATE_BENEFICIAL_OWNER';
SOF: 'SOF' | 'SOURCE_OF_FUNDS';
SOW: 'SOW' | 'SOURCE_OF_WEALTH';
SAR: 'SAR' | 'SUSPICIOUS_ACTIVITY_REPORT';
CTR: 'CTR' | 'CURRENCY_TRANSACTION_REPORT';
FINCEN: 'FinCEN' | 'FINCEN';
OFAC: 'OFAC';
SDN: 'SDN' | 'SPECIALLY_DESIGNATED_NATIONAL';
FATF: 'FATF';
SANCTIONS: 'SANCTIONS';
WATCH_LIST: 'WATCH_LIST' | 'WATCHLIST';
ADVERSE_MEDIA: 'ADVERSE_MEDIA';
SMURFING: 'SMURFING';
STRUCTURING: 'STRUCTURING';
LAYERING: 'LAYERING';
TRANSACTION_MONITORING: 'TRANSACTION_MONITORING';
NAME_SCREENING: 'NAME_SCREENING';
FALSE_POSITIVE: 'FALSE_POSITIVE';
TRUE_POSITIVE: 'TRUE_POSITIVE';
ALERT: 'ALERT';
CASE: 'CASE';
ESCALATION: 'ESCALATION';

STRING:'"' (~["\r\n])* '"'; TEXT: ~[\r\n]+; ENUM:'[' IDENTIFIER (',' IDENTIFIER)* ']';
UUID:[0-9a-fA-F]{8} '-' [0-9a-fA-F]{4} '-' [0-9a-fA-F]{4} '-' [0-9a-fA-F]{4} '-' [0-9a-fA-F]{12};
DATE:[0-9]{4} '-' [0-9]{2} '-' [0-9]{2}; NUMBER:[0-9]+ ('.' [0-9]+)?; BOOLEAN:'true'|'false';
IDENTIFIER:[a-zA-Z_][a-zA-Z0-9_]*; NL: ('\r'? '\n')+; WS:[ \t]+ -> skip; LINE_COMMENT:'//' ~[\r\n]* -> skip; BLOCK_COMMENT:'/*' .*? '*/' -> skip;
