#! /bin/bash
# Determine whether the log file exists.if exist, start fglam directly, if not, install fglam.
PREFIX=/opt/fglam/state/default/logs
if [ -d $PREFIX ]; then
  /opt/fglam/bin/fglam -s --auth-token ${AUTH_TOKEN}
else
  FMS_URL="${FMS_URL:-default_fms_url}"
  HOST_DISPLAY_NAME="${HOST_DISPLAY_NAME:-default_host_display_name}"
  AUTH_TOKEN="${AUTH_TOKEN:-default_auth_token}"
  eval "sed -i -r 's@installer.fms=url=https://.*:8443,ssl-allow-self-signed=true,ssl-cert-common-name=quest.com@installer.fms=url=https://$FMS_URL:8443,ssl-allow-self-signed=true,ssl-cert-common-name=quest.com@' /FglAM/installer.properties"
  eval "sed -i -r 's@installer.host-display-name=.*@installer.host-display-name=$HOST_DISPLAY_NAME@' /FglAM/installer.properties"
  eval "sed -i -r 's@installer.auth-token=.*@installer.auth-token=$AUTH_TOKEN@' /FglAM/installer.properties"
  /FglAM/FglAM-{version}-linux-x86_64.bin
fi

# Always output the latest log
while true
do
  LATEST_LOG=$(ls  $PREFIX|egrep FglAM.*\\.log|sort -r|head -n1)
  if [ "$LOG_FILE" == "$LATEST_LOG"  ]; then
    sleep 5
  else
    LOG_FILE=$LATEST_LOG
    pkill tail
    (tail -f $PREFIX/$LOG_FILE &)
  fi
done
