#!/bin/bash

SRCURL="https://hydro-back.imgw.pl/station/meteo/status?id="
DOMOURL="http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=%d&svalue=%f"

OPAD_IDS=(
# Gdańsk-Świbno
354180155
# Wrocław-Strachowice
351160424
# Warszawa-Bielany
252200150
# j.w.
252200150 )

#         v--v--v------- counter
OPAD_IDX=(59 60 61 62) # domoticz index
#                  ^---- counter incremental

for ST in ${!OPAD_IDS[@]}; do
    ST_ID=${OPAD_IDS[${ST}]}
    TMP=$(mktemp)

# stara wersja sprzed 2024-03
#    STAN=$(jq -r -c '.hourlyPrecipRecords | sort_by(.date) | .[-1] | .value' ${TMP}) 
#    echo $(printf "${DOMOURL}" ${OPAD_IDX[S]} ${STAN})

    wget -q "${SRCURL}${ST_ID}" -O ${TMP}

#    cat ${TMP} | jq
    STAN=$(cat ${TMP} | jq '.status.precip.value')
    curl -s $(printf "${DOMOURL}" ${OPAD_IDX[ST]} ${STAN}) > /dev/null

    rm "${TMP}"
done

