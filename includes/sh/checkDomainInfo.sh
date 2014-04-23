#!/bin/bash
#For DO support
#Add All popular 2 field TLDs
#Original by TylerCrandall - tyler@digitalocean.com
#Modified for JSON output and added records by Andrew Herrington - aherrington@digitalocean.com
#4-13-2014

#sanitycheck=$(echo $1 | sed 's/[A-Za-z0-9]//g' | sed 's/\.//g' | sed 's/\-//g')
#if [ -n $"$sanitycheck" ]; then
 #   scdoi=$(echo $1 | sed 's/\// /g' | awk '{print$2}')
#else
#    scdoi=$(echo $1)
#fi

    scdoi=$1

#VARIABLES
#widomain=$(echo "$scdoi" | sed 's/\./ /g' | awk '{print $(NF-1)"."$NF}' | tr '[:upper:]' '[:lower:]')
#if [ "$widomain" == "com.br" -o "$widomain" == "co.uk" -o "$widomain" == "org.uk" -o "$widomain" == "me.uk" -o "$widomain" == "com.au" ]; then
#    widomain=$(echo "$scdoi" | sed 's/\./ /g' | awk '{print $(NF-2)"."$(NF-1)"."$(NF-0)}')
#fi
widomain=$scdoi
WHOIS=$(whois $widomain 2>/dev/null | tr -d '\r')
DOMAIN=$scdoi

EXP=$(echo "$WHOIS" | grep -i expir |  grep '[0-9]' | sed -n '1p' | sed 's/^[^:]\+://g' | sed -e 's/^[ \t]*//' | sed '/^ *$/d')
REG=$(echo "$WHOIS" | grep -i registrar: | sed 's/^[^:]\+://g' | sed -e 's/^[ \t]*//' | sed '/^ *$/d')
if [ -z "$REG" ]; then
        REG=$(echo "$WHOIS" | grep -iwA 1 registrar: | sed -n '2p' | sed -e 's/^[ \t]*//' | sed '/^ *$/d')
        if [ -z "$REG" ]; then
                REG=$(echo "$WHOIS" | grep -iw '^source:' | sed 's/^[^:]\+://g' | sed -e 's/^[ \t]*//' | awk '{print$1" "$2}' | sed '/^ *$/d')
        fi
fi
#EXPIRATION DATE
if [ -z "$EXP" ]; then
	EXP="Unknown"
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


echo { \"Name\": \"$DOMAIN\", \"Expiration\": \"$EXP\", 
echo \"Registrar\": \"$REG\" }
exit 0
