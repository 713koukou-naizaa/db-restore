#!/bin/bash

# filename: db-restore.sh
# brief: Restore database using mariadb
# description: Restore database using mariadb
# author: 713koukou-naizaa
# date: 2025-01-27
# usage: ./db-restore.sh

# VARS
backupsfolder=~/path/to/backups/folder # backups folder
logfile=~/path/to/log/file.log # log file

host=host_address # host
db=db_name # db name
user=user # username

current_date=$(date +%Y-%m-%d_%H-%M-%S) # date

# parse backupsfolder and return latest backup (sql file)
latest_backup=$(ls -t $backupsfolder/*.sql 2>/dev/null | head -1)
# rename latest backup file to $db.sql
mv $latest_backup $backupsfolder/$db.sql
latest_backup=$backupsfolder/$db.sql

# create file if not exists
touch $logfile

# RESTORE START
echo [$current_date] [info] Starting Restore >> $logfile

# drop database
# ie. opt/lampp/bin/mariadb || /usr/bin/mariadb || /usr/local/bin/mariadb
/opt/lampp/bin/mariadb -h $host -u $user -e "DROP DATABASE IF EXISTS $db;"
drop_db_code=$?
if [ $drop_db_code -eq 0 ]; then
    echo [$current_date] [info] Database $db dropped >> $logfile
else
    echo [$current_date] [error] drop return non-zero code $drop_db_code >> $logfile
    echo [$current_date] [debug] $drop_db_result >> $logfile
    exit
fi

# recreate empty database
# ie. opt/lampp/bin/mariadb || /usr/bin/mariadb || /usr/local/bin/mariadb
/opt/lampp/bin/mariadb -h $host -u $user -e "CREATE DATABASE $db;"
create_db_code=$?
if [ $create_db_code -eq 0 ]; then # 0 = success
    echo [$current_date] [info] Database $db created >> $logfile
else # != 0 = error
    echo [$current_date] [error] create return non-zero code $create_db_code >> $logfile
    echo [$current_date] [debug] $create_db_result >> $logfile
    exit
fi

# CONNECT & IMPORT BACKUP
# ie. opt/lampp/bin/mariadb || /usr/bin/mariadb || /usr/local/bin/mariadb
mariadb_import_result=$(/opt/lampp/bin/mariadb -u $user $db < $latest_backup)
mariadb_import_code=$?
if [ $mariadb_import_code -eq 0 ]; then # 0 = success
    echo [$current_date] [info] Database successfully restored from: $latest_backup >> $logfile
else # != 0 = error
    echo [$current_date] [error] mariadb import return non-zero code $mariadb_import_code >> $logfile
    echo [$current_date] [debug] $mariadb_import_result >> $logfile
    exit
fi


# RESTORE END
echo [$current_date] [info] Restore complete >> $logfile
echo -------------------------------------------------- >> $logfile
