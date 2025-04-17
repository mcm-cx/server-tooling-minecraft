#!/bin/bash

set -e

TIMESTAMP=$(date +'%Y-%m-%dT%H%M%S')
BACKUP_SOURCE='/opt/minecraft'
BACKUP_DIR='/opt/backup/minecraft'
LOG_DIR='/opt/backup/logs'
LOGFILE="$LOG_DIR/minecraft-$TIMESTAMP.log"
RCLONE_REMOTE='onedrive-backup-mcm-cx:minecraft'

# ToDo: array
HOTEL_PATH='/minecraft-hotel'
FROSTBITE_PATH='/minecraft-frostbite'

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

exec > >(tee -a "$LOGFILE") 2>&1

echo "[*] Backup started: $TIMESTAMP"

echo "[*] Stopping servers..."
sudo /usr/bin/systemctl stop minecraft-hotel
sudo /usr/bin/systemctl stop minecraft-frostbite

echo "[*] waiting (10s)..."
sleep 10

# ToDo: create a function to do this!

#### BACKUP HOTEL ####
echo "[*] Backing up world: TheHotel"
HOTEL_ZIP="$BACKUP_DIR/hotel-$TIMESTAMP.zip"
zip -r "$HOTEL_ZIP" "$BACKUP_SOURCE/$HOTEL_PATH/worlds"

#echo "[*] Sammle JSON + Properties: hotel"
#HOTEL_META_DIR="$BACKUP_DIR/hotel-meta-$TIMESTAMP"
#mkdir -p "$HOTEL_META_DIR"
#cp "$HOTEL_PATH"/*.json "$HOTEL_META_DIR" || true
#cp "$HOTEL_PATH/server.properties" "$HOTEL_META_DIR" || true

#### BACKUP FROSTBITE ####
echo "[*] Backing up world: frostbite"
FROSTBITE_ZIP="$BACKUP_DIR/frostbite-$TIMESTAMP.zip"
zip -r "$FROSTBITE_ZIP" "$BACKUP_SOURCE/$FROSTBITE_PATH/worlds"

#echo "[*] Sammle JSON + Properties: frostbite"
#FROSTBITE_META_DIR="$BACKUP_DIR/frostbite-meta-$TIMESTAMP"
#mkdir -p "$FROSTBITE_META_DIR"
#cp "$FROSTBITE_PATH"/*.json "$FROSTBITE_META_DIR" || true
#cp "$FROSTBITE_PATH/server.properties" "$FROSTBITE_META_DIR" || true



echo "[*] Uploading ..."

# hotel
rclone copy "$HOTEL_ZIP" "$RCLONE_REMOTE/hotel/" --progress
rclone copy "$BACKUP_SOURCE/$HOTEL_PATH/*.json" "$RCLONE_REMOTE/hotel/" --progress
rclone copy "$BACKUP_SOURCE/$HOTEL_PATH/*.properties" "$RCLONE_REMOTE/hotel/" --progress

# frostbite
rclone copy "$FROSTBITE_ZIP" "$RCLONE_REMOTE/frostbite/" --progress
rclone copy "$BACKUP_SOURCE/$FROSTBITE_PATH/*.json" "$RCLONE_REMOTE/frostbite/" --progress
rclone copy "$BACKUP_SOURCE/$FROSTBITE_PATH/*.properties" "$RCLONE_REMOTE/frostbite/" --progress


echo "[*] Starting servers..."
sudo /usr/bin/systemctl start minecraft-hotel
sudo /usr/bin/systemctl start minecraft-frostbite

#### clean up ####
#rm -rf "$HOTEL_META_DIR" "$FROSTBITE_META_DIR"
rm -f "$HOTEL_ZIP" "$FROSTBITE_ZIP"

echo "[✔] Backup finished: $TIMESTAMP"
