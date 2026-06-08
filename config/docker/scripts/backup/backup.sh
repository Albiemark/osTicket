#!/bin/bash
# ============================================================
# Magellan IT Service Desk — MySQL Backup Script
# Runs inside the osticket-db container via cron or manual exec
# ============================================================

set -euo pipefail

# Configuration
DB_HOST="${MYSQL_HOST:-localhost}"
DB_USER="${MYSQL_USER:-osticket}"
DB_NAME="${MYSQL_DATABASE:-osticket}"
BACKUP_DIR="/opt/backup"
RETENTION_DAYS=14

# Timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/osticket_${TIMESTAMP}.sql.gz"

echo "[$(date)] Starting backup of ${DB_NAME}..."

# Dump and compress
mysqldump \
  -h "${DB_HOST}" \
  -u "${DB_USER}" \
  -p"${MYSQL_PASSWORD}" \
  --single-transaction \
  --routines \
  --triggers \
  --add-drop-table \
  --quick \
  "${DB_NAME}" | gzip > "${BACKUP_FILE}"

# Check success
if [ $? -eq 0 ]; then
    SIZE=$(du -h "${BACKUP_FILE}" | cut -f1)
    echo "[$(date)] Backup completed: ${BACKUP_FILE} (${SIZE})"
else
    echo "[$(date)] ERROR: Backup failed!"
    rm -f "${BACKUP_FILE}"
    exit 1
fi

# Clean up old backups
echo "[$(date)] Removing backups older than ${RETENTION_DAYS} days..."
find "${BACKUP_DIR}" -name "osticket_*.sql.gz" -type f -mtime +${RETENTION_DAYS} -delete

echo "[$(date)] Done. Current backups:"
ls -lh "${BACKUP_DIR}"/osticket_*.sql.gz 2>/dev/null || echo "  No backups found"