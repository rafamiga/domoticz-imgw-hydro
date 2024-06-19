#!/bin/bash

# (c) 2024 rafamiga+git@fastmail.com
# Licencja: GPLv3
# 2024-06-19 -- added direct call

SRCURL="https://danepubliczne.imgw.pl/api/data/hydro/"
SRCDIRECT="https://hydro-back.imgw.pl/station/hydro/status?id=%d"
DOMOURL="http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=%d&svalue=%d"

# 154180210 - Wisła ujście - 54
# 152210170 - Wisła bulwary - 55
# 154180170 - Motława Wiślina - 57
# 150190340 - Wisła Kraków-Bielany - 56
# 151160170 - Odra Brzeg Dolny - 58 -- direct
# 152200110 - Wisła Moddlin - 63
# 151170030 - Odra Trestno - 64


ST_ID=(154180210 152210170 154180170 150190340 151160170 152200110:direct 151170030)
DOMO_IDX=(54 55 57 56 58 63 64) # domoticz index

TMP=$(mktemp)

wget -q -O ${TMP} ${SRCURL}

for ST in ${!ST_ID[@]}; do
    STID="${ST_ID[ST]}"	 
    if [[ ${STID} =~ :direct ]]; then
	STID="${STID%:*}"
	URL_DIRECT=$(printf "${SRCDIRECT}" ${STID})
	# echo ${URL_DIRECT}
	STAN=$(curl -s ${URL_DIRECT} | jq '.status.currentState.value')
    else
	STAN=$(jq --arg st_id "${STID}" -r -c '.[] | select (.id_stacji == $st_id) | .stan_wody' ${TMP}) 
    fi

    if [ "${STAN}" == "null" ]; then
    	STAN=-1
    fi
    # echo $(printf "${DOMOURL}" ${DOMO_IDX[ST]} ${STAN}) > /dev/null
    curl -s $(printf "${DOMOURL}" ${DOMO_IDX[ST]} ${STAN}) > /dev/null
done

rm ${TMP}
