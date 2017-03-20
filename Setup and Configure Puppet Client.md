
### PUPPET CLIENT

SERVERNAME = peclient1.localhost.com

# Follow Steps:
-  Install OS from Kickstart Server (Network Install)
      * Select 'Install 6.8'
- POST INSTALL Network Config

Open peclient1 on putty session

ifconfig<br>


### Configure puppet client to connect to puppet master

The kickstart process has already configured most of the steps below. <br>
In case it does not work, verify the below steps. <br>

Edit /etc/hosts and add

    192.168.56.20  peclient1.localhost.com
    192.168.56.11 peserver.localhost.com
    192.168.56.10 pxeserver.localhost.com

Test the connectivity (important for puppet to work)

    ping peserver.localhost.com
    ping www.google.com
    ping pxeserver.localhost.com

Open crontab and add the line 
             
      * * * * * /usr/bin/puppet agent -tv >> /tmp/puppet.out

Run 'puppet agent -tv'

You should see someoutput if not then puppet node is not configured correctly <br>
(Check /etc/hosts file  and /etc/puppet/puppet.conf file for puppetmaster server)

Login to peserver using putty<br>
puppet cert list<br>

    [root@peserver opt]# puppet cert list
    "peclient1.localhost.com" (SHA256) 05:D2:EB:2D:07:10:61:8F:2A:8C:E4:14:A7:20:17:DD:48:F5:51:FB:08:40:0B:F3:13:4E:C4:F5:55:44:D9:FA
    [root@peserver opt]#


Sign the node agent certificate

    puppet cert sign peclient1.localhost.com

Your puppet node is configured and connected to puppet master. <BR>

================================================= <br>

YOUR ENVIRONMENT IS READY TO LEARN PUPPET OR ANY OTHER TOOLS

######## END###############################

