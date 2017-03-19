Please complete the following article before proceeding <br>
https://github.com/parvezhussain/kickstart/blob/master/Getting%20The%20Laptop%20Ready.md <br>
https://github.com/parvezhussain/kickstart/blob/master/Provision%20Your%20VMs.md

OS: CentOS 6.8

We will use 2 different ways to install OS.
- From Local DVD
- From Kickstart Server

## OPTION A: HOWTO Configure VM to boot/install from local DVD

Select the VM from Navigation Panel. Click 'Settings' Select 'Storage' from Navigation Panel <br>
(From middle Panel) Select 'Storage Tree' -> Controller: IDE -> Empty <br>
(From right panel) Click on the (disk) and provide the path to CentOS-6.8-x86_64-bin-DVD1.iso that was downloaded <br>
Click OK <br>
Click 'Start' to start the VM. <br>


## OPTION B: HOWTO Configure VM to boot/install from kickstart server <br>

Make sure the Kickstart server is working fine. <br>
We will learn how to setup Kickstart server in the later part of this document <br> <br>
Select the VM from Navigation Panel. Click 'Settings' <br>
Select 'System' from Navigation Panel <br>
Under Motherboard, checkbox Network and move it to the top of the list <br>
Select 'Network'. Under 'Adapter1 Setting' expand 'Advanced'. Note the MAC address. <br>
Click OK <br>

Login to Kickstart server.
Edit /etc/dhcp/dhcpd.conf
Add the Lines:

host PXEClient1 {
     hardware ethernet 08:00:27:C1:B6:01;
     fixed-address 192.168.1.6;
     filename "pxelinux.0";
     option host-name "peserver.localhost.com";
}

service dhcpd restart

======================================== <br>

## Install OS from local DVD

    Create the VM
    From network Configuration Use OPTION 1 or 2
    use OPTION A to boot/install from local DVD

From Navigation Panel, select 'pxeserver' and click 'Start'
Centos will start installation.
Except the below settings, select all default
hostname: pxeserver.localhost.com
Server type: minimal

The pxeserver vm will automatically reboot.

========================================
Install OS from Kickstart Server (Network Install)

    Create the VM
    From network Configuration Use OPTION 1 or 2
    use HOWTO Configure VM to boot/install from kickstart server

From Navigation Panel, select 'pxeserver' and click 'Start'
DHCP will try to connect to the kickstart server.
Server installation will start
The pxeserver vm will automatically reboot.

========================================
POST INSTALL Network Config

Login to the VM through the console

Post Linux Install:

If the VM has eth1 and eth2
Edit ifcfg-eth1, ifcfg-eth2:
onboot=yes

edit ifcfg-eth0
IPADDR=192.168.1.1
bootproto=static
onboot=yes

service network restart

ifconfig

Verify the network settings:
Note the IP address of eth1 (host-only adapter) ex:192.168.56.101

Now open putty connect to pxeserver using 192.168.56.101
if you are successful, Congratulation!! you are able to connect to the pxe server (inbound).

Now test the outbound connection.
From pxe server, ping www.google.com
You should see response. Congratulation!! your outbound connection is working. 
