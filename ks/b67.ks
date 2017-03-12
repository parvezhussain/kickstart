install
url --url http://192.168.1.1/centos/6
lang en_US.UTF-8
keyboard us
timezone --utc America/Chicago
network --noipv6 --onboot=yes --bootproto dhcp
authconfig --enableshadow --enablemd5
##root password is 'changeme'
rootpw --iscrypted $1$KXnnttMd$kJfDBf0eN5q0hAFbXW8.D.
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
#virt-what
#augeas-libs
#rubygems

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

#cat <<EOF >/etc/sysconfig/network
#NETWORKING=yes
#HOSTNAME=$HOSTNAME
3GATEWAY=$GATEWAY
#EOF

cat <<EOF >/etc/sysconfig/network-scripts/ifcfg-$DEVICE
DEVICE=$DEVICE
BOOTPROTO=static
IPADDR=$IPADDR
NETMASK=$NETMASK
ONBOOT=yes
HWADDR=$HWADDR
EOF

cat <<EOF >/etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
TYPE=Ethernet
NM_CONTROLLED=yes
BOOTPROTO=dhcp
ONBOOT=yes
EOF

cat <<EOF >/etc/resolv.conf
domain localhost.com
nameserver 192.168.1.1
EOF

echo "Updating YUM Repositories"
cd /etc/yum.repos.d
cp -p CentOS-Base.repo CentOS-Base.repo.orig
wget -O /etc/yum.repos.d/CentOS-Base.repo http://192.168.1.1/ks/6.7/CentOS-Base.repo
wget -O /etc/yum.repos.d/puppetlabs.repo http://192.168.1.1/ks/6.7/puppetlabs.repo
wget -O /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs http://192.168.1.1/ks/6.7/RPM-GPG-KEY-puppetlabs

echo "Installing root ssh keys"
mkdir /root/.ssh
wget -O /root/.ssh/authorized_keys http://192.168.1.1/ks/6.7/authorized_keys_root
chmod 0700 /root/.ssh
chmod 0600 /root/.ssh/authorized_keys
chown -R root:root /root/.ssh

echo "Installing Puppet agent Cron"
wget -O /var/spool/cron/root http://192.168.1.1/ks/6.7/cron_root
echo "Disabling IPTables"
service iptables off
chkconfig iptables off

echo "Installing Puppet"

cat <<EOF >>/etc/hosts
$IPADDR  $HOSTNAME
192.168.1.5 pemaster.localhost.com
EOF

yum install puppet -y
wget -O /etc/puppet/puppet.conf http://192.168.1.1/ks/6.7/puppet.conf
/usr/bin/puppet agent -tv




) 2>&1 >/root/install-post-sh.log
