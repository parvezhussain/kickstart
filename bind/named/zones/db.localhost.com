$TTL	604800
@       IN      SOA     bind.localhost.com. admin.localhost.com. (
              3         ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
             604800 )   ; Negative Cache TTL

; name servers - NS records
	IN 	NS	bind.localhost.com.


bind.localhost.com.		IN	A 	192.168.56.100
pxeserver.localhost.com.	IN	A 	192.168.56.10
peserver.localhost.com.		IN	A 	192.168.56.11
peclient1.localhost.com.	IN	A 	192.168.56.20
