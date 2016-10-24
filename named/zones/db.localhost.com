$TTL	604800
@       IN      SOA     pxelinux.localhost.com. localhost.com. (
              20         ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
             604800 )   ; Negative Cache TTL

; name servers - NS records
@	IN 	NS	pxelinux

localhost.com.	IN	MX	10	mail.localhost.com.

pxelinux	IN	A 	192.168.1.1
pemaster	IN      A       192.168.1.5
jbcclltdpc1000	IN      A       192.168.1.10
jbcclltdpc1001	IN      A       192.168.1.11
jbcclltdpc1002	IN      A       192.168.1.12
jbccllwcic1000	IN      A       192.168.1.20
jbccllcuic1000	IN      A       192.168.1.30
jbccllpupc610	IN      A       192.168.1.100

