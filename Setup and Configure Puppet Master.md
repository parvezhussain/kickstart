### PUPPET SERVER

SERVERNAME = peserver.localhost.com

#### Follow Steps:
-  Install OS from Kickstart Server (Network Install)
      * Select 'Install 6.8 no puppet'
- POST INSTALL Network Config

#### Configure PUPPET-SERVER Install

yum install http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm -y

yum install puppet-server -y

vi /etc/puppet/puppet.conf

Add the line:

    # Where SSL certificates are kept.
    # The default value is '$confdir/ssl'.
    ssldir = $vardir/ssl
    alt_dns_names = peserver,peserver.localhost.com

/etc/init.d/iptables stop<br>
chkconfig | grep iptables<br>
chkconfig iptables off<br>
chkconfig | grep iptables<br>

service puppetmaster start

ps -ef | grep puppet<br>

chkconfig | grep puppetmaster<br>
chkconfig puppetmaster on<br>
chkconfig | grep puppetmaster<br>

## Get Puppet manifest from Git

yum install git -y

mkdir /opt/git
git clone https://(your_github_id)@github.com/parvezhussain/puppetrepo.git /opt/git

cd /etc
mv puppet puppet_orig
cp -pr /opt/git/puppet .
Edit puppet.conf
        
       ssldir = $vardir/ssl
       alt_dns_names = peserver,peserver.localhost.com

service puppetmaster restart

Edit /etc/hosts

    192.168.56.11 peserver.localhost.com
