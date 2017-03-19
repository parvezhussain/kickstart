

Let us provision the VMs.

Example:
pxeserver <- Kickstart/pxe Server
peserver <- PuppetMaster Server
peclient1 <- puppet client


Open Oracle VirtualBox(VB). Select 'New'
    Name:pxeserver
    Type:Linux
    Version: Redhat (64-bit)
Click 'Next'
    Memory Size: 1024MB
Click 'Next'
Hard Disk. Choose the default.Click 'Create'
Hard Disk Type. Choose default, Click 'Next'
Storage on physical drive. Dynamically allocated. Click 'Next'

File Location: pxeserver
File size: 15GB. Click 'Create'

Repeat the same for 'peserver' and 'peclient1'


## Configuring the Network

The most important topic is to understand the Guest VM Networking. There are many different ways to configure the VMs network.

My requirement is:

- From my laptop, I should be able to ssh to the VMs
- The VMs should be able to access internet.

For my requirement I will choose:
- Adapter 1 -> Host-only Adapter
- Adapter 2 -> NAT

Read this article to understand Networking on Oracle Virtualbox
https://technology.amis.nl/2014/01/27/a-short-guide-to-networking-in-virtual-box-with-oracle-linux-inside/

How to make virtualbox guest use its host’s internet connection and still have ssh access to the guest 
http://www.mycodingpains.com/how-to-make-virtualbox-guest-use-its-hosts-internet-connection-and-still-have-ssh-access-to-the-guest/

Select the the guest VM 'pxeserver'. Select 'Settings'
Select 'Network' from navigation panel.
Adaptor 1
'Enable Network Adapter' checked box. Attached to: Host-Only Adapter
Adaptor 2
'Enable Network Adapter' checked box. Attached to: NAT
Click 'OK'

Repeat the same for 'peserver' and 'peclient1





