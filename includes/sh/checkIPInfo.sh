#!/bin/bash
#For DO support
#Add All popular 2 field TLDs
#Original by TylerCrandall - tyler@digitalocean.com
#Modified for JSON output and added records by Andrew Herrington - aherrington@digitalocean.com
#4-13-2014

    scdoi=$1

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

echo {\"IP\": \"$scdoi\",
echo \"RDNS\": \"$RDNSREC\",
echo \"WEBHOST\": \"$webhost\"
echo }

exit 0
