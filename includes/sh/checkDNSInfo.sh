#!/bin/bash
#For DO support
#Add All popular 2 field TLDs
#Original by TylerCrandall - tyler@digitalocean.com
#Modified for JSON output and added records by Andrew Herrington - aherrington@digitalocean.com
#4-13-2014

scdoi=$(echo $1)

#VARIABLES
widomain=$scdoi
WHOIS=$(whois $widomain 2>/dev/null | tr -d '\r')
DOMAIN=$scdoi

AREC=(`host -t a "$scdoi" 2>/dev/null| grep -iw address | awk '{print$4}'`)
if [ -n "${AREC[0]}" ]; then
        RDNSREC=$(host ${AREC[0]} 2>/dev/null| sed -n '1p' | cut -d" " -f5 | sed 's/\.$//g')
fi
MXREC=$(host -t mx "$widomain" 2>/dev/null| grep -iw mail | sort | awk '{print $6" "$7}' | sed 's/\.$//g' | awk '{print $1,$2","}')
TXTREC=$(host -t txt "$widomain" 2>/dev/null | grep -i text |  awk '{a="";for (i=4;i<=NF;i++){a=a" "$i}print a}' | sed -n '1h;2,$H;${g;s/\n/,/g;p}' | sed "s/\"/'/g")

#A RECORD
ARECPRINT=""
if [ -z "${AREC[0]}" ]; then
        ARECPRINT="NONE"
else
        Alen=${#AREC[@]}
        if [ $Alen -gt 1 ]; then
                i=0
                while [ $i -lt $Alen ]
                do
                        ARECPRINT="$ARECPRINT,${AREC[$i]}"
                        ((i++))
                done
        else
                ARECPRINT=",${AREC[0]}"
        fi
fi
##

#RDNS RECORD
if [ -z "$RDNSREC" ]; then
        RDNSREC="EMPTY"
fi

#MX RECORD
if [ -z "$MXREC" ]; then
        MXREC="None"
fi
##

#NAME SERVERS
nameservers=$(host -t ns $widomain 2>/dev/null | grep -iw server | sort | awk '{print$4}' | sed 's/\.$//g' | awk '{print $1","}')


############################################
if [ -n "${AREC[0]}" ]; then
        webhost=$(whois -h riswhois.ripe.net ${AREC[0]} | grep -iv swisscom | grep -iw descr: | sed -n '1p' | awk '{print$2" "$3" "$4" "$5}')
        if [ -n "$webhost" ]; then
		##Do Nothing
		webhost=$webhost
	else
		webhost="NOT FOUND"
        fi
else
	wehbost="NOT FOUND"
fi
#############################################
echo { \"DNS\": { \"A\": \"${ARECPRINT#?}\", \"MX\": \"${MXREC%?}\", \"RDNS\":
echo \"$RDNSREC\", \"NS\": \"${nameservers%?}\", \"TXT\": \"$TXTREC\" },
echo \"Hosting\": \"$webhost\" }

exit 0
