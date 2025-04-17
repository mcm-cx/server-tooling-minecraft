exit 1; # just for documentation, do not execute!

sudo useradd \
  --system \
  --no-create-home \
  --shell /usr/sbin/nologin \
  --comment "Service User for Minecraft 'TheHotel'" \
  svc-minecraft-hotel

sudo useradd \
  --system \
  --no-create-home \
  --shell /usr/sbin/nologin \
  --comment "Service User for Minecraft 'Frostbite'" \
  svc-minecraft-frostbite

sudo useradd \
  --system \
  --no-create-home \
  --shell /usr/sbin/nologin \
  --comment "Service User for Backups" \
  svc-backup

# change home dir for service users
sudo usermod -d /opt/minecraft/minecraft-hotel svc-minecraft-hotel
sudo usermod -d /opt/minecraft/minecraft-frostbite svc-minecraft-frostbite
sudo usermod -d /opt/backup svc-backup

# add new group "minecraft"
sudo groupadd minecraft

# add group "minecraft" to service-users and mjs
sudo usermod -aG minecraft svc-minecraft-hotel
sudo usermod -aG minecraft svc-minecraft-frostbite
# - 'other' will get access to minecraft-folder ... sudo usermod -aG minecraft svc-backup
sudo usermod -aG minecraft mjs

# configure directories
