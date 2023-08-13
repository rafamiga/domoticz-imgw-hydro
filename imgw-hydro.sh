#!/bin/bash

SRCURL="https://danepubliczne.imgw.pl/api/data/hydro/"
DOMOURL="http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=%d&svalue=%d"

# 154180210 - Wisła ujście - 54
# 152210170 - Wisła bulwary - 55
# 154180170 - Motława Wiślina - 57
# 150190340 - Wisła Kraków-Bielany - 56
# 151160170 - Odra Brzeg Dolny - 58
# 152200110 - Wisła Moddlin - 63

ST_ID=(154180210 152210170 154180170 150190340 151160170 152200110)
DOMO_IDX=(54 55 57 56 58 63) # domoticz index

TMP=$(mktemp)

wget -q -O ${TMP} ${SRCURL}

for ST in ${!ST_ID[@]}; do
    STAN=$(jq --arg st_id "${ST_ID[ST]}" -r -c '.[] | select (.id_stacji == $st_id) | .stan_wody' ${TMP}) 
    # echo $(printf "${DOMOURL}" ${DOMO_IDX[ST]} ${STAN}) > /dev/null
    curl -s $(printf "${DOMOURL}" ${DOMO_IDX[ST]} ${STAN}) > /dev/null
done

rm ${TMP}
