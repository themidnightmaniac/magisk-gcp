#!/system/bin/sh

MODDIR=${0%/*}

# Switch to the non-tracking graphene os supl provider
SUPL_HOST=supl.grapheneos.org
# Ensure the supl port as some devices wont set it by default
SUPL_PORT=7275
# Use the global pool.ntp.org to get the closest ntp server available
# See https://www.ntppool.org/zone/@
NTP_SERVER=pool.ntp.org

if [ -f /system/vendor/etc/gps.conf ]; then
  CONF_FILE="/system/vendor/etc/gps.conf";
elif [ -f /system/etc/gps.conf ]; then
  CONF_FILE="/system/etc/gps.conf";
elif [ -f /system/etc/gps_debug.conf ]; then
  CONF_FILE="/system/etc/gps_debug.conf";
else exit 1; fi

mkdir -p "${MODDIR}/$(dirname "${CONF_FILE}")" && touch "${CONF_FILE}";

if [ -f "${CONF_FILE}" ]; then
  NEW_CONF="${MODDIR}/${CONF_FILE}";
  cp "${CONF_FILE}" "${NEW_CONF}";
else exit 1; fi

# Replace host
if grep -q "^SUPL_HOST.*=.*" "${CONF_FILE}"; then
  sed -i "s/^SUPL_HOST.*=.*/SUPL_HOST = ${SUPL_HOST}/" "${NEW_CONF}";
else # Append if not present
  echo "SUPL_HOST = ${SUPL_HOST}" >> "${NEW_CONF}";
fi

# Replace port
if grep -q "^SUPL_PORT.*=.*" "${CONF_FILE}"; then
  sed -i "s/^SUPL_PORT.*=.*/SUPL_PORT = ${SUPL_PORT}/" "${NEW_CONF}";
else # Append if not present
  echo "SUPL_PORT = ${SUPL_PORT}" >> "${NEW_CONF}";
fi

# Replace NTP pool
if grep -q "^NTP_SERVER.*=.*" "${CONF_FILE}"; then
	sed -i "s/^NTP_SERVER.*=.*/NTP_SERVER = ${NTP_SERVER}/" "${NEW_CONF}";
else # Append if not present
	echo "NTP_SERVER = ${NTP_SERVER}" >> "${NEW_CONF}"
fi

# Cleanup
if [ -z "$(ls -A "${MODDIR}/system/etc")" ]; then rmdir "${MODDIR}/system/etc"; fi
if [ -z "$(ls -A "${MODDIR}/system/vendor/etc")" ]; then rmdir "${MODDIR}/system/vendor/etc"; fi
if [ -z "$(ls -A "${MODDIR}/system")" ]; then rmdir "${MODDIR}/system"; fi
if [ -f "${MODDIR}/system/.gitkeep" ]; then rm "${MODDIR}/system/.gitkeep"; fi