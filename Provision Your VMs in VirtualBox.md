
In this section, the most important topic is to understand the Guest Vm Networking. There are many different ways to configure the VMs network.

My requirement is:

- From my laptop, I should be able to ssh to the VMs
- The VMs should be able to access internet.

For my requirement I choosed:
- Adapter 1 -> Host-only Adapter
- Adapter 2 -> NAT

Read this article to understand Networking on Oracle Virtualbox
https://technology.amis.nl/2014/01/27/a-short-guide-to-networking-in-virtual-box-with-oracle-linux-inside/

How to make virtualbox guest use its host’s internet connection and still have ssh access to the guest 
http://www.mycodingpains.com/how-to-make-virtualbox-guest-use-its-hosts-internet-connection-and-still-have-ssh-access-to-the-guest/
