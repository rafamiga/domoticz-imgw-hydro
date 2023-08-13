#!/bin/bash

SRCURL="https://danepubliczne.imgw.pl/api/data/hydro/"
DOMOURL="http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=%d&svalue=%f"

#         W-wa IMGW Gda P Płn Wro lotn
#OPAD_IDS=(252200150 254180260 351160424 252200150 252200150)
OPAD_IDS=(254180260 351160424 252200150 252200150)
#               v--- counter
OPAD_IDX=(59 60 61 62) # domoticz index
#                  ^--- counter incremental

for ST in ${!OPAD_IDS[@]}; do
    ST_ID=${OPAD_IDS[${ST}]}
    TMP=$(mktemp)

    wget -q "https://hydro.imgw.pl/api/station/meteo/?id=${ST_ID}" -O ${TMP}
    STAN=$(jq -r -c '.hourlyPrecipRecords | sort_by(.date) | .[-1] | .value' ${TMP}) 
#    echo $(printf "${DOMOURL}" ${OPAD_IDX[S]} ${STAN})
    curl -s $(printf "${DOMOURL}" ${OPAD_IDX[ST]} ${STAN}) > /dev/null
    rm "${TMP}"
done

