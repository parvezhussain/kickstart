
Please complete the following link before proceeding <br>
https://github.com/parvezhussain/kickstart/blob/master/Getting%20The%20Laptop%20Ready.md


## Provision the VMs.

Example:<br>
pxeserver <- Kickstart/pxe Server <br>
peserver <- PuppetMaster Server<br>
peclient1 <- puppet client<br>


Open Oracle VirtualBox(VB). Select 'New'<br>
    Name:pxeserver<br>
    Type:Linux<br>
    Version: Redhat (64-bit)<br>
Click 'Next'<br>
    Memory Size: 1024MB<br>
Click 'Next'<br>
Hard Disk. Choose the default.Click 'Create'<br>
Hard Disk Type. Choose default, Click 'Next'<br>
Storage on physical drive. Dynamically allocated. Click 'Next'<br>

File Location: pxeserver<br>
File size: 15GB. Click 'Create'<br>

Repeat the same for 'peserver' and 'peclient1'<br>

