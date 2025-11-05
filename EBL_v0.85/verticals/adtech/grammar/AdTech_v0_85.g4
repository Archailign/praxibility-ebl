/*
 * AdTech & Digital Advertising Domain Specific Language (EBL v0.85)
 * Vertical: AdTech
 * Description: Grammar for Programmatic Advertising, RTB, DSP/SSP/DMP, Attribution, and Privacy
 */

grammar AdTech_v0_85;

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

type:'UUID'|'String'|'Integer'|'Currency'|'Ratio'|'Date'|'Enum'|'JSON'|'Boolean'|'DeviceID'|'CookieID'|'UnifiedID';
fieldAttr:'required'|'unique'|'min' '=' NUMBER|'max' '=' NUMBER|'values' '=' '[' value (',' value)* ']'|'pii'|'consent_required';
value: STRING|NUMBER|UUID|DATE|ENUM|BOOLEAN;

// AdTech-specific keywords
RTB: 'RTB' | 'REAL_TIME_BIDDING';
PROGRAMMATIC: 'PROGRAMMATIC';
DSP: 'DSP' | 'DEMAND_SIDE_PLATFORM';
SSP: 'SSP' | 'SUPPLY_SIDE_PLATFORM';
DMP: 'DMP' | 'DATA_MANAGEMENT_PLATFORM';
AD_EXCHANGE: 'AD_EXCHANGE';
CPM: 'CPM' | 'COST_PER_MILLE';
CPC: 'CPC' | 'COST_PER_CLICK';
CPA: 'CPA' | 'COST_PER_ACQUISITION';
ECPM: 'ECPM' | 'EFFECTIVE_CPM';
VIEWABILITY: 'VIEWABILITY';
VIEWABLE_IMPRESSION: 'VIEWABLE_IMPRESSION';
IVT: 'IVT' | 'INVALID_TRAFFIC';
CTR: 'CTR' | 'CLICK_THROUGH_RATE';
CVR: 'CVR' | 'CONVERSION_RATE';
VCR: 'VCR' | 'VIDEO_COMPLETION_RATE';
ROAS: 'ROAS' | 'RETURN_ON_AD_SPEND';
ATTRIBUTION: 'ATTRIBUTION';
MULTI_TOUCH_ATTRIBUTION: 'MULTI_TOUCH_ATTRIBUTION' | 'MTA';
RETARGETING: 'RETARGETING' | 'REMARKETING';
FREQUENCY_CAP: 'FREQUENCY_CAP';
HEADER_BIDDING: 'HEADER_BIDDING';
WATERFALL: 'WATERFALL';
OPEN_RTB: 'OPEN_RTB';
NATIVE_AD: 'NATIVE_AD';
VIDEO_AD: 'VIDEO_AD';
DISPLAY_AD: 'DISPLAY_AD';
PMP: 'PMP' | 'PRIVATE_MARKETPLACE';
FIRST_PRICE_AUCTION: 'FIRST_PRICE_AUCTION';
CONTEXTUAL_TARGETING: 'CONTEXTUAL_TARGETING';
BEHAVIORAL_TARGETING: 'BEHAVIORAL_TARGETING';
ID_SYNC: 'ID_SYNC' | 'COOKIE_SYNC';
COOKIELESS: 'COOKIELESS';
BRAND_SAFETY: 'BRAND_SAFETY';
FRAUD: 'FRAUD';

STRING:'"' (~["\r\n])* '"'; TEXT: ~[\r\n]+; ENUM:'[' IDENTIFIER (',' IDENTIFIER)* ']';
UUID:[0-9a-fA-F]{8} '-' [0-9a-fA-F]{4} '-' [0-9a-fA-F]{4} '-' [0-9a-fA-F]{4} '-' [0-9a-fA-F]{12};
DATE:[0-9]{4} '-' [0-9]{2} '-' [0-9]{2}; NUMBER:[0-9]+ ('.' [0-9]+)?; BOOLEAN:'true'|'false';
IDENTIFIER:[a-zA-Z_][a-zA-Z0-9_]*; NL: ('\r'? '\n')+; WS:[ \t]+ -> skip; LINE_COMMENT:'//' ~[\r\n]* -> skip; BLOCK_COMMENT:'/*' .*? '*/' -> skip;
