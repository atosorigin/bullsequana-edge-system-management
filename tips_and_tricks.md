zabbix
to test response time:
Associate a "Template ICMP Module ping" Template to a BMC
Create an item
- SimpleCheck
- icmppingsec[{$OPENBMC},3,1000,68,50,avg]
- s 
- Numeric float

test
fping <ip> -i 500 -p 1000 -r 3 -b 68 -s
