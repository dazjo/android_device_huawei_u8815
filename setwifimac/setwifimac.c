/*
 * Copyright (C) 2012 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <stdio.h>
#include <string.h>
#include <cutils/properties.h>

/* In libhwrpc.so */
extern void huawei_oem_rapi_streaming_function(int n, int p1, int p2, int p3, int *v1, int *v2, char *v3);

static const char DRIVER_PROP_MAC_PARAM[] = "wlan.module.mac_param";

void SetMAC(void);

int main()
{
	SetMAC();
	return 0;
}

void SetMAC(void)
{
	char wlan_mac_arg[PROPERTY_VALUE_MAX] = "mac_param=00:90:4c:ce:43:30";
	char mac_bits[8];
	int y = 0;

	memset(mac_bits, 0, 8);

	/* Set Wi-Fi MAC address by loading it from radio. */
	huawei_oem_rapi_streaming_function(3, 0, 0, 0, 0, &y, mac_bits);

	sprintf(wlan_mac_arg, "mac_param=%02X:%02X:%02X:%02X:%02X:%02X",
		mac_bits[5], mac_bits[4], mac_bits[3],
		mac_bits[2], mac_bits[1], mac_bits[0]);
	printf("%s\n", wlan_mac_arg);

	property_set(DRIVER_PROP_MAC_PARAM, wlan_mac_arg);
}
