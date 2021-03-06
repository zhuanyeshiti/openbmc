FILESEXTRAPATHS_prepend_hs2500 := "${THISDIR}/${PN}:"

EXTRA_OECONF_append_hs2500 = " --enable-negative-errno-on-fail"

CHIPS = " \
        bus@1e78a000/i2c-bus@400/tmp75@48 \
        bus@1e78a000/i2c-bus@340/tmp75@4a \
        bus@1e78a000/i2c-bus@3c0/ina219@40 \
        bus@1e78a000/i2c-bus@3c0/ina219@41 \
        pwm-tacho-controller@1e786000 \
        "
ITEMSFMT = "ahb/apb/{0}.conf"

ITEMS = "${@compose_list(d, 'ITEMSFMT', 'CHIPS')}"

ITEMS += "iio-hwmon-1_8v.conf \
         iio-hwmon-1_7v.conf \
         iio-hwmon-1_1v.conf \
         iio-hwmon-0_825v.conf \
         iio-hwmon-adc4.conf \
         iio-hwmon-adc5.conf \
         iio-hwmon-adc6.conf \
         iio-hwmon-adc7.conf \
         "

ENVS = "obmc/hwmon/{0}"
SYSTEMD_ENVIRONMENT_FILE_${PN}_append_hs2500 = " ${@compose_list(d, 'ENVS', 'ITEMS')}"

# INTEL PECI sensors
PECINAMES = " \
        0-30/peci-cputemp.0 \
        0-31/peci-cputemp.1 \
        "
PECIITEMSFMT = "devices/platform/ahb/ahb--apb/ahb--apb--bus@1e78b000/1e78b000.peci-bus/peci-0/{0}.conf"
PECIITEMS = "${@compose_list(d, 'PECIITEMSFMT', 'PECINAMES')}"
PECIENVS = "obmc/hwmon/{0}"
SYSTEMD_ENVIRONMENT_FILE_${PN}_append_hs2500 = " ${@compose_list(d, 'PECIENVS', 'PECIITEMS')}"
