#!/bin/bash

SOURCE_DIR="app_data"
BACKUP_DIR="backup"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

mkdir -p $BACKUP_DIR

tar -czvf ${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz $SOURCE_DIR

find $BACKUP_DIR -name "*.tar.gz" -mmin +2 -delete

echo "Backup complete and old files cleaned up!"
