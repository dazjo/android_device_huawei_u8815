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

#define NV_READ_F 0
#define NV_BD_ADDR_I 0x1BF

/* In libnv.so */
extern void nv_cmd_remote(int func, int item, void *result);

/* In liboncrpc.so */
extern void oncrpc_init();
extern void oncrpc_deinit();
extern void oncrpc_task_start();
extern void oncrpc_task_stop();

static const char PROP_BDADDR[] = "ro.bt.bdaddr_path";
static const char FILE_BDADDR[] = "/data/misc/bluetooth/.bdaddr";

int main()
{
	char bdaddr[PROPERTY_VALUE_MAX];
	int file;

	int mac_bits[2] = { 0, };

	/* Set Bluetooth MAC address by loading it from the radio. */
	oncrpc_init();
	oncrpc_task_start();
	nv_cmd_remote(NV_READ_F, NV_BD_ADDR_I, &mac_bits);
	oncrpc_task_stop();
	oncrpc_deinit();

	sprintf(bdaddr, "%02X:%02X:%02X:%02X:%02X:%02X",
		(mac_bits[1]&0xFF00) >> 8, mac_bits[1]&0xFF, (mac_bits[0]&0xFF000000) >> 24,
		(mac_bits[0]&0xFF0000) >> 16, (mac_bits[0]&0xFF00) >> 8, mac_bits[0]&0xFF);
	printf("%s\n", bdaddr);

	file = open(FILE_BDADDR, O_WRONLY|O_CREAT|O_TRUNC, 00666);

	if (file < 0)
		ALOGE("Can't open %s\n", FILE_BDADDR);

	write(file, bdaddr, strlen(bdaddr));
	close(file);
	chmod(FILE_BDADDR, 00666);

	property_set(PROP_BDADDR, FILE_BDADDR);

	return 0;
}
