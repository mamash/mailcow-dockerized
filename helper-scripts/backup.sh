#!/usr/bin/env bash
set -euo pipefail

export PS4='[\D{%FT%TZ}] ${BASH_SOURCE}:${LINENO}: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
exec {BASH_XTRACEFD}>> /var/log/backup-mailcow.log
set -o xtrace

export RESTIC_REPOSITORY="sftp:bbox:mailcow"
export RESTIC_PASSWORD_FILE="/etc/restic/password"
export MAILCOW_BACKUP_LOCATION=/mnt/mailcow/backups

echo "Running backup"
/opt/mailcow/helper-scripts/backup_and_restore.sh backup all --delete-days 1
rm -rf "${MAILCOW_BACKUP_LOCATION}/mailcow-latest"
mv "${MAILCOW_BACKUP_LOCATION}"/mailcow-20* "${MAILCOW_BACKUP_LOCATION}/mailcow-latest"

echo "Syncing to Hetzner"
restic backup "${MAILCOW_BACKUP_LOCATION}/mailcow-latest" --tag mailcow
restic backup ${MAILCOW_BACKUP_LOCATION} --tag mailcow
restic forget --keep-weekly 4 --keep-monthly 3 --prune
restic check

echo "Notifying updown"
curl -m 10 --retry 5 https://pulse.updown.io/m8a7/RTd1gNEV
