TODO
====

1. Test building cfg80211 in to the kernel instead of as a module.
- If this succeeds, a regular wpa_supplicant method should suffice.
- If not, a method of insmodding the cfg80211.ko module needs to be found for boot up.
-- cfg80211 does not control Wi-Fi. It only adds Wi-Fi functionality to the kernel that is required for dhd_4330.ko.
-- Without the module inserted, missing symbols are reported in dmesg when the Wi-Fi attempts to initialise. (Obviously these are added by cfg80211 as suggested by their names.)

2. Fix wpa_supplicant - kernel is now totally satisfied with the Wi-Fi, this is purely an Android issue:

D/WifiService(  318): setWifiEnabled: true pid=587, uid=1000
E/SoftapController(  114): SIOCGIPRIV failed: -1
E/SoftapController(  114): Softap fwReload - failed: -1
E/WifiStateMachine(  318): Failed to reload STA firmware java.lang.IllegalStateException: command '5 softap fwreload eth0 STA' failed with '400 5 Softap operation failed (Operation not supported on transport endpoint)'
D/CommandListener(  114): Setting iface cfg
D/CommandListener(  114): Trying to bring down eth0
E/WifiHW  (  318): Unable to open connection to supplicant on "eth0": No such file or directory
I/wpa_supplicant( 1096): rfkill: Cannot open RFKILL control device
E/WifiHW  (  318): Unable to open connection to supplicant on "eth0": No such file or directory
I/wpa_supplicant( 1094): ioctl[SIOCSIWMODE]: Operation not supported on transport endpoint
I/wpa_supplicant( 1094): ioctl[SIOCGIWRANGE]: Operation not supported on transport endpoint
I/wpa_supplicant( 1094): ioctl[SIOCGIWMODE]: Operation not supported on transport endpoint
I/wpa_supplicant( 1094): ioctl[SIOCSIWAP]: Operation not supported on transportendpoint
I/wpa_supplicant( 1094): ioctl[SIOCSIWENCODEEXT]: Operation not supported on transport endpoint
I/wpa_supplicant( 1094): ioctl[SIOCSIWENCODE]: Operation not supported on transport endpoint
I/wpa_supplicant( 1094): ioctl[SIOCSIWENCODEEXT]: Operation not supported on transport endpoint
I/wpa_supplicant( 1094): ioctl[SIOCSIWENCODE]: Operation not supported on transport endpoint
I/wpa_supplicant( 1094): ioctl[SIOCSIWENCODEEXT]: Operation not supported on transport endpoint
I/wpa_supplicant( 1094): ioctl[SIOCSIWENCODE]: Operation not supported on transport endpoint
I/wpa_supplicant( 1094): ioctl[SIOCSIWENCODEEXT]: Operation not supported on transport endpoint
I/wpa_supplicant( 1094): ioctl[SIOCSIWENCODE]: Operation not supported on transport endpoint
I/wpa_supplicant( 1094): mkdir[ctrl_interface]: Read-only file system
E/wpa_supplicant( 1096): Failed to initialize control interface 'eth0'.
E/wpa_supplicant( 1096): You may have another wpa_supplicant process already running or the file was
E/wpa_supplicant( 1096): left by an unclean termination of wpa_supplicant in which case you will need
E/wpa_supplicant( 1096): to manually remove this file before starting wpa_supplicant again.
I/wpa_supplicant( 1094): ioctl[SIOCGIWMODE]: Operation not supported on transport endpoint
I/wpa_supplicant( 1094): ioctl[SIOCSIWAP]: Operation not supported on transportendpoint
I/logwrapper( 1094): /system/bin/wpa_supplicant terminated by exit(255)
E/WifiHW  (  318): Supplicant not running, cannot connect
E/WifiHW  (  318): Supplicant not running, cannot connect
E/WifiHW  (  318): Supplicant not running, cannot connect
E/WifiHW  (  318): Supplicant not running, cannot connect
E/WifiStateMachine(  318): Failed to setup control channel, restart supplicant
