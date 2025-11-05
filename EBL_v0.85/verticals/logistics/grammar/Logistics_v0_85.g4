/*
 * Logistics & Supply Chain Management Domain Specific Language (EBL v0.85)
 * Vertical: Logistics
 * Description: Grammar for Transportation, Warehousing, Freight, Customs, and Last-Mile Delivery
 */

grammar Logistics_v0_85;

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

type:'UUID'|'String'|'Integer'|'Currency'|'Ratio'|'Date'|'Enum'|'JSON'|'Boolean'|'TrackingNumber'|'BOL'|'AWB'|'HSCode';
fieldAttr:'required'|'unique'|'min' '=' NUMBER|'max' '=' NUMBER|'values' '=' '[' value (',' value)* ']'|'tracked'|'geo_tagged';
value: STRING|NUMBER|UUID|DATE|ENUM|BOOLEAN;

// Logistics-specific keywords
BOL: 'BOL' | 'BILL_OF_LADING';
AWB: 'AWB' | 'AIRWAY_BILL' | 'AIR_WAYBILL';
POD: 'POD' | 'PROOF_OF_DELIVERY';
ETA: 'ETA' | 'ESTIMATED_TIME_OF_ARRIVAL';
ETD: 'ETD' | 'ESTIMATED_TIME_OF_DEPARTURE';
LTL: 'LTL' | 'LESS_THAN_TRUCKLOAD';
FTL: 'FTL' | 'FULL_TRUCKLOAD';
FCL: 'FCL' | 'FULL_CONTAINER_LOAD';
LCL: 'LCL' | 'LESS_THAN_CONTAINER_LOAD';
TEU: 'TEU' | 'TWENTY_FOOT_EQUIVALENT';
CBM: 'CBM' | 'CUBIC_METER';
PALLET: 'PALLET';
CONTAINER: 'CONTAINER';
INTERMODAL: 'INTERMODAL';
CROSS_DOCK: 'CROSS_DOCK';
THREE_PL: '3PL' | 'THIRD_PARTY_LOGISTICS';
FOUR_PL: '4PL' | 'FOURTH_PARTY_LOGISTICS';
FREIGHT_FORWARDER: 'FREIGHT_FORWARDER';
CUSTOMS_BROKER: 'CUSTOMS_BROKER';
INCOTERMS: 'INCOTERMS';
FOB: 'FOB' | 'FREE_ON_BOARD';
CIF: 'CIF' | 'COST_INSURANCE_FREIGHT';
DDP: 'DDP' | 'DELIVERED_DUTY_PAID';
EXW: 'EXW' | 'EX_WORKS';
HS_CODE: 'HS_CODE' | 'HARMONIZED_SYSTEM_CODE';
HTS_CODE: 'HTS_CODE';
TARIFF_CODE: 'TARIFF_CODE';
DUTY: 'DUTY';
CUSTOMS_CLEARANCE: 'CUSTOMS_CLEARANCE';
DEMURRAGE: 'DEMURRAGE';
DETENTION: 'DETENTION';
HAZMAT: 'HAZMAT' | 'HAZARDOUS_MATERIALS';
DG: 'DG' | 'DANGEROUS_GOODS';
COLD_CHAIN: 'COLD_CHAIN';
REEFER: 'REEFER';
WMS: 'WMS' | 'WAREHOUSE_MANAGEMENT_SYSTEM';
TMS: 'TMS' | 'TRANSPORTATION_MANAGEMENT_SYSTEM';
WAVE_PICKING: 'WAVE_PICKING';
PUTAWAY: 'PUTAWAY';
ON_TIME_DELIVERY: 'ON_TIME_DELIVERY' | 'OTD';
IFOT: 'IFOT' | 'IN_FULL_ON_TIME';
OTIF: 'OTIF' | 'ON_TIME_IN_FULL';
PERFECT_ORDER: 'PERFECT_ORDER';

STRING:'"' (~["\r\n])* '"'; TEXT: ~[\r\n]+; ENUM:'[' IDENTIFIER (',' IDENTIFIER)* ']';
UUID:[0-9a-fA-F]{8} '-' [0-9a-fA-F]{4} '-' [0-9a-fA-F]{4} '-' [0-9a-fA-F]{4} '-' [0-9a-fA-F]{12};
DATE:[0-9]{4} '-' [0-9]{2} '-' [0-9]{2}; NUMBER:[0-9]+ ('.' [0-9]+)?; BOOLEAN:'true'|'false';
IDENTIFIER:[a-zA-Z_][a-zA-Z0-9_]*; NL: ('\r'? '\n')+; WS:[ \t]+ -> skip; LINE_COMMENT:'//' ~[\r\n]* -> skip; BLOCK_COMMENT:'/*' .*? '*/' -> skip;
