# kickstart
Kickstart and other files

### GETTING THE LAPTOP READY
### WHAT YOU WILL NEED ON YOUR LAPTOP (also called the HOST MACHINE)

Oracle virtual box <br>
https://www.virtualbox.org/ <br>
Centos DVD download - CentOS-6.8-x86_64-bin-DVD1.iso <br>
http://isoredirect.centos.org/centos/6.8/isos/x86_64/ <br>
Putty<br>
http://www.putty.org/ <br>
Winscp <br>
https://winscp.net/eng/download.php <br>

Create your account in github <br>
https://github.com/ <br>

Read this article to understand Networking on Oracle Virtualbox<br>
https://technology.amis.nl/2014/01/27/a-short-guide-to-networking-in-virtual-box-with-oracle-linux-inside/

How to make virtualbox guest use its host’s internet connection and still have ssh access to the guest
http://www.mycodingpains.com/how-to-make-virtualbox-guest-use-its-hosts-internet-connection-and-still-have-ssh-access-to-the-guest/


### Create and Install the Kickstart Server

Make sure all the above software are installed

Install centos on the guest VM. Select 'Minimal" during installation <br>
https://www.youtube.com/watch?v=z0_d_06jrWE

Open Oracle VirtualBox and setup the network as per the instructions provided below. (IMPORTANT) <br>
How to make virtualbox guest use its host’s internet connection and still have ssh access to the guest<br>
http://www.mycodingpains.com/how-to-make-virtualbox-guest-use-its-hosts-internet-connection-and-still-have-ssh-access-to-the-guest/


1. Ceate a guest VM as pxeserver <br>
Open Oracle VirtualBox(VB). Select 'New'<br>
Name:pxeserver<br>
Type:Linux<br>
Version: Redhat (64-bit)<br>
Memory Size: 1024MB<br>

Click 'Create'

File Location: pxeserver<br>
File size: 20GB<br>

Click 'Create'

A new guest VM is created with name 'pxeserver'<br>
Select the the guest VM 'pxeserver'. Select 'Settings'<br>
Select 'Network' from navigation panel.<br>
Adaptor 1<br>
'Enable Network Adapter' checked box. Attached to: Internal Network<br>
Adaptor 2<br>
'Enable Network Adapter' checked box. Attached to: Host-Only Adapter<br>
Adaptor 3<br>
'Enable Network Adapter' checked box. Attached to: NAT<br>

Select 'Storage' from Navigation Panel<br>
(From middle Panel) Select 'Storage Tree' -> Controller: IDE -> Empty<br>
(From right panel) Click on the (disk) and provide the path to CentOS-6.8-x86_64-bin-DVD1.iso<br>
Click OK

You will be on the Home screen of VirtualBox

from Navigation Panel, select 'pxeserver' and click 'Start'<br>
Centos will start installation.<br>
Except the below settings, select all default <br>
hostname:    pxeserver.localhost.com<br>
Server type: minimal

The pxeserver vm will automatically reboot.

### Setting up the network for the guest VM




Login to the pxeserver through the console

Post Linux Install:

edit ifcfg-eth0, ifcfg-eth1, ifcfg-eth2:<br>
onboot=yes

edit ifcfg-eth0<br>
IPADDR=192.168.1.1<br>
dhcp=static

service network restart

ifconfig

Verify the network settings: and notice the IP address of eth1 (host-only adapter) ex:192.168.56.101

Now open putty connect to pxeserver using 192.168.56.101<br>
if you are successful, Congratulation!! you are able to connect to the pxe server (inbound). <br>

Now test the outbound connection. From pxe server, ping www.google.com <br>
You should see response. Congratulation!! your outbound connection is working. <br>

### Configure the Kickstart Server

yum -y install rsync httpd dhcp tftp-server syslinux git mlocate elinks bind-utils telnet

mkdir /opt/git <br>
git clone https://<your_github_id>@github.com/parvezhussain/kickstart.git /opt/git

Disable iptables<br>
Set SELinux to permissive Otherwise file browsing through http webserver will not work <br>
Edit the file /etc/SELinux/config<br>
SELinux=permissive

mkdir -p /var/www/html/centos/6.8<br>
cd /var/www/html/centos<br>
ln -s 6.8 6
cd /var/www/html/centos/6.8<br>

wget -r -nH -nc --cut-dirs=4 --no-parent --reject="index.html*" http://mirror.centos.org/centos/6.8/os/x86_64/

Under /var/www/html/centos/6.8, you should see the same files as http://mirror.centos.org/centos/6.8/os/x86_64/
 
Start httpd<br>
service httpd start  (ignore any error) <br>
ps -ef | grep httpd<br>
make sure httpd start on boot<br>
chkconfig httpd on<br>
chkconfig | grep httpd


From your laptop browser check http://<eth1 IPaddress of pxeserver> <br>
You should see the Apache page. This means the apache is working.

http://<eth1 IPaddress of pxeserver>/centos/6<br>
You should see all the files and folders like http://mirror.centos.org/centos/6.8/os/x86_64/<br>
Make sure you are able to browse the FILES ALSO.<br>

CONGRATULATION!! your web file server is working.<br>
This is one part of PXE boot<br>



 
###KICKSTART SERVER 



Configure PXE server <br>
https://wiki.centos.org/HowTos/NetworkInstallServer

Point your repository to  /var/www/html/centos/6

Download Files For PUPPET Client yum repo--- <br>

CMD='wget -r -nH -nc --cut-dirs=4 --no-parent --reject="index.html*"'

$CMD https://yum.puppetlabs.com/el/6/products/x86_64/facter-1.7.0-1.el6.x86_64.rpm<br>
$CMD https://yum.puppetlabs.com/el/6/products/x86_64/hiera-1.3.4-1.el6.noarch.rpm<br>               
$CMD https://yum.puppetlabs.com/el/6/products/x86_64/libselinux-ruby-2.0.94-5.8.el6.x86_64.rpm<br>  Present in centos 6.8
$CMD https://yum.puppetlabs.com/el/6/products/x86_64/puppet-3.8.5-1.el6.noarch.rpm<br>              
$CMD https://yum.puppetlabs.com/el/6/products/x86_64/ruby-augeas-0.4.1-3.el6.x86_64.rpm<br>
$CMD https://yum.puppetlabs.com/el/6/products/x86_64/rubygem-json-1.5.5-3.el6.x86_64.rpm<br>
$CMD https://yum.puppetlabs.com/el/6/products/x86_64/ruby-shadow-2.2.0-2.el6.x86_64.rpm<br>


=======================================================
PUPPET

Installation Process:

Ping server and client so that they talk to each other

Date set correctly 

(Error: Could not request certificate: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed: [CRL is not yet valid for /CN=Puppet CA: foreman.company.com])




yum install http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm -y

yum install puppet-server -y

vi /etc/puppet/puppet.conf

Add the line:

    # Where SSL certificates are kept.
    # The default value is '$confdir/ssl'.
    ssldir = $vardir/ssl

alt_dns_names = jbccllpupc610,jbccllpupc610.localhost.com

/etc/init.d/iptables stop

chkconfig | grep iptables
chkconfig iptables off
chkconfig | grep iptables

service puppetmaster start

ps -ef | grep puppet

ifconfig

yum install telnet -y
puppet cert list
puppet cert sign peclient.localhost.com

cd /etc/puppet

ps -ef | grep puppet

puppet agent -tv


yum -y install http://yum.theforeman.org/releases/latest/el6/x86_64/foreman-release-1.10.0-1.el6.noarch.rpm
yum -y install epel-release

yum install foreman-installer -y

foreman-installer

INSTALL AND CONFIGURE PUPPET


http://techarena51.com/index.php/a-simple-way-to-install-and-configure-a-puppet-server-on-linux/

 

How to change how often agents "check-in"?

https://ask.puppetlabs.com/question/932/how-to-change-how-often-agents-check-in/

 

LIST ALL NODES

Puppet cert list --all


==========================================

PUPPET EXTRA NOTES
 
1.  yum install openssh-clients
2.  vi /etc/yum.repos.d/CentOS-Base.repo
3.  yum install openssh-clients -y
4.  yum install pciutils -y
5.  yum install rubygems
6.  yum install virt-what
7.  yum install augeas-libs
8.  cd /tmp/puppetlabs/
9.  ls -l
10.  rpm -i ruby-augeas-0.4.1-3.el6.x86_64.rpm
11.  rpm -i rubygem-json-1.5.5-3.el6.x86_64.rpm
12.  rpm -i hiera-1.3.4-1.el6.noarch.rpm
13.  rpm -i facter-1.7.0-1.el6.x86_64.rpm
14.  rpm -i libselinux-ruby-2.0.94-5.8.el6.x86_64.rpm
15.  rpm -i ruby-shadow-2.2.0-2.el6.x86_64.rpm
16.  rpm -i puppet-3.8.5-1.el6.noarch.rpm

[root@PXEClient yum.repos.d]# rpm -i puppet-3.8.5-1.el6.noarch.rpm

warning: puppet-3.8.5-1.el6.noarch.rpm: Header V4 RSA/SHA512 Signature, key ID 4bd6ec30: NOKEY

error: Failed dependencies:

        /usr/bin/ruby is needed by puppet-3.8.5-1.el6.noarch
        facter >= 1:1.7.0 is needed by puppet-3.8.5-1.el6.noarch
        hiera >= 1.0.0 is needed by puppet-3.8.5-1.el6.noarch
        ruby >= 1.8 is needed by puppet-3.8.5-1.el6.noarch
        ruby >= 1.8.7 is needed by puppet-3.8.5-1.el6.noarch
        ruby(selinux) is needed by puppet-3.8.5-1.el6.noarch
        ruby-augeas is needed by puppet-3.8.5-1.el6.noarch
        ruby-shadow is needed by puppet-3.8.5-1.el6.noarch
        rubygem-json is needed by puppet-3.8.5-1.el6.noarch

[root@PXEClient yum.repos.d]# rpm -i facter-1.7.0-1.el6.x86_64.rpm

warning: facter-1.7.0-1.el6.x86_64.rpm: Header V4 RSA/SHA1 Signature, key ID 4bd6ec30: NOKEY
error: Failed dependencies:
        dmidecode is needed by facter-1:1.7.0-1.el6.x86_64
        virt-what is needed by facter-1:1.7.0-1.el6.x86_64

[root@PXEClient yum.repos.d]# rpm -i hiera-1.3.4-1.el6.noarch.rpm
warning: hiera-1.3.4-1.el6.noarch.rpm: Header V4 RSA/SHA512 Signature, key ID 4bd6ec30: NOKEY
error: Failed dependencies:

        rubygem-json is needed by hiera-1.3.4-1.el6.noarch

[root@PXEClient yum.repos.d]#

[root@PXEClient yum.repos.d]# rpm -i rubygem-json-1.5.5-3.el6.x86_64.rpm
warning: rubygem-json-1.5.5-3.el6.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 4bd6ec30: NOKEY

error: Failed dependencies:
       rubygems >= 1.3.7 is needed by rubygem-json-1.5.5-3.el6.x86_64

[root@PXEClient yum.repos.d]# rpm -i rubygems-1.3.7-5.el6.noarch.rpm
error: Failed dependencies:

        ruby-rdoc is needed by rubygems-1.3.7-5.el6.noarch

[root@PXEClient yum.repos.d]#

[root@PXEClient yum.repos.d]# rpm -i ruby-rdoc-1.8.7.374-4.el6_6.x86_64.rpm

error: Failed dependencies:

        ruby-irb = 1.8.7.374-4.el6_6 is needed by ruby-rdoc-1.8.7.374-4.el6_6.x86_64

 

[root@PXEClient yum.repos.d]# rpm -i libselinux-ruby-2.0.94-7.el6.x86_64.rpm

error: Failed dependencies:

        libselinux = 2.0.94-7.el6 is needed by libselinux-ruby-2.0.94-7.el6.x86_64

[root@PXEClient yum.repos.d]#

 

[root@PXEClient yum.repos.d]# rpm -i ruby-augeas-0.4.1-3.el6.x86_64.rpm

warning: ruby-augeas-0.4.1-3.el6.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 4bd6ec30: NOKEY

error: Failed dependencies:

        augeas-libs >= 0.8.0 is needed by ruby-augeas-0.4.1-3.el6.x86_64

        libaugeas.so.0()(64bit) is needed by ruby-augeas-0.4.1-3.el6.x86_64

        libaugeas.so.0(AUGEAS_0.1.0)(64bit) is needed by ruby-augeas-0.4.1-3.el6.x86_64

        libaugeas.so.0(AUGEAS_0.10.0)(64bit) is needed by ruby-augeas-0.4.1-3.el6.x86_64

        libaugeas.so.0(AUGEAS_0.11.0)(64bit) is needed by ruby-augeas-0.4.1-3.el6.x86_64

        libaugeas.so.0(AUGEAS_0.12.0)(64bit) is needed by ruby-augeas-0.4.1-3.el6.x86_64

        libaugeas.so.0(AUGEAS_0.8.0)(64bit) is needed by ruby-augeas-0.4.1-3.el6.x86_64

[root@PXEClient yum.repos.d]# yum install augeas-libs

Loaded plugins: fastestmirror

Setting up Install Process

Loading mirror speeds from cached hostfile

Resolving Dependencies

--> Running transaction check

---> Package augeas-libs.x86_64 0:1.0.0-10.el6 will be installed

--> Finished Dependency Resolution

 

Dependencies Resolved

 

==================================================================================================================

 Package                      Arch                    Version                         Repository             Size

==================================================================================================================

Installing:

 augeas-libs                  x86_64                  1.0.0-10.el6                    base                  314 k

 

Transaction Summary

==================================================================================================================

Install       1 Package(s)

 

Total download size: 314 k

Installed size: 949 k

Is this ok [y/N]:

 

 

 

yum install openssh-clients

yum install pciutils

 

yum install virt-what   yum install dmidecode

yum install augeas-libs

yum install rubygems [yum install ruby yum install compat-readline5 yum install ruby-libs]

 

 

 

rpm -i ruby-augeas-0.4.1-3.el6.x86_64.rpm

rpm -i rubygem-json-1.5.5-3.el6.x86_64.rpm

rpm -i hiera-1.3.4-1.el6.noarch.rpm

 

rpm -i facter-1.7.0-1.el6.x86_64.rpm

rpm -i libselinux-ruby-2.0.94-5.8.el6.x86_64.rpm

rpm -i ruby-shadow-2.2.0-2.el6.x86_64.rpm

 
How to Create a PXE Installation Image for Oracle VM
https://docs.oracle.com/cd/E20815_01/html/E20821/gkang.html

http://www.golinuxhub.com/2014/08/how-to-configure-pxe-boot-server-in.html

   17  puppet

   18  history



