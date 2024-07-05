#!/usr/bin/env bash

#set -x

# Configdatei einlesen
#source config.txt

timestamp=$(date +%Y%m%d-%H%M)
dirs_to_backup="$HOME"
path_to_backup_dir="${HOME}/backup"
backup_file="${path_to_backup_dir}/backup_$timestamp.tar.bz2"
exclude_file="excludes.txt"
logfile="backup.log"
logfile="$path_to_backup_dir/backup_$timestamp.log"

dependencies="gpg tar"

gpg_key_dennis_s="424911FCAE318E5ADE86010F1E9872C92DC3527C"
gpg_key_dennis_w="C942B1B7C38868E23226FF0A3446D219FCCDED1F"
gpg_key_armin_s="6EB3560A4ED0C15708E3066D9E018D1494978227"
gpg_key_tux_t="D3C42FD74D701F4EAD1C3DB981246728709B3943"

ssh_key="${HOME}/.ssh/backy-backup"
backup_server="backy@192.168.100.184"

function write_to_log() {
  prio="info"
  [ "$1" != '' ] && prio=$1
  tee -a $logfile < /dev/stdin | systemd-cat -t backkup-script -p $prio
}


# Abhängigkeiten prüfen
for dependency in $dependencies; do
    which $dependency >/dev/null || { echo "$dependency nicht installiert. Abbruch." | write_to_log && exit 2 ; }
done


# Prüfen, ob Verzeichnis existiert, ansonsten erstellen
# NOTE: kein mkdir -p wegen Logging
if [ ! -d $path_to_backup_dir ]; then
    mkdir $path_to_backup_dir 
    message_dir="Backup Verzeichnis angelegt"
else
    message_dir="Backup Verzeichnis vorhanden"
fi

echo --- Backup Script gestartet: $(date "+%Y%m%d %H:%M.%S") --- | write_to_log

echo $message_dir | write_to_log

# tar Archiv erstellen
tar --create --verbose --bzip2 --file $backup_file \
    --exclude-from=$exclude_file $dirs_to_backup \
    2>&1 | write_to_log


# tar-Archiv verschlüsseln und signieren
gpg --recipient $gpg_key_dennis_s \
    --recipient $gpg_key_dennis_w \
    --recipient $gpg_key_armin_s \
    --recipient $gpg_key_tux_t \
    --sign \
    --default-key $gpg_key_tux_t \
    --encrypt $backup_file 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Backup erfolgreich verschlüsselt" | write_to_log
    rm -v $backup_file | write_to_log
else
    echo "FEHLER beim Verschlüsseln des Backups. Abbruch" | write_to_log err
    exit 1
fi

# Backups auf Backup-Server pushen
# NOTE: scp unterdrückt stdout wenn dieser umgeleitet wird
scp -i $ssh_key ${backup_file}.gpg ${backup_server}:backups &>/dev/null

if [ $? -eq 0 ]; then
    echo "Backup erfolgreich auf Server $backup_server hochgeladen" | write_to_log
    # TODO alte Backups löschen (1-3) behalten
else
    echo "FEHLER beim Hochladen des Backups auf $backup_server" | write_to_log err
    exit 3
fi

# Alte Backups und Logs löschen
# NOTE: nicht 100% sicher, dass auch immer alle .gpg Dateien gelöscht werden
gpg_files="$path_to_backup_dir/*.gpg"
if [ $(ls $gpg_files | wc -l) -gt 3 ]; then
    echo "Folgende Backups wurden gelöscht:" | write_to_log notice
    #ls $gpg_files | sort | head -n -3 | xargs rm -v | write_to_log notice

    for file in $(ls ${path_to_backup_dir}/*.log | sort | head -n -3); do 
        rm -v ${path_to_backup_dir}/$(basename $file .log).{log,tar.bz2.gpg} 
    done 
fi


echo --- Backup Script erfolgreich beendet: $(date "+%Y%m%d %H:%M.%S") --- | write_to_log

exit 0


# TODO:
# - [x] timestamp an backup namen
# - [x] prüfen, ob backup_dir vorhanden, sonst erstellen
# - [x] was ist mit tar Dateien im Heimatverzeichnis?  find? Pattern?
# - [x] was ist mit den "unnötigen" Fehlermeldungen?
# - [x] Logging
# - [x] Backups verschlüsseln und signieren
#  - [x] Prüfen ob gpg vorhanden (?)
#  - [x] Prüfen ob rsync vorhanden (?)
# - [x] Wohin mit den Backups? -> anderer Server
# - [ ] Skript automatisch starten mit cron oder systemd-timer?

# TODO 2:
# - [x] alte Backups löschen
# - [ ] weitere Verzeichnisse, z.B. /etc /var?
# - [ ] root Rechte?
# - [ ] weitere Priorities fürs Logging? 


 
 
 
