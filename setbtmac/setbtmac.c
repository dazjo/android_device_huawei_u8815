/*
 * Copyright (C) 2013 The CyanogenMod Project
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

#include <fcntl.h>
#include <string.h>
#include <cutils/log.h>
#include <cutils/properties.h>
#include <sys/stat.h>

static const char PROP_SERIALNO[] = "ro.serialno";
static const char PROP_BDADDR[] = "ro.bt.bdaddr_path";
static const char FILE_BDADDR[] = "/data/misc/bluetooth/.bdaddr";

void SetMAC(void);

int main()
{
	SetMAC();
	return 0;
}

void SetMAC(void)
{
	char serialno[PROPERTY_VALUE_MAX];
	char bdaddr[PROPERTY_VALUE_MAX];
	int file;

	/* The Bluetooth MAC address is the same as the device's serialno.
	   Use this as the Bluetooth stack introduced in 4.2 cannot get our
	   MAC address due to Huawei weirdness. */

	property_get(PROP_SERIALNO, serialno, NULL);

	sprintf(bdaddr, "%2.2s:%2.2s:%2.2s:%2.2s:%2.2s:%2.2s",
		serialno, serialno+2, serialno+4,
		serialno+6, serialno+8, serialno+10);
	printf("%s\n", bdaddr);

	file = open(FILE_BDADDR, O_WRONLY|O_CREAT|O_TRUNC, 00600|00060|00006);
	if (file < 0)
	{
		ALOGE("Can't open %s\n", FILE_BDADDR);
	}
	write(file, bdaddr, strlen(bdaddr));
	close(file);
	chmod(FILE_BDADDR, 00600|00060|00006);

	property_set(PROP_BDADDR, FILE_BDADDR);
}
