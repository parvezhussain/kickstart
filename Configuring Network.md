
Identifying the network the VM should use <br>
On the laptop command prompt, <br>
type 'ipconfig'<br>

You will see a new network created like below. (The IP address will vary)

      Ethernet adapter Ethernet 3:

      Connection-specific DNS Suffix  . :
      Link-local IPv6 Address . . . . . : fe80::b022:e867:40bc:e31c%33
      IPv4 Address. . . . . . . . . . . : 192.168.56.1
      Subnet Mask . . . . . . . . . . . : 255.255.255.0
      Default Gateway . . . . . . . . . :

So all your VMs network IPs should be 192.168.56.x

We will now configure the VM network for inbound and outbound traffic  

Inbound traffic i.e ability to ssh to vm, i.e Adapter 1 (Host-only adapter)  i.e ifcfg-eth0 <br>
Outbound traffic i.e from VM to internet access i.e Adaper 2 (NAT) i.e ifcfg-eth1

Login to the VM through console. 

Run 'ifconfig' <br>
You will see only the loopback network only

Edit /etc/sysconfig/network-scripts/ifcfg-eth0

Update/Add these lines:

      ONBOOT=yes
      BOOTPROTO=static
      IPADDR=192.168.56.10
      PEERDNS=no

Edit /etc/sysconfig/network-scripts/ifcfg-eth1

Update/Add these lines

      ONBOOT=yes

Restart Netwoork Service
      
      service network restart

Run 'ifconfig'

You will see eth0 and eth1 network started.

##### Test Connectivity

From your laptop, ssh to the server using the ipaddress 192.168.56.10. You should be able to login.

After you login to the VM though putty,  ping www.google.com . You should get ping response.

Congratulation!! Your VM is ready.

