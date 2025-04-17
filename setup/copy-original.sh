# copy 'as user'
sudo -u svc-minecraft-hotel cp -r /home/minecraft/bedrock-hotel/* /opt/minecraft/minecraft-hotel/
sudo -u svc-minecraft-frostbite cp -r /home/minecraft/bedrock-hotel/* /opt/minecraft/minecraft-frostbite/
# change ownership
sudo chown -R svc-minecraft-hotel:minecraft /opt/minecraft/minecraft-hotel/
sudo chown -R svc-minecraft-frostbite:minecraft /opt/minecraft/minecraft-frostbite/
# remove others-rights
sudo find /opt/minecraft \( -type f -o -type d \) -exec chmod o-rwx {} \;
