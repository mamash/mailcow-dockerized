#!/bin/bash

export BASH_XTRACEFD=10
export PS4='[\D{%FT%TZ}] ${BASH_SOURCE}:${LINENO}: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
exec 10> /var/log/mailcow-backup.log
set -o xtrace

export MAILCOW_BACKUP_LOCATION=/mnt/mailcow/backups
export MAILCOW_BACKUP_BUCKET=hetzner:pysket/backups

basedir=/opt/mailcow
cd ${basedir}

echo "Running backup"
./helper-scripts/backup_and_restore.sh backup all

echo "Syncing to Backblaze"
rclone copy ${MAILCOW_BACKUP_LOCATION} ${MAILCOW_BACKUP_BUCKET}

echo "Pruning down backups"
ls -1dS ${MAILCOW_BACKUP_LOCATION}/mailcow-* | head -n -1 | xargs rm -rf

echo "Notifying updown"
curl -m 10 --retry 5 https://pulse.updown.io/m8a7/RTd1gNEV
