# Magellan IT Service Desk - Solution Architecture

## Core Architectural Principle

**SIMPLE DIGITAL AGILE**

Every technical decision in this project is filtered through three lenses:

### SIMPLE
Minimal moving parts. No unnecessary abstraction. The solution uses exactly two containers: osTicket + MySQL. No reverse proxy, no Redis, no Elasticsearch, no microservices. Complexity is the enemy of reliability.

### DIGITAL
Born digital. Every interaction is tracked. No paper, no verbal-only handoffs, no "just call me" workflows. The ticket is the source of truth. If it's not in the system, it didn't happen.

### AGILE
Ship iteratively. Phase 1 is a working ticketing system with basic branding. Phase 2 adds integrations. Phase 3 adds automation. Each phase delivers value independently. No big-bang deployments.

---

## System Architecture

```
┌─────────────────────────────────────────────┐
│            Magellan VPN / Network           │
│                                             │
│  ┌───────────────────────────────────────┐  │
│  │     Power BI Server (172.24.21.215)   │  │
│  │                                       │  │
│  │  ┌──────────┐  ┌──────────┐           │  │
│  │  │ osTicket │  │  MySQL   │           │  │
│  │  │  (Docker)│──│ 5.7(Dock)│           │  │
│  │  └────┬─────┘  └──────────┘           │  │
│  │       │                               │  │
│  │       │ Port 8080                     │  │
│  └───────┼───────────────────────────────┘  │
│          │                                  │
│    ┌─────┴──────┐                           │
│    │  IT Team   │    Agents via /scp        │
│    │  (Albie,   │                           │
│    │  Neil,     │    Customers via /        │
│    │  Jatinder) │                           │
│    └────────────┘                           │
│                                             │
│  ┌──────────────┐                           │
│  │ M365 Exchange│── Email ticket creation   │
│  │   Online     │── Notifications           │
│  └──────────────┘                           │
└─────────────────────────────────────────────┘
```

## Components

| Component | Purpose | Resource Estimate |
|-----------|---------|-------------------|
| osTicket | Web application (ticketing + KB) | 256MB RAM, 1 CPU |
| MySQL 5.7 | Database | 512MB RAM, 1 CPU |
| Docker | Container runtime | Included in OS |
| Total | | ~1GB RAM, 10GB disk |

## Data Flow

```
Customer submits ticket (web or email)
    │
    ▼
osTicket creates ticket, assigns to queue
    │
    ▼
Agent receives notification (email + dashboard)
    │
    ▼
Agent responds, updates ticket
    │
    ▼
Customer receives response (email + portal)
    │
    ▼
Ticket resolved, metrics logged
```

## Security

- **Access**: VPN required. No public internet exposure.
- **Authentication**: Local accounts (Phase 1), M365 SSO (Phase 2)
- **Transport**: HTTPS via Docker reverse proxy or direct TLS
- **Data**: MySQL data at rest in Docker volumes
- **Backups**: Daily MySQL dumps, stored locally
- **Audit**: osTicket logs all ticket activity natively

## Integration Points

| System | Direction | Method | Phase |
|--------|-----------|--------|-------|
| M365 Email | Bidirectional | SMTP/IMAP | 2 |
| Monitoring (Sentry/CloudWatch) | Inbound | Email/API | 3 |
| SugarCRM | Lookup | API (future) | 3 |
| Power BI | Outbound | Data export | 3 |

## Failure Modes

| Failure | Impact | Recovery |
|---------|--------|----------|
| osTicket container crashes | Service unavailable | Docker auto-restart |
| MySQL crashes | Data loss unlikely, service down | Docker auto-restart |
| Host server down | Full outage | Manual restart |
| Disk full | Service degradation | Monitor + alert |
| VPN down | Remote users can't access | On-site access still works |

## Why This Stack

| Question | Answer |
|----------|--------|
| Why not Jira? | Cost. Already have 112 stale items there. Overkill for a 3-person IT team. |
| Why not FreshService/Zendesk? | SaaS cost, data sovereignty, vendor lock-in. |
| Why not FreeScout? | Considered. osTicket has better KB and more mature ITIL features. |
| Why not Zammad? | Too heavy. Requires Elasticsearch, Redis, 5+ containers. Violates SIMPLE. |
| Why not ServiceNow? | Enterprise pricing. Not appropriate for this team size. |
| Why Power BI server? | Already provisioned, behind VPN, has compute. No new AWS spend. |
| Why Docker? | Consistent deployment, easy rollback, isolated from Power BI Server. |

## Success Metrics

- Mean time to respond (MTTR) tracked per SLA
- First contact resolution rate
- Ticket volume by category
- KB article usage (self-service rate)
- Agent satisfaction (qualitative, quarterly)
