# Magellan IT Service Desk - Deployment Guide

## Prerequisites

Before you begin, confirm the following:

- Power BI Server (172.24.21.215) is accessible via VPN+RDP
- Docker Desktop or Docker Engine is installed on the server
- Ports 8080 (or chosen port) are available
- You have credentials for MySQL root and admin accounts

## Step 1: Prepare the Server

1. RDP into 172.24.21.215
2. Verify Docker is running: `docker ps`
3. Check available resources: at least 2GB RAM and 10GB disk free
4. Create project directory: `mkdir C:\magellan-it-desk`

## Step 2: Deploy Configuration

1. Copy `config/docker/` to `C:\magellan-it-desk\`
2. Copy `.env.example` to `.env`
3. Fill in all environment variables in `.env`
4. Generate a strong `INSTALL_SECRET`: use a random 32-character string

## Step 3: Launch

```
cd C:\magellan-it-desk
docker compose up -d
```

Wait for both containers to show "healthy" status:
```
docker compose ps
```

## Step 4: Initial Configuration

1. Open http://172.24.21.215:8080/scp in a browser
2. Log in with admin credentials
3. Configure the following:

### Settings > System
- Help Desk Name: Magellan IT Service Desk
- Default URL: http://172.24.21.215:8080

### Settings > Emails
- Add SMTP credentials for magellanluxuryhotels.com
- Configure email fetching for the support inbox

### Settings > Knowledge Base
- Enable Knowledge Base
- Set to "Published" visibility

### Manage > Help Topics
Create Magellan-specific help topics:
- Hardware / Equipment
- Software / Applications
- Network / VPN / WiFi
- Email / M365
- SugarCRM / LUX
- Telephony / Telefonica
- Security / Access
- General IT Request

### Manage > SLA
- Define SLA policies aligned with business needs

## Step 5: Apply Branding

### 5a. Upload Logo
1. In Admin Panel, go to **Settings → Pages**
2. Upload `branding/logos/MLH-logo-black-9.png` as the client logo
3. The navy header will automatically invert the logo to white via CSS

### 5b. Apply Custom Theme CSS
1. Open `branding/css/magellan-theme.css` from this repo
2. In Admin Panel, go to **Settings → Pages → Custom CSS** (or inject via the theme file)
3. Alternatively, replace the contents of `assets/default/css/theme.css` with the Magellan theme
4. **Recommended approach**: Paste the CSS into **Admin Panel → Manage → Pages → "Custom CSS"** field for safe upgrades

### 5c. Upload Email Templates
1. In Admin Panel, go to **Manage → Templates**
2. Create a new template set called "Magellan Branded"
3. For each template, paste the corresponding HTML from `branding/email-templates/`:
   - `ticket.autoresp.html` → **New Ticket Auto-response**
   - `ticket.reply.html` → **Response/Reply Template**
   - `ticket.alert.html` → **New Ticket Alert** (agent)
   - `ticket.overdue.html` → **Overdue Ticket Alert** (agent)
4. Set the new template set as the default for all departments

## Step 6: Seed Knowledge Base

1. Convert key docs from Magellan repo to KB articles
2. Organize into categories matching help topics
3. Publish articles as "Featured" for common self-service items

## Step 7: Create Agent Accounts

1. Add Neil, Jatinder as agents
2. Assign departments and permissions
3. Configure notification preferences

## Step 8: Verify

- [ ] Customer portal loads at root URL
- [ ] Admin panel accessible at /scp
- [ ] Email notifications send correctly
- [ ] KB articles are searchable
- [ ] Ticket creation works (web + email)
- [ ] Agent assignments work
- [ ] Backups are configured

## Rollback

If something breaks:
```
cd C:\magellan-it-desk
docker compose down
```

Data persists in Docker volumes.

### Run a Backup Manually
```
docker compose exec osticket-db bash /opt/backup/backup.sh
```

### Restore from Backup
```
gunzip -c /opt/backup/osticket_YYYYMMDD_HHMMSS.sql.gz | docker compose exec -T osticket-db mysql -u root -p osticket
```
