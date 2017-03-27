$TTL	604800
@       IN      SOA     bind.localhost.com. admin.localhost.com. (
              3         ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
             604800 )   ; Negative Cache TTL

; name servers - NS records
	IN 	NS	bind.localhost.com.


bind.localhost.com.		IN	A 	192.168.1.100
pxeserver.localhost.com.	IN	A 	192.168.1.10
peserver.localhost.com.		IN	A 	192.168.1.11
peclient1.localhost.com.	IN	A 	192.168.1.20
peclient1.localhost.com.        IN      A       192.168.1.20
jbccllwcic1000.localhost.com.   IN      A       192.168.1.31
jbccllcuic1000.localhost.com.   IN      A       192.168.1.32
jbcclltdpc1000.localhost.com.   IN      A       192.168.1.33
jbccllkcic1000.localhost.com.   IN      A       192.168.1.34
