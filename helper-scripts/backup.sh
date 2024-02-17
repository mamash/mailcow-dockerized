#!/bin/bash

export MAILCOW_BACKUP_LOCATION=/mnt/mailcow/backups

basedir=/opt/mailcow
cd ${basedir}

echo "Running backup"
./helper-scripts/backup_and_restore.sh backup all

echo "Pruning down backups"
ls -1dS /mnt/mailcow/backups/mailcow-* | head -n -3 | xargs rm -rf

echo "Syncing to Backblaze"
docker run --rm \
  -v ${MAILCOW_BACKUP_LOCATION}:/backups \
  -v ${basedir}/data/conf/rclone.conf:/root/.rclone.conf \
  rclone/rclone:latest \
  sync /backups pysket:/pysket
