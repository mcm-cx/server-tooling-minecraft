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
