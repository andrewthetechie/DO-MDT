#!/bin/bash
#For DO support
#Add All popular 2 field TLDs
#Original by TylerCrandall - tyler@digitalocean.com
#Modified for JSON output and added records by Andrew Herrington - aherrington@digitalocean.com
#4-13-2014

scdoi=$1

#PORTS

PORTS=$(nmap -P0 -p 21,22,25,26,53,80,110,143,443,465,587,993,995,2082,2086,3306, "$scdoi" 2>/dev/null | grep -i tcp | grep -i open | awk '{print$1,$2","}')

if [ -z "$PORTS" ]; then
	PORTS="NONE "
fi

echo { \"Open Ports\": \"${PORTS%?}\"}
exit 0
