#!/bin/bash

TIMESTAMP_DAY=$(date +"%A")
TIMESTAMP_HOUR=$(date +"%H")
BACKUP_DIR="/backup/dbs"
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump

rm -rf /backup/dbs/$TIMESTAMP_DAY/$TIMESTAMP_HOUR > /dev/null
mkdir -p "$BACKUP_DIR/$TIMESTAMP_DAY/$TIMESTAMP_HOUR"

databases=`$MYSQL -e "SHOW DATABASES;" | grep -Evw "(Database|information_schema|performance_schema|sys)"`

for db in $databases; do
  $MYSQLDUMP --force --opt -u root --databases $db | gzip > "$BACKUP_DIR/$TIMESTAMP_DAY/$TIMESTAMP_HOUR/$db.gz"
  rsync -av -e "ssh -p 3300" /backup/dbs bkpkifpo@bak-eu2.euhosted.com:/home/bkpkifpo/backup/ --delete
done

echo Databases Backup Task Completed On $HOSTNAME
