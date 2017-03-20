Complete the following before proceeding <br>
----------------------------------------------------------------- <br>
Getting The Laptop Ready <br>
https://github.com/parvezhussain/kickstart/blob/master/Getting%20The%20Laptop%20Ready.md <br>
Provision Your VMs <br>
https://github.com/parvezhussain/kickstart/blob/master/VirtualBox%20-%20Provision%20Your%20VMs.md <br> 
Network Setup on VMs VirtualBox <br>
https://github.com/parvezhussain/kickstart/blob/master/VirtualBox%20-%20Setup%20Network%20Cards%20on%20VMs.md <br>
Install OS - OPTION A: Install from local DVD <br>
https://github.com/parvezhussain/kickstart/blob/master/Install%20OS.md <br>
Post Install Network Configuration <br>
https://github.com/parvezhussain/kickstart/blob/master/Configuring%20Network.md <br>
----------------------------------------------------------------- <br>

#### ##############Reference article############################

https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-centos-7

#############################################################

yum install bind bind-utils

mkdir /opt/git 
git clone https://(your_github_id)@github.com/parvezhussain/kickstart.git /opt/git

cd /opt/git/bind

Update named.conf
perl -pi -e 's/ 192.168.1.1/<your_bindserver-ip>/g' named.conf
perl -pi -e 's/ 192.168.1/<your_bindserver-ip_first_3_octat>/g' named.conf

Edit  /etc/named.conf and check

cd /opt/git/bind/named
Update named.conf.local and check the file

cd /opt/git/bind/named/zones
Check the files

Copy the files 

Cd /opt/git/bind
rsync -avxz * /etc

service named restart


On the client
Edit /etc/restolv.comf
domain localhost.com
nameserver <bind ip address>

test
nslookup <any server>

