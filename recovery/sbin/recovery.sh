#!/sbin/sh

# charge_flag is 1 for charge mode and 0 for recovery.
cat /proc/app_info | grep -A1 "charge_flag:" | grep -q "1"
recovery=$?

# Don't start recovery if we're in charge mode.
if [ $recovery == 0 ] ; then
 exit 0
fi

# We haven't exited, start recovery.
/sbin/recovery
