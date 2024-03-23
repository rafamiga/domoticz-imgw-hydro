#!/bin/bash

SRCURL="https://hydro-back.imgw.pl/station/meteo/status?id="
DOMOURL="http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=%d&svalue=%.2f"
OUTFORMAT="%.2f"
#DEBUG="true"
DEBUG="false"

# nazwa  domoticz idx
OPAD_IDS=(
# Gdańsk-Świbno
354180155 59
# Wrocław-Strachowice
351160424 60
# Warszawa-Bielany
252200150 62
)
## j.w.
#252200150 61 )

AIDX=0
ALEN=${#OPAD_IDS[*]}

while [ ${AIDX} -lt ${ALEN} ]; do
    ST_ID=${OPAD_IDS[${AIDX}]}
    AIDX=$((AIDX+1))
    DOMOIDX=${OPAD_IDS[${AIDX}]}
    AIDX=$((AIDX+1))
    eval "${DEBUG}" && echo "ST_ID=${ST_ID} Domoticz IDX=${DOMOIDX}"

    TMP=$(mktemp)
# stara wersja sprzed 2024-03
#    STAN=$(jq -r -c '.hourlyPrecipRecords | sort_by(.date) | .[-1] | .value' ${TMP}) 
#    echo $(printf "${DOMOURL}" ${OPAD_IDX[S]} ${STAN})

    wget -q "${SRCURL}${ST_ID}" -O ${TMP}

#    cat ${TMP} | jq
#    STAN=$(cat ${TMP} | jq '10 * .status.precip.value') # ustawić dzielnik 10
    STAN=$(cat ${TMP} | jq '.status.precip.value')

    PAYLOAD=$(printf "${DOMOURL}" ${DOMOIDX} ${STAN})
    eval "${DEBUG}" && echo "${PAYLOAD}"
    curl -s "${PAYLOAD}" > /dev/null

    rm "${TMP}"
done

