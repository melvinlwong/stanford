install
text
#url --url http://NETINSTALL-HOST/centos/6.0/x86_64
url --url http://linux.stanford.edu/yum/pub/centos/6/os/x86_64
lang en_US.UTF-8
keyboard us
timezone --utc US/Pacific
network --noipv6 --onboot=yes --bootproto dhcp
authconfig --enableshadow --enablemd5
rootpw --iscrypted $6$prFT2eLl.jN7RLlo$Z40pvDMTfPE/TeiNJ2DbygfVj3fUW1M3Gjq4aJ2YwYbrPbSAOp6qJec7zUj4bEvY4oNOtXxJKWcqS5YXXReuj1
firewall --enabled --port 22:tcp
selinux --disabled
#bootloader --location=mbr --driveorder=sda --append="crashkernel=auth rhgb"
bootloader --location=mbr --append="crashkernel=auth rhgb"

# Disk Partitioning
#clearpart --all --initlabel --drives=sda
#part /boot --fstype=ext4 --size=200
#part pv.1 --grow --size=1
#volgroup vg1 --pesize=4096 pv.1
#
#logvol / --fstype=ext4 --name=lv001 --vgname=vg1 --size=6000
#logvol /var --fstype=ext4 --name=lv002 --vgname=vg1 --grow --size=1
#logvol swap --name=lv003 --vgname=vg1 --size=2048
zerombr
clearpart --all --initlabel
part / --fstype ext4 --size=1 --grow #5.4GB
part /boot --fstype ext4 --size=100
part swap --size=50 #2GB
# END of Disk Partitioning

# Make sure we reboot into the new system when we are finished
reboot

# Package Selection
%packages --nobase --excludedocs
@core
#-*firmware
#-iscsi*
#-fcoe*
#-b43-openfwwf
#kernel-firmware
#-efibootmgr
wget
sudo
perl
#libselinux-python

%pre

%post --log=/root/install-post.log
(
PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PATH

# PLACE YOUR POST DIRECTIVES HERE
df -h
mkdir /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIZ15ZFTaAzUP3+xRp6EJQQgw/jULh9wfUhAlQYDiEP1F5OqWS3PdArlF4VyKT2uuyhwptsmR662wEAQvLUvyV/IdnsWY0kGKMUdf+fdDv0xjFNYovsCwLAwBFEEfyDnxGvysNAxnm4lokZ0pQRSvO6xjMu7XaznGL2ufp3QSPzAB/3NDyI253JY8xnkIczSlMvMxn7AkBqz50CnnCtGWry0oJ1GzOWrQXKOaf8oeHGXd3ri+AqBCx/14lAdebGZJA7V+/W0xSyEM3BHAc/I6fqJ+VFBub0pdJgIfdn9xAJFjJtPeqxBOcsUMxzmEHapo8qdYSH78ExHLjf5sVS9nz dha" > /root/.ssh/authorized_keys
chmod -R go-rwx /root/.ssh
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
) 2>&1 >/root/install-post-sh.log
