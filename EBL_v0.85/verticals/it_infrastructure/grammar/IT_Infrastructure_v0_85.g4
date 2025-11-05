/*
 * IT Infrastructure & Cloud Operations Domain Specific Language (EBL v0.85)
 * Vertical: IT Infrastructure
 * Description: Grammar for Cloud Computing, DevOps, SRE, Kubernetes, CI/CD, Monitoring, and ITSM
 */

grammar IT_Infrastructure_v0_85;

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
      'Kind' ':' ('Application'|'System'|'Platform'|'Container'|'VM'|'Pod'|'Cluster') NL+
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
    | 'YAML'         // IT-specific
    | 'Manifest'     // IT-specific: K8s manifest
    | 'Terraform'    // IT-specific
    | 'Ansible'      // IT-specific
    | 'IPAddress'    // IT-specific
    | 'CIDR'         // IT-specific
    | 'URL'          // IT-specific
    | 'DockerImage'  // IT-specific
    | 'HelmChart'    // IT-specific
    ;

fieldAttr
    : 'required'
    | 'unique'
    | 'min' '=' NUMBER
    | 'max' '=' NUMBER
    | 'values' '=' '[' value (',' value)* ']'
    | 'encrypted'    // IT-specific
    | 'immutable'    // IT-specific
    | 'secret'       // IT-specific
    ;

value
    : STRING
    | NUMBER
    | UUID
    | DATE
    | ENUM
    | BOOLEAN
    ;

// ===== IT INFRASTRUCTURE-SPECIFIC KEYWORDS =====

// Container & Orchestration
KUBERNETES: 'KUBERNETES' | 'K8S';
DOCKER: 'DOCKER';
CONTAINER: 'CONTAINER';
POD: 'POD';
NODE: 'NODE';
CLUSTER: 'CLUSTER';
NAMESPACE: 'NAMESPACE';
DEPLOYMENT: 'DEPLOYMENT';
STATEFUL_SET: 'STATEFUL_SET';
DAEMON_SET: 'DAEMON_SET';
REPLICA_SET: 'REPLICA_SET';
JOB: 'JOB';
CRON_JOB: 'CRON_JOB';
HELM: 'HELM';
OPERATOR: 'OPERATOR';
CRD: 'CRD';

// DevOps & CI/CD
CI_CD: 'CI_CD' | 'CONTINUOUS_INTEGRATION' | 'CONTINUOUS_DEPLOYMENT';
GITOPS: 'GITOPS';
IAC: 'IAC' | 'INFRASTRUCTURE_AS_CODE';
TERRAFORM: 'TERRAFORM';
ANSIBLE: 'ANSIBLE';
CLOUDFORMATION: 'CLOUDFORMATION';

// SRE & Monitoring
DEVOPS: 'DEVOPS';
SRE: 'SRE' | 'SITE_RELIABILITY_ENGINEERING';
SLA: 'SLA';
SLO: 'SLO';
SLI: 'SLI';
ERROR_BUDGET: 'ERROR_BUDGET';
MTTR: 'MTTR' | 'MEAN_TIME_TO_REPAIR';
MTBF: 'MTBF' | 'MEAN_TIME_BETWEEN_FAILURES';
MTTF: 'MTTF';
AVAILABILITY: 'AVAILABILITY';
UPTIME: 'UPTIME';
DOWNTIME: 'DOWNTIME';

// High Availability & DR
HIGH_AVAILABILITY: 'HIGH_AVAILABILITY' | 'HA';
FAULT_TOLERANCE: 'FAULT_TOLERANCE';
DISASTER_RECOVERY: 'DISASTER_RECOVERY' | 'DR';
RTO: 'RTO' | 'RECOVERY_TIME_OBJECTIVE';
RPO: 'RPO' | 'RECOVERY_POINT_OBJECTIVE';

// Deployment Strategies
BLUE_GREEN: 'BLUE_GREEN';
CANARY: 'CANARY';
ROLLING_UPDATE: 'ROLLING_UPDATE';
IMMUTABLE_INFRASTRUCTURE: 'IMMUTABLE_INFRASTRUCTURE';

// Cloud & Networking
LOAD_BALANCER: 'LOAD_BALANCER';
AUTO_SCALING: 'AUTO_SCALING';
SERVICE_MESH: 'SERVICE_MESH';
ISTIO: 'ISTIO';
API_GATEWAY: 'API_GATEWAY';
VPC: 'VPC';
SUBNET: 'SUBNET';
SECURITY_GROUP: 'SECURITY_GROUP';
FIREWALL: 'FIREWALL';
WAF: 'WAF';

// Observability
OBSERVABILITY: 'OBSERVABILITY';
TELEMETRY: 'TELEMETRY';
METRICS: 'METRICS';
LOGS: 'LOGS';
TRACES: 'TRACES';
APM: 'APM';
PROMETHEUS: 'PROMETHEUS';
GRAFANA: 'GRAFANA';
ELK_STACK: 'ELK_STACK';
ELASTICSEARCH: 'ELASTICSEARCH';

// Incident Management
INCIDENT: 'INCIDENT';
P0: 'P0';
P1: 'P1';
P2: 'P2';
P3: 'P3';
SEV1: 'SEV1';
SEV2: 'SEV2';
SEV3: 'SEV3';
ON_CALL: 'ON_CALL';
PAGERDUTY: 'PAGERDUTY';
RUNBOOK: 'RUNBOOK';
PLAYBOOK: 'PLAYBOOK';
POST_MORTEM: 'POST_MORTEM';
BLAMELESS: 'BLAMELESS';

// Security
ZERO_TRUST: 'ZERO_TRUST';
LEAST_PRIVILEGE: 'LEAST_PRIVILEGE';
DEFENSE_IN_DEPTH: 'DEFENSE_IN_DEPTH';
IAM: 'IAM';
RBAC: 'RBAC';
ABAC: 'ABAC';
SSO: 'SSO';
MFA: 'MFA';
SECRETS_MANAGEMENT: 'SECRETS_MANAGEMENT';
VAULT: 'VAULT';
KMS: 'KMS';

// Storage & Backup
BACKUP: 'BACKUP';
SNAPSHOT: 'SNAPSHOT';
REPLICATION: 'REPLICATION';
PERSISTENT_VOLUME: 'PERSISTENT_VOLUME' | 'PV';
PVC: 'PVC';
STORAGE_CLASS: 'STORAGE_CLASS';

// Change Management
CHANGE_MANAGEMENT: 'CHANGE_MANAGEMENT';
CAB: 'CAB' | 'CHANGE_ADVISORY_BOARD';
CMDB: 'CMDB' | 'CONFIGURATION_MANAGEMENT_DATABASE';

// Cloud Providers
AWS: 'AWS';
AZURE: 'AZURE';
GCP: 'GCP';
MULTI_CLOUD: 'MULTI_CLOUD';
HYBRID_CLOUD: 'HYBRID_CLOUD';

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
