#!/bin/bash

set -e

TIMESTAMP=$(date +'%Y-%m-%dT%H%M%S')
BACKUP_SOURCE='/opt/minecraft'
BACKUP_DIR='/opt/backup/minecraft'
LOG_DIR='/opt/backup/logs'
LOGFILE="$LOG_DIR/minecraft-$TIMESTAMP.log"
RCLONE_REMOTE='onedrive-backup-mcm-cx:minecraft/jaedenar.mcm.cx'
GIT_BACKUP='/opt/backup/backup-minecraft-jaedenar/worlds'

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
HOTEL_ZIP="$BACKUP_DIR/hotel-$TIMESTAMP.tar.gz"
tar -czf "$HOTEL_ZIP" -C "$BACKUP_SOURCE$HOTEL_PATH/worlds" .

#echo "[*] Sammle JSON + Properties: hotel"
#HOTEL_META_DIR="$BACKUP_DIR/hotel-meta-$TIMESTAMP"
#mkdir -p "$HOTEL_META_DIR"
#cp "$HOTEL_PATH"/*.json "$HOTEL_META_DIR" || true
#cp "$HOTEL_PATH/server.properties" "$HOTEL_META_DIR" || true

#### BACKUP FROSTBITE ####
echo "[*] Backing up world: frostbite"
FROSTBITE_ZIP="$BACKUP_DIR/frostbite-$TIMESTAMP.tar.gz"
tar -czf "$FROSTBITE_ZIP" -C "$BACKUP_SOURCE$FROSTBITE_PATH/worlds" .

#echo "[*] Sammle JSON + Properties: frostbite"
#FROSTBITE_META_DIR="$BACKUP_DIR/frostbite-meta-$TIMESTAMP"
#mkdir -p "$FROSTBITE_META_DIR"
#cp "$FROSTBITE_PATH"/*.json "$FROSTBITE_META_DIR" || true
#cp "$FROSTBITE_PATH/server.properties" "$FROSTBITE_META_DIR" || true


echo "[*] Starting servers..."
sudo /usr/bin/systemctl start minecraft-hotel
sudo /usr/bin/systemctl start minecraft-frostbite


echo "[*] Uploading ..."

# hotel
rclone copy "$HOTEL_ZIP" "$RCLONE_REMOTE/hotel/"
rclone copy "$BACKUP_SOURCE/$HOTEL_PATH" "$RCLONE_REMOTE/hotel/" --include "*.json" --include "*.properties" --max-depth 1

# frostbite
rclone copy "$FROSTBITE_ZIP" "$RCLONE_REMOTE/frostbite/"
rclone copy "$BACKUP_SOURCE/$FROSTBITE_PATH" "$RCLONE_REMOTE/frostbite/" --include "*.json" --include "*.properties" --max-depth 1

#### clean up ####
#rm -rf "$HOTEL_META_DIR" "$FROSTBITE_META_DIR"
cp "$HOTEL_ZIP" "$GIT_BACKUP/hotel.tar.gz"
cp "$FROSTBITE_ZIP" "$GIT_BACKUP/frostbite.tar.gz"
rm -f "$HOTEL_ZIP" "$FROSTBITE_ZIP"

echo "[✔] Backup finished: $TIMESTAMP"
