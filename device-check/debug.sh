#!/bin/bash

avahi-daemon --daemonize --no-drop-root
DIAGNOSTICS_URL="https://raw.githubusercontent.com/balena-io-modules/device-diagnostics/master/scripts/"
DIAGNOSTICS_SCRIPTS=("diagnose.sh" "checks.sh")
NOW=$(date +"%Y-%m-%d-%H-%M")
echo "[INFO] Logging into $API_ENV"
export BALENARC_BALENA_URL=${API_ENV}

balena login --token "${BALENA_TOKEN}"
balena support enable --device ${DEVICE_UUID}

# Currently fails for some reason, might be length related
# echo ${SSH_KEY} > ~/.ssh/id_rsa
mkdir -p /root/.ssh/ && cp ./id_rsa_testing /root/.ssh/id_rsa
eval `ssh-agent -s`
ssh-add
mkdir -p logs

pushd /usr/src/local-device-debugger/logs/
/usr/src/local-device-debugger/microServer.py &
popd

HOSTNAME="${DEVICE_UUID:0:7}.local"
DEVICE_IP=$(avahi-resolve-host-name ${HOSTNAME} -4 | awk '{ print $2 }')

for script in ${DIAGNOSTICS_SCRIPTS[@]}; do
    curr_script=$(echo ${script} | cut -f1 -d'.')
    DIAGNOSTICS_LOG="device_${curr_script}_${DEVICE_UUID}_${NOW}.log"
    echo "[INFO] Will run ${curr_script} on local device ${DEVICE_UUID} - ${DEVICE_IP}. This may take a few minutes."
    echo "wget ${DIAGNOSTICS_URL}${script} -O /tmp/${script} && bash /tmp/${script}" | balena ssh ${DEVICE_IP} > ./logs/${DIAGNOSTICS_LOG}
    echo "Finished running ${curr_script} on device ${DEVICE_UUID}. Log file saved in logs/${DIAGNOSTICS_LOG}"
done

echo "[INFO] Enable public device url and navigate to this device's URL to inspect the log files"

while true; do
    sleep 1
done
