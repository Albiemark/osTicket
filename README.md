# Magellan IT Service Desk - osTicket Fork

## Overview
White-labeled osTicket deployment for Magellan Luxury Hotels IT Service Desk. Branded, customized, and self-hosted on internal infrastructure.

## Fork Source
- Upstream: https://github.com/osTicket/osTicket
- License: GPLv2
- Version: latest (main branch)

## Architectural Principle: SIMPLE DIGITAL AGILE

Every design decision passes through this lens:

1. **SIMPLE** - Minimal moving parts. No unnecessary abstraction. Solve the problem in front of you with the fewest components. Prefer convention over configuration. If a feature adds complexity without clear value, it doesn't ship.

2. **DIGITAL** - Born digital, stays digital. No paper processes. No manual handoffs that can be automated. Everything is tracked, logged, and searchable. The system is the source of truth.

3. **AGILE** - Ship small, ship often. Iterative improvements over big-bang deployments. Feedback loops are short. The team adapts the tool to match how they work, not the other way around.

### Supporting Principles

- **Self-hosted, self-controlled.** No SaaS dependencies for core operations. Magellan data stays on Magellan infrastructure.
- **Zero licensing cost.** Open source foundation. Customization through configuration and code, not premium tiers.
- **ITIL-aware, not ITIL-burdened.** Follow the framework where it adds value. Skip the ceremony where it doesn't.
- **Security by default.** HTTPS, authentication, audit trails. No shortcuts in production.
- **Mobile-friendly.** Agents and customers can interact from any device.
- **Brand-native.** Looks and feels like Magellan, not a third-party tool.

## Solution Architecture

```
Magellan IT Service Desk
├── Customer Portal (public-facing)
│   ├── Ticket submission
│   ├── Knowledge Base
│   ├── Ticket status lookup
│   └── Magellan-branded UI
│
├── Agent Panel (internal)
│   ├── Ticket management
│   ├── SLA tracking
│   ├── Knowledge Base authoring
│   ├── Reports and metrics
│   └── DevSecOps dashboard
│
├── Email Integration
│   ├── Ticket creation from email
│   ├── Notification routing
│   └── M365 Exchange Online connector
│
└── Infrastructure
    ├── Power BI Server (172.24.21.215)
    │   ├── Docker: osTicket + MySQL
    │   └── Behind VPN, internal only
    │
    └── Backup Strategy
        ├── Daily MySQL dumps
        └── Volume backups
```

## Directory Structure

```
osTicket/
├── branding/              # Magellan brand assets
│   ├── logos/             # Logo files (header, login, favicon)
│   ├── css/               # Custom theme overrides
│   └── email-templates/   # Branded email templates
│
├── config/                # Deployment configuration
│   ├── docker/            # Docker Compose for production
│   ├── nginx/             # Reverse proxy config
│   └── ssl/               # TLS certificate config
│
├── docs/                  # Project documentation
│   ├── architecture.md    # Solution architecture
│   ├── deployment.md      # Deployment runbook (MOP)
│   ├── customization.md   # Rebrand guide
│   └── runbook.md         # Operational runbook
│
├── scripts/               # Automation
│   ├── backup.sh          # Database backup script
│   ├── restore.sh         # Database restore script
│   └── seed-kb.sh         # KB content seeding
│
├── plugins/               # Custom plugins
│   └── magellan-auth/     # M365 SSO plugin (future)
│
└── [osTicket source]      # Original osTicket codebase
```

## Deployment Phases

### Phase 1: Foundation (Week 1)
- [ ] Finalize brand assets (logo, colors, email template)
- [ ] Apply theme customizations
- [ ] Configure Docker Compose for production
- [ ] Deploy to Power BI server (with Neil/Jatinder coordination)
- [ ] Create initial admin and agent accounts
- [ ] Seed Knowledge Base from Magellan repo docs

### Phase 2: Integration (Week 2)
- [ ] Email integration with M365 (ticket creation from email)
- [ ] Configure SLA policies
- [ ] Set up help topics and ticket categories
- [ ] Configure notification templates
- [ ] Create department/team structure

### Phase 3: Operations (Week 3+)
- [ ] Operational runbook documentation
- [ ] Backup automation
- [ ] Weekly metrics reporting
- [ ] M365 SSO (future, if needed)
- [ ] API integrations (future: SugarCRM, monitoring alerts)

## Key Customizations

| Area | Scope | Priority |
|------|-------|----------|
| Logo and branding | Replace all osTicket branding with Magellan | P0 |
| Color theme | Magellan brand colors | P0 |
| Login page | Custom Magellan login with company branding | P0 |
| Email templates | Branded notifications | P0 |
| Help topics | Magellan-specific categories | P1 |
| KB content | Migrate from Magellan repo docs | P1 |
| Dashboard | DevSecOps agent panel label | P2 |
| SSO | M365/Azure AD integration | P2 |

## Team

| Role | Person |
|------|--------|
| Lead | Albie Salvador |
| Infrastructure | Jatinder Singh |
| Approval | Neil Mehta |

## Branding Guidelines

- Company: Magellan Luxury Hotels
- Service Desk Name: Magellan IT Service Desk
- Agent Panel Name: Magellan IT DevSecOps
- Primary Color: TBD (get from Janelle/marketing)
- Logo: TBD (get from Janelle/marketing)
- Email Domain: @magellanluxuryhotels.com
