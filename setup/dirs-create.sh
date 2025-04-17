sudo mkdir -p /opt/minecraft
sudo mkdir -p /opt/minecraft/minecraft-hotel
sudo mkdir -p /opt/minecraft/minecraft-frostbite
sudo mkdir -p /opt/backup

sudo chown -R minecraft:minecraft /opt/minecraft
sudo chown -R svc-minecraft-hotel:minecraft /opt/minecraft/minecraft-hotel
sudo chown -R svc-minecraft-frostbite:minecraft /opt/minecraft/minecraft-frostbite
sudo chown -R svc-backup:svc-backup /opt/backup

sudo chmod -R 770 /opt/minecraft/minecraft-hotel
sudo chmod -R 770 /opt/minecraft/minecraft-frostbite
sudo chmod -R o+x /opt/minecraft
