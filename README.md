# local-device-debugger
Balena local device debugger

This can be run locally or pushed to a device running balenaOS that is located on the same network
with the device that is being debugged.

The following command was used for testing a device that has lost its VPN connection:

    systemctl stop openvpn && cp /bin/bash \`find /mnt/sysroot/active/ | grep "bin/openvpn"\`

Following device variables need to be defined for the test App:

    - API_ENV - Either 'balena-cloud.com' or 'balena-staging.com'

    - DEVICE_UUID - UUID of the device that is being debugged

    - BALENA_TOKEN - Access token used by balena cli to authenticate in the cloud.

After the application performs the checks on the sepecified balenaOS device, the resulting
logs are published on a local webserver. To inspect them, enable and navigate to the
PUBLIC DEVICE URL of the device running this app.

NOTE: The SSH_KEY used by balena-cloud is currently stored in the file 'id_rsa_testing'. This is
a workaround. Storing it in the device environment variables doesn't work as of now.
