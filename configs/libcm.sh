#!/system/bin/sh

# Determined by arch/arm/mach-msm/hardware_self_adapt.c
cat /proc/app_info | grep -A1 "framebuffer_boosted:" | grep -q "1"
boosted=$?

mount -o remount,rw /system

if [ -f /system/lib/libcm.so ]; then
 rm /system/lib/libcm.so
fi

# Link the correct libcm.so to /system/lib/libcm.so depending on framebuffer memory
# (which can be used to determine the baseband early on).
if [ $boosted == 0 ]; then
 ln -s /system/lib/109808/libcm.so /system/lib/libcm.so
 mount -o remount,ro /system
 exit 0
fi

ln -s /system/lib/2030/libcm.so /system/lib/libcm.so
mount -o remount,ro /system
