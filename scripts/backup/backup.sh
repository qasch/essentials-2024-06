#!/usr/bin/env bash

# Configdatei einlesen
source config.txt

timestamp=$(date +%Y%m%d-%H%M)
logfile="$path_to_backup_dir/backup_$timestamp.log"

# Prüfen, ob Verzeichnis existiert, ansonsten erstellen
mkdir -vp $path_to_backup_dir >> $logfile

echo --- Backup Script gestartet: $(date "+%Y%m%d %H:%M.%S") --- >> $logfile

tar -cvjf ${path_to_backup_dir}/backup_$timestamp.tar.bz2 --exclude-from=$exclude_file $dirs_to_backup &>> $logfile

echo --- Backup Script beendet: $(date "+%Y%m%d %H:%M.%S") --- >> $logfile


# TODO:
# - [x] timestamp an backup namen
# - [x] prüfen, ob backup_dir vorhanden, sonst erstellen
# - [x] was ist mit tar Dateien im Heimatverzeichnis?  find? Pattern?
# - [ ] was ist mit den "unnötigen" Fehlermeldungen?
# - [ ] Logging
# - [ ] Wohin mit den Backups? -> anderer Server
# - [ ] Skript automatisch starten mit cron oder systemd-timer?

# TODO 2:
# - [ ] alte Backups löschen
# - [ ] weitere Verzeichnisse, z.B. /etc /var?
# - [ ] root Rechte?
