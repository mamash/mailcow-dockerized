#!/bin/bash

export MAILCOW_BACKUP_LOCATION=/mnt/mailcow/backups

basedir=$(cd $(dirname $0)/..; pwd)
cd ${basedir}

echo "Running backup"
./helper-scripts/backup_and_restore.sh backup all

echo "Syncing to Backblaze"
docker run --rm \
  -v ${MAILCOW_BACKUP_LOCATION}:/backups \
  -v ${basedir}/data/conf/rclone.conf:/root/.rclone.conf \
  rclone/rclone:latest \
  sync /backups pysket:/pysket
