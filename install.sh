#!/bin/bash
if [[ $(id -u) -ne 0 ]] ; 
	then
	echo "=========================================================" ;
	echo "Enter root password and then rerun install.sh to continue" ; 
	echo "=========================================================" ;
	su ;
	exit 1 ; 
fi
echo "=================================================================================="
echo "Checking For Updates..."
echo "=================================================================================="
apt update
echo "=================================================================================="
echo "Installing Updates..."
echo "=================================================================================="
DEBIAN_FRONTEND=noninteractive \apt dist-upgrade -y
echo "=================================================================================="
echo "Installing Additional Required Packages..."
echo "Samba, PHP, Rsync, mdadm (RAID), cryptsetup (LUKS Encryption) etc"
echo "=================================================================================="
DEBIAN_FRONTEND=noninteractive \apt install samba rsync php-cgi git mdadm smartmontools cryptsetup apt-transport-https curl gnupg-agent software-properties-common dnsutils rclone -y
echo "================================================================================="
echo "Install Docker Repo"
echo "================================================================================="
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt update
echo "=================================================================================="
echo "Adding group admins and adding the group to the sudoers allow list                "
echo "=================================================================================="
groupadd admins
echo '%admins   ALL=(ALL:ALL) ALL' > /etc/sudoers.d/admins
echo "=================================================================================="
echo "Allowing SSH Root Login..."
echo "=================================================================================="
sed -i 's/prohibit-password/yes/' /etc/ssh/sshd_config
cd /
echo "=================================================================================="
echo "Downloading the latest easynas from GIT repo..."
echo "=================================================================================="
git clone https://github.com/gurukewl/easynas.git
echo "=================================================================================="
echo "Setting up Samba configuration"
echo "=================================================================================="
mv /etc/samba/smb.conf /etc/samba/smb.conf.ori
cp /easynas/conf/smb.conf /etc/samba/
touch /etc/samba/shares.conf
mkdir /etc/samba/shares
echo "=================================================================================="
echo "Creating Volumes Directory for Volume mounts"
echo "=================================================================================="
mkdir /volumes
echo "=================================================================================="
echo "Installing and Enabling Filebrowser..."
echo "=================================================================================="
cd /usr/local/etc
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
cp /easynas/conf/filebrowser.service /etc/systemd/system/
chmod 755 /etc/systemd/system/filebrowser.service
systemctl enable filebrowser
systemctl start filebrowser
echo "=================================================================================="
echo "Installing and Enabling easynas Service during Startup..."
echo "=================================================================================="
cp /easynas/conf/easynas.service /etc/systemd/system/
chmod 755 /etc/systemd/system/easynas.service
systemctl enable easynas
systemctl start easynas
IP="$(ip addr show | grep -E '^\s*inet' | grep -m1 global | awk '{ print $2 }' | sed 's|/.*||')";
HOSTNAME="$(hostname)";
echo "==============================================================================================================================="
echo "                                                   Almost There!																                               "
echo "             Visit http://$IP:999 in your web browser to complete installation								 	                                 "
echo "==============================================================================================================================="