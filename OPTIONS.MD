# Options

### These are the options applied to gps.conf by this module and their descriptions

- **NTP_SERVER = pool.ntp.org**

This will address will resolve to the ip of the closest ntp server. NTP is used to ensure that the time reported by the GPS satellites is acuratelly synchronized. Read [here](https://www.ntppool.org/zone/@) for more info.

- **SUPL_SERVER = supl.grapheneos.org**

Uses EFF's privacy friendly [DNT](https://www.eff.org/dnt-policy).
SUPL (Secure User Plane Location), basically improves the time to first fix ([TTFF](https://en.wikipedia.org/wiki/Time_to_first_fix)) and is a crucial tool in [Assisted GPS](https://en.wikipedia.org/wiki/Assisted_GNSS).
By default android sends a bunch of unnecessary and dangerous data to the supl provider. Read [*How SUPL Reveals My Identity And Location To Google When I Use GPS*](https://blog.wirelessmoves.com/2014/08/supl-reveals-my-identity-and-location-to-google.html) for more info.

- **SUPL_PORT = 7275**

The port to the supl provider, duh.

- **AGPS_CONFIG_INJECT = 1**

Applies the options above.

- **SUPL_ES = 1**

Enable SUPL support for google's [ELS](https://www.android.com/safety/emergency-help/emergency-location-service/).

- **USE_EMERGENCY_PDN_FOR_EMERGENCY_SUPL = 0**

Uses the SUPL provider set above in ELS for enhanced privacy.

### [Go Back](https://github.com/themidnightmaniac/magisk-gcp)
