# magisk-gcp

### Gps dot Conf Patcher

This magisk module enhances the default gps.conf. ATM it changes the following settings:

- NTP_SERVER = pool.ntp.org
- SUPL_SERVER = supl.grapheneos.org
- CAPABILITIES = 0x36
- AGPS_CONFIG_INJECT = 1
- SUPL_ES=1
- USE_EMERGENCY_PDN_FOR_EMERGENCY_SUPL=0

This module was only tested on android 11, but should work on any device with android 8+.

The effects of each option is explained in [SETTINGS](SETTINGS.MD).

This module is a fork of [supl-replacer](https://github.com/Magisk-Modules-Alt-Repo/supl-replacer).

## Installation

Download magisk-gcp-vX.X.X.zip from the [latest release](https://github.com/themidnightmaniac/magisk-gcp/releases/latest) and flash it using [magisk](https://github.com/topjohnwu/Magisk). The new options will be applied after a reboot.