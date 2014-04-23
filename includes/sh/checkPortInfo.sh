#!/bin/bash
#For DO support
#Add All popular 2 field TLDs
#Original by TylerCrandall - tyler@digitalocean.com
#Modified for JSON output and added records by Andrew Herrington - aherrington@digitalocean.com
#4-13-2014

scdoi=$(echo $1)

AREC=(`host -t a "$scdoi" 2>/dev/null| grep -iw address | awk '{print$4}'`)
if [ -n "${AREC[0]}" ]; then
        RDNSREC=$(host ${AREC[0]} 2>/dev/null| sed -n '1p' | cut -d" " -f5 | sed 's/\.$//g')
fi
#PORTS
if [ -n "${AREC[0]}" ]; then
        PORTS=$(nmap -P0 -p 21,22,25,26,53,80,110,143,443,465,587,993,995,2082,2086,3306, "$scdoi" 2>/dev/null | grep -i tcp | grep -i open | awk '{print$1,$2","}')
        if [ -z "$PORTS" ]; then
                PORTS="NONE "
        fi
else
        PORTS="NONE "
fi
##
echo { \"Open Ports\": \"${PORTS%?}\"}
#echo \"Open Ports\": \"${PORTS%?}\"
exit 0
