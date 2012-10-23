#!/sbin/sh

# charge_flag is 1 for charge mode and 0 for recovery.
cat /proc/app_info | grep -A1 "charge_flag:" | grep -q "1"
recovery=$?

# Don't start recovery if we're in charge mode. Turn off soft keys light.
if [ $recovery == 0 ] ; then
 echo 0 > /sys/class/leds/button-backlight/brightness
 exit 0
fi

# Turn on soft keys light for recovery mode.
echo 255 > /sys/class/leds/button-backlight/brightness

# We haven't exited, start recovery.
/sbin/recovery
