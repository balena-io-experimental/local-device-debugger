#!/bin/bash

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

# For local network devices that are offline in the API we need to use the device IP
DEVICE_IP=$(balena device ${DEVICE_UUID} | grep "IP ADDRESS" | cut -f2 -d":" | sed 's/^ *//' | sed 's/ *$//' | cut -f1 -d" ")

for script in ${DIAGNOSTICS_SCRIPTS[@]}; do
    curr_script=$(echo ${script} | cut -f1 -d'.')
    DIAGNOSTICS_LOG="device_${curr_script}_${DEVICE_UUID}_${NOW}.log"
    echo "[INFO] Will run ${curr_script} on local device ${DEVICE_UUID} - ${DEVICE_IP}. This may take a few minutes."
    echo "wget ${DIAGNOSTICS_URL}${script} -O /tmp/${script} && bash /tmp/${script}" | balena ssh ${DEVICE_IP} > ${DIAGNOSTICS_LOG}
    echo "Finished running ${curr_script} on device ${DEVICE_UUID}. Log file saved as ${DIAGNOSTICS_LOG}"
done

# Don't exit the process
while true; do
    sleep 1
done
