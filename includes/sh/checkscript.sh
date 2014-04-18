#!/bin/bash
#For DO support
#Add All popular 2 field TLDs
#Original by TylerCrandall - tyler@digitalocean.com
#Modified for JSON output and added records by Andrew Herrington - aherrington@digitalocean.com
#4-13-2014

Version='V. 1.0.2'

if [ "$1" == "-u" ]; then
    if [ $2 -gt 699 2>/dev/null ] && [ $2 -lt 778 2>/dev/null ]; then
        Permission=$(echo "$2")
    else
        Permission='700'
    fi
    exit 0
fi

if [ -z "$1" ]; then
    exit 1
fi

sanitycheck=$(echo $1 | sed 's/[A-Za-z0-9]//g' | sed 's/\.//g' | sed 's/\-//g')
if [ -n $"$sanitycheck" ]; then
    scdoi=$(echo $1 | sed 's/\// /g' | awk '{print$2}')
else
    scdoi=$(echo $1)
fi

IsDomain=$(echo "$scdoi" | sed 's/\./ /g' | awk '{print$2}' | sed 's/[0-9]//g') #Verify a domain is the search string
if [ -z "$IsDomain" ]; then
    IsIP=$(echo "$scdoi" | sed 's/\./ /g' | awk '{print$4}' | sed 's/[A-Za-z]//g')
    if [ -z "$IsIP" ]; then
        exit 2
    else
        RDNSREC=$(host "$scdoi" 2>/dev/null| sed -n '1p' | cut -d" " -f5 | sed 's/\.$//g')
        if [ -z "$RDNSREC" ]; then
            RDNSREC="EMPTY"
        fi

        webhost=$(whois -h riswhois.ripe.net "$scdoi" | grep -iv swisscom | grep -iw descr: | sed -n '1p' | awk '{print$2" "$3" "$4" "$5}')
            if [ -n "$webhost" ]; then
		webhost=$webhost
            else
                    webhost="NOT FOUND"
            fi
        PORTS=$(nmap -P0 -p 21,22,25,26,53,80,110,143,465,587,993,995,2082,2086,3306, "$scdoi" 2>/dev/null | grep -i tcp | awk '{print$1,$2","}')
        if [ -z "$PORTS" ]; then
                PORTS="NONE "
        fi

echo {\"quickcheck\": {
echo \"IP Info\": {
echo \"IP\": \"$scdoi\",
echo \"RDNS\": \"$RDNSREC\",
echo \"WEBHOST\": \"$webhost\"
echo },
echo \"Open Ports\": \"${PORTS%?}\"
echo }}  


        exit 0
    fi
fi

#VARIABLES
widomain=$(echo "$scdoi" | sed 's/\./ /g' | awk '{print $(NF-1)"."$NF}' | tr '[:upper:]' '[:lower:]')
if [ "$widomain" == "com.br" -o "$widomain" == "co.uk" -o "$widomain" == "org.uk" -o "$widomain" == "me.uk" -o "$widomain" == "com.au" ]; then
    widomain=$(echo "$scdoi" | sed 's/\./ /g' | awk '{print $(NF-2)"."$(NF-1)"."$(NF-0)}')
fi
WHOIS=$(whois $widomain 2>/dev/null | tr -d '\r')
DOMAIN=$(echo "$scdoi" | tr a-z A-Z)
EXP=$(echo "$WHOIS" | grep -i expir |  grep '[0-9]' | sed -n '1p' | sed 's/^[^:]\+://g' | sed -e 's/^[ \t]*//' | sed '/^ *$/d')
REG=$(echo "$WHOIS" | grep -i registrar: | sed 's/^[^:]\+://g' | sed -e 's/^[ \t]*//' | sed '/^ *$/d')
if [ -z "$REG" ]; then
        REG=$(echo "$WHOIS" | grep -iwA 1 registrar: | sed -n '2p' | sed -e 's/^[ \t]*//' | sed '/^ *$/d')
        if [ -z "$REG" ]; then
                REG=$(echo "$WHOIS" | grep -iw '^source:' | sed 's/^[^:]\+://g' | sed -e 's/^[ \t]*//' | awk '{print$1" "$2}' | sed '/^ *$/d')
        fi
fi
AREC=(`host -t a "$scdoi" 2>/dev/null| grep -iw address | awk '{print$4}'`)
if [ -n "${AREC[0]}" ]; then
        RDNSREC=$(host ${AREC[0]} 2>/dev/null| sed -n '1p' | cut -d" " -f5 | sed 's/\.$//g')
fi
MXREC=$(host -t mx "$widomain" 2>/dev/null| grep -iw mail | sort | awk '{print $6" "$7}' | sed 's/\.$//g' | awk '{print $1,$2","}')

TXTREC=$(host -t txt "$widomain" 2>/dev/null | grep -i text |  awk '{a="";for (i=4;i<=NF;i++){a=a" "$i}print a}' | sed -n '1h;2,$H;${g;s/\n/,/g;p}')

#DOMAIN
##

#EXPIRATION DATE
if [ -z "$EXP" ]; then
	$EXP="Unknown"
fi
##

#REGISTRAR
if [ -n "$REG" ]; then
        REG=$REG
else
        REG=$(echo "$WHOIS" | grep -iw 'Registered through:' | sed 's/Registered through://g' | sed -e 's/^[ \t]*//' | sed '/^ *$/d')
        if [ -n "$REG" ]; then
                REG=$REG
        else
                REG=$(echo "$WHOIS" | grep -iw 'Registrar Name:' | sed 's/^[^:]\+://g' | sed -e 's/^[ \t]*//' | sed '/^ *$/d' | sed -n '1h;2,$H;${g;s/\n/,/g;p}')
                if [ -z "$REG" ]; then
                        REG=$(echo "$WHOIS" | grep -iw 'Registrar of Record:' | sed 's/^[^:]\+://g' | sed -e 's/^[ \t]*//' | sed '/^ *$/d' | sed -n '1h;2,$H;${g;s/\n/,/g;p}')
                        if [ -n "$REG" ]; then
				REG=$REG
                        else
                                REG="Not Found"
                        fi
                else
                        REG=$REG
                fi
        fi
fi
##

#A RECORD
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

#PORTS
if [ -n "${AREC[0]}" ]; then
        PORTS=$(nmap -P0 -p 21,22,25,26,53,80,110,143,465,587,993,995,2082,2086,3306, "$scdoi" 2>/dev/null | grep -i tcp | awk '{print$1,$2","}')
        if [ -z "$PORTS" ]; then
                PORTS="NONE "
        fi
else
        PORTS="NONE "
fi
##

echo {\"quickcheck\": {
echo \"Domain Info\": {
echo \"Name\": \"$DOMAIN\",
echo \"Expiration\": \"$EXP\",
echo \"Registrar\": \"$REG\"
echo },
echo \"DNS\": { 
echo \"A\": \"${ARECPRINT#?}\",
echo \"MX\": \"${MXREC%?}\",
echo \"RDNS\": \"$RDNSREC\",
echo \"NS\": \"${nameservers%?}\",
echo \"TXT\": \"$TXTREC\"
echo },
echo \"Hosting\": \"$webhost\",
echo \"Open Ports\": \"${PORTS%?}\"
echo }}  
exit 0
