#!/bin/bash
echo "=================================================================================="
echo "Uninstalling EasyNAS..."
echo "=================================================================================="
DEBIAN_FRONTEND=noninteractive \apt purge samba rsync php-cgi git mdadm smartmontools cryptsetup apt-transport-https curl gnupg-agent software-properties-common dnsutils rclone -y
echo "================================================================================="
echo "Uninstall Docker"
echo "================================================================================="
apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras -y
rm -rf /var/lib/docker
rm -rf /var/lib/containerd 
apt autoremove --purge -y
echo "=================================================================================="
echo "Removing Samba configuration"
echo "=================================================================================="
rm /etc/samba/shares.conf
rm -rf /etc/samba/shares
echo "=================================================================================="
echo "Removing Volumes Directory for Volume mounts"
echo "=================================================================================="
rm -rf /volumes
echo "=================================================================================="
echo "Removing Filebrowser Service..."
echo "=================================================================================="
systemctl stop filebrowser
systemctl disable --now filebrowser
rm /etc/systemd/system/filebrowser.service
echo "=================================================================================="
echo "Removing easynas Service..."
echo "=================================================================================="
systemctl stop easynas
systemctl disable --now easynas
rm /etc/systemd/system/easynas.service
echo "=================================================================================="
echo "Removing easynas folder..."
echo "=================================================================================="
rm -rf /easynas
echo "==============================================================================================================================="
echo "             EasyNAS unistallation complete. System will reboot in 1 minute.....								 	                                 "
echo "==============================================================================================================================="
shutdown -r +1