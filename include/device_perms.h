// Overload this file in your own device-specific config if you need
// non-standard property_perms and/or control_perms structs
//
// To avoid conflicts...
// if you redefine property_perms, #define PROPERTY_PERMS there
// if you redefine control_perms, #define CONTROL_PARMS there
//
// A typical file will look like:
//


#define PROPERTY_PERMS
#define CONTROL_PERMS

struct {
    const char *prefix;
    unsigned int uid;
    unsigned int gid;
} property_perms[] = {
    { "net.rmnet", AID_RADIO, 0 },
    { "net.gprs.", AID_RADIO, 0 },
    { "net.ppp", AID_RADIO, 0 },
    { "net.qmi", AID_RADIO, 0 },
    { "net.lte", AID_RADIO, 0 },
    { "net.cdma", AID_RADIO, 0 },
    { "ril.", AID_RADIO, 0 },
    { "gsm.", AID_RADIO, 0 },
    { "persist.radio", AID_RADIO, 0 },
    { "net.dns", AID_RADIO, 0 },
    { "sys.usb.config", AID_RADIO, 0 },
    { "net.", AID_SYSTEM, 0 },
    { "dev.", AID_SYSTEM, 0 },
    { "runtime.", AID_SYSTEM, 0 },
    { "hw.", AID_SYSTEM, 0 },
    { "sys.", AID_SYSTEM, 0 },
    { "service.", AID_SYSTEM, 0 },
    { "service.", AID_RADIO, 0 },
    { "wlan.", AID_SYSTEM, 0 },
    { "dhcp.", AID_SYSTEM, 0 },
    { "dhcp.", AID_DHCP, 0 },
    { "debug.", AID_SYSTEM, 0 },
    { "debug.", AID_SHELL, 0 },
    { "log.", AID_SHELL, 0 },
    { "service.adb.root", AID_SHELL, 0 },
    { "service.adb.tcp.port", AID_SHELL, 0 },
    { "persist.sys.", AID_SYSTEM, 0 },
    { "persist.service.", AID_SYSTEM, 0 },
    { "persist.service.", AID_RADIO, 0 },
    { "persist.security.",AID_SYSTEM, 0 },
    { "net.pdp0", AID_RADIO, AID_RADIO },
    { "net.pdp1", AID_RADIO, AID_RADIO },
    { "net.pdp2", AID_RADIO, AID_RADIO },
    { "net.pdp3", AID_RADIO, AID_RADIO },
    { "net.pdp4", AID_RADIO, AID_RADIO },
    { "net.vsnet0", AID_RADIO, AID_RADIO },
    { "net.vsnet1", AID_RADIO, AID_RADIO },
    { "net.vsnet2", AID_RADIO, AID_RADIO },
    { "net.vsnet3", AID_RADIO, AID_RADIO },
    { NULL, 0, 0 }
};

struct {
const char *service;
unsigned int uid;
unsigned int gid;
} control_perms[] = {
// The default perms
{ "dumpstate",AID_SHELL, AID_LOG },
{ "ril-daemon",AID_RADIO, AID_RADIO },
// My magic device perms
{ "rawip_vsnet1",AID_RADIO, AID_RADIO },
{ "rawip_vsnet2",AID_RADIO, AID_RADIO },
{ "rawip_vsnet3",AID_RADIO, AID_RADIO },
{ "rawip_vsnet4",AID_RADIO, AID_RADIO },
{NULL, 0, 0 }
};

