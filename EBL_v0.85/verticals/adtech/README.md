# AdTech Vertical - Archailign Business Engineering EBL v0.85

## Overview

The **AdTech vertical** provides EBL definitions, dictionaries, and data models for advertising technology and digital marketing domains. This vertical covers campaign management, audience targeting, ad serving, bidding strategies, and performance analytics.

## Directory Structure

```
adtech/
├── README.md                              # This file
├── examples/                              # AdTech EBL examples
│   ├── AdCampaignManagement.ebl          # Campaign lifecycle management
│   └── AdTech_Dynamic_Marketing_Cycle_Full.ebl  # Full marketing cycle
├── dictionary/                            # Domain vocabulary
│   └── adtech_dictionary_v0.85.json      # Actors, verbs, entities
└── data_model/                            # Database schemas
    ├── adtech_erm_base.sql               # UUID-based schema
    └── adtech_erm_extended.sql           # INT-based schema with analytics
```

## Domain Dictionary

### Actors
- **MediaBuyer** - Plans and executes ad campaigns
- **AdServer** - Delivers ads to target audiences
- **DataAnalyst** - Analyzes campaign performance
- **CreativeDirector** - Designs creative assets
- **BidManager** - Manages programmatic bidding

### Key Verbs
- **Plan** (write) - Plan campaigns and budgets
- **Target** (both) - Target audience segments
- **Deliver** (write) - Deliver ads to users
- **Bid** (write) - Submit programmatic bids
- **Optimize** (write) - Optimize campaign performance
- **Analyze** (read) - Analyze campaign metrics
- **Report** (write) - Generate performance reports

### Entities
- Campaign, AudienceSegment, CreativeAsset, Template
- TargetingRule, BidRequest, BidResponse
- Impression, Click, Conversion
- Experiment, MLModel, KPI, DMPProfile

## Examples

### 1. AdCampaignManagement.ebl
**Purpose:** Dynamic campaign optimization with predictive budgeting

**Key Features:**
- Campaign planning and budget allocation
- Audience segmentation and targeting
- Creative assembly and personalization
- Bid management and delivery
- Performance tracking and optimization

**Use Cases:**
- Multi-channel campaign orchestration
- Real-time budget optimization
- A/B testing and experimentation
- Attribution modeling

### 2. AdTech_Dynamic_Marketing_Cycle_Full.ebl
**Purpose:** End-to-end marketing lifecycle

**Key Features:**
- Full marketing funnel (awareness → conversion)
- Multi-touchpoint attribution
- Dynamic creative optimization (DCO)
- Predictive analytics integration

## Data Model

### AdTech-Specific Tables (extend base ERM)

```sql
-- Campaign Management
CREATE TABLE Campaign (
    CampaignID UUID PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Budget DECIMAL(15,2),
    StartDate DATE,
    EndDate DATE,
    Status ENUM('Draft', 'Active', 'Paused', 'Completed'),
    ObjectiveType VARCHAR(50)
);

-- Audience Segments
CREATE TABLE AudienceSegment (
    SegmentID UUID PRIMARY KEY,
    Name VARCHAR(255),
    Criteria JSON,
    Size INTEGER,
    CampaignID UUID REFERENCES Campaign(CampaignID)
);

-- Performance Metrics
CREATE TABLE CampaignMetrics (
    MetricID UUID PRIMARY KEY,
    CampaignID UUID REFERENCES Campaign(CampaignID),
    Date DATE,
    Impressions BIGINT,
    Clicks BIGINT,
    Conversions INTEGER,
    Spend DECIMAL(15,2),
    Revenue DECIMAL(15,2)
);
```

## Validation Examples

### Valid EBL
```bash
python ebl_validator.py \
  verticals/adtech/dictionary/adtech_dictionary_v0.85.json \
  verticals/adtech/examples/AdCampaignManagement.ebl
```

**Expected:** ✅ All validations pass

### Common Patterns
```ebl
# Campaign Planning
Process CampaignPlanning {
  Actors: [MediaBuyer, DataAnalyst]
  Steps:
    - MediaBuyer Plan campaign via DO_Campaign Input
    - DataAnalyst Analyze audience via DO_AudienceSegment Output
}

# Ad Delivery
Process AdServing {
  Actions:
    - AdServer Deliver via DO_Impression Input
    - AdServer Track via DO_Click Input
}
```

## Integration Points

### External Systems
- **DSP (Demand-Side Platform)** - Programmatic ad buying
- **DMP (Data Management Platform)** - Audience data
- **Ad Server** - Creative delivery
- **Analytics Platform** - Performance tracking

### Generated Artifacts
- **ArchiMate Model** - Campaign architecture visualization
- **OPA/Rego Policies** - Budget compliance rules
- **API Specs** - Campaign management APIs
- **IaC** - Infrastructure for ad serving

## Compliance Considerations

- **GDPR** - User consent and data privacy
- **CCPA** - California Consumer Privacy Act
- **IAB Standards** - Interactive Advertising Bureau guidelines
- **Brand Safety** - Ad placement policies

## Getting Started

1. **Explore Examples**
   ```bash
   cd verticals/adtech/examples
   cat AdCampaignManagement.ebl
   ```

2. **Validate Against Dictionary**
   ```bash
   python ../../ebl_validator.py \
     dictionary/adtech_dictionary_v0.85.json \
     examples/AdCampaignManagement.ebl
   ```

3. **Deploy Database Schema**
   ```bash
   psql -f data_model/adtech_erm_base.sql
   ```

## Resources

- [AdTech Dictionary](dictionary/adtech_dictionary_v0.85.json)
- [Main Documentation](../../README.md)
- [EBL Language Reference](../../../docs/ebl-classes.md)

---

**Version:** 0.85
**Last Updated:** 05-11-2025
**Maintainer:** Praxibility Team
