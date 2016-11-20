install
url --url http://192.168.1.1/centos/6
#url --url http://192.168.1.1/centos/6.7
lang en_US.UTF-8
keyboard us
timezone --utc America/Chicago
network --noipv6 --onboot=yes --bootproto dhcp
authconfig --enableshadow --enablemd5
rootpw --iscrypted $6$Gjoe77bLWE3E9Hh2$dzgnFXpIagl/fiNBBqqEkedOo1gqK1X4yf1ItvyOoW2FqJyCHFSrAJJ1cDX2hmFHka5zyZvMKg2kqsQDy5epD.
firewall --enabled --port 22:tcp
selinux --permissive
bootloader --location=mbr --driveorder=sda --append="crashkernel=auth rhgb"

# Disk Partitioning
clearpart --all --initlabel --drives=sda
part /boot --fstype=ext4 --size=200
part pv.1 --grow --size=1
volgroup vg1 --pesize=4096 pv.1

logvol / --fstype=ext4 --name=lv001 --vgname=vg1 --size=1000
logvol /var --fstype=ext4 --name=lv002 --vgname=vg1 --size=1000
logvol swap --name=lv003 --vgname=vg1 --size=1024
logvol /opt --fstype=ext4 --name=lv004 --vgname=vg1 --grow --size=1
# END of Disk Partitioning

# Make sure we reboot into the new system when we are finished
reboot

# Package Selection
%packages --nobase --excludedocs
@core
-*firmware
-iscsi*
-fcoe*
-b43-openfwwf
kernel-firmware
-efibootmgr
wget
sudo
perl
rsync
openssh-clients
bind-utils
mlocate
pciutils
unzip
java

%pre

%post --log=/root/install-post.log
(
PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PATH

# PLACE YOUR POST DIRECTIVES HERE

echo "Converting DHCP scope to static IP address"

DEVICE=`route -n|grep '^0.0.0.0'|awk '{print $8}'`
IPADDR=`ifconfig $DEVICE|grep 'inet addr:'|awk '{sub(/addr:/,""); print $2}'`
NETMASK=`ifconfig $DEVICE|grep 'Mask'|awk '{sub(/Mask:/,""); print $4}'`
NETWORK=`ipcalc $IPADDR -n $NETMASK|awk -F= '{print $2}'`
GATEWAY=`route -n|grep '^0.0.0.0'|awk '{print $2}'`
HWADDR=`ifconfig $DEVICE|grep 'HWaddr'|awk '{print $5}'`

cat <<EOF >/etc/sysconfig/network-scripts/ifcfg-$DEVICE
DEVICE=$DEVICE
BOOTPROTO=static
IPADDR=$IPADDR
NETMASK=$NETMASK
ONBOOT=yes
HWADDR=$HWADDR
EOF

echo "Updating YUM Repositories"
cd /etc/yum.repos.d
cp -p CentOS-Base.repo CentOS-Base.repo.orig
wget -O /etc/yum.repos.d/CentOS-Base.repo http://192.168.1.1/ks/6.7/CentOS-Base.repo

echo "Disabling IPTables"
service iptables off
chkconfig iptables off


) 2>&1 >/root/install-post-sh.log
