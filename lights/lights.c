/*
 * Copyright (C) 2008 The Android Open Source Project
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

//#define LOG_NDEBUG 0
#define LOG_TAG "lights.u8815"

#include <cutils/log.h>

#include <cutils/properties.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>

#include <sys/ioctl.h>
#include <sys/types.h>

#include <hardware/lights.h>
#include <hardware_legacy/power.h>

#include "private/android_filesystem_config.h"
 #include <sys/wait.h>

static pthread_once_t g_init = PTHREAD_ONCE_INIT;
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;

#define TRUE    1
#define FALSE   0
static int led_link_status = FALSE;
static int write_int(char const *path, int value);

char const*const PANEL_FILE = "/sys/class/leds/lcd-backlight/brightness";
char const*const BUTTON_FILE = "/sys/class/leds/button-backlight/brightness";
char const*const RED_LED_FILE = "/sys/class/leds/red/brightness";
char const*const BLUE_LED_FILE = "/sys/class/leds/blue/brightness";
char const*const GREEN_LED_FILE = "/sys/class/leds/green/brightness";

struct led_config {
    unsigned int color;
    int delay_on, delay_off;
};

enum {
    LED_RED,
    LED_GREEN,
    LED_BLUE,
    LED_BLANK,
};

struct blink_config {
    unsigned int RED;    // 255 or 0
    unsigned int BLUE;
    unsigned int GREEN;
    unsigned int onMs;   //led on last time
    unsigned int offMs;  //led off last time
};
static struct blink_config par;
static pthread_t blink;

static struct led_config g_leds[3]; // For battery, notifications, and attention.
static int g_cur_led = -1;          // Presently showing LED of the above.

void *led_blink(void *arg){
    while(led_link_status){
        write_int(RED_LED_FILE, par.RED);
        write_int(BLUE_LED_FILE, par.BLUE);
        write_int(GREEN_LED_FILE, par.GREEN);
        usleep(par.onMs*1000);

        if (g_leds[1].color > 0) {
            write_int(RED_LED_FILE, 0);
            write_int(BLUE_LED_FILE, 0);
            write_int(GREEN_LED_FILE, 0);
        }
        usleep(par.offMs*1000);
    }
    pthread_exit((void *)0);
    return 0;
}

int start_notification(){
    pthread_mutex_lock(&g_lock);
    led_link_status = TRUE;
    acquire_wake_lock(PARTIAL_WAKE_LOCK, "blink_id");
    if (pthread_create(&blink, NULL, led_blink, NULL) != 0) {
        ALOGE("Can't start blink thread\n");
        pthread_mutex_unlock(&g_lock);
        return -1;
    }
    pthread_mutex_unlock(&g_lock);
    return 0;
}

int stop_notification(){
    pthread_mutex_lock(&g_lock);
    led_link_status = FALSE;
    release_wake_lock("blink_id");
    pthread_mutex_unlock(&g_lock);
    return 0;
}

void init_g_lock(void)
{
    pthread_mutex_init(&g_lock, NULL);
}

static int write_int(char const *path, int value)
{
    int fd;
    static int already_warned;

    already_warned = 0;

    ALOGV("write_int: path %s, value %d", path, value);
    fd = open(path, O_RDWR);
    if (fd < 0) {
        if (already_warned == 0) {
            ALOGE("write_int failed to open %s\n", path);
            already_warned = 1;
        }
        return -errno;
    }

    char buffer[20];
    int bytes = snprintf(buffer, sizeof(buffer), "%d\n",value);
    int written = write(fd, buffer, bytes);
    close (fd);

    return written == -1 ? -errno : 0;
}

static int rgb_to_brightness(struct light_state_t const *state)
{
    int color = state->color & 0x00ffffff;

    return ((77*((color>>16) & 0x00ff))
        + (150*((color>>8) & 0x00ff)) + (29*(color & 0x00ff))) >> 8;
}

static int is_lit(struct light_state_t const* state)
{
    return state->color & 0x00ffffff;
}

static int set_light_backlight(struct light_device_t *dev,
            struct light_state_t const *state)
{
    int err = 0;
    int brightness = rgb_to_brightness(state);

    pthread_mutex_lock(&g_lock);
    err = write_int(PANEL_FILE, brightness);

    pthread_mutex_unlock(&g_lock);
    return err;
}

static int
set_light_buttons(struct light_device_t* dev,
        struct light_state_t const* state)
{
    int err = 0;
    int on = is_lit(state);

    pthread_mutex_lock(&g_lock);
    err = write_int(BUTTON_FILE, on?255:0);
    pthread_mutex_unlock(&g_lock);

    return err;

}

static int close_lights(struct light_device_t *dev)
{
    ALOGV("close_light is called");
    if (dev)
        free(dev);

    return 0;
}

/* LEDs */
static int write_leds(const struct led_config *led)
{
    unsigned int colorRGB = led->color & 0x00FFFFFF;

    pthread_mutex_lock(&g_lock);

    write_int(BLUE_LED_FILE, (colorRGB & 0xFF)? 255 : 0);
    write_int(GREEN_LED_FILE, ((colorRGB >> 8)&0xFF)? 255 : 0);
    write_int(RED_LED_FILE, ((colorRGB >> 16)&0xFF)? 255 : 0);
    
    pthread_mutex_unlock(&g_lock);

    return 0;
}

static int set_light_leds(struct light_state_t const *state, int type)
{
    struct led_config *led;
    int err = 0;

    ALOGD("%s: type=%d, color=%#010x, fM=%d, fOnMS=%d, fOffMs=%d.", __func__,
          type, state->color,state->flashMode, state->flashOnMS, state->flashOffMS);

    if (type < 0 || (unsigned int)type >= sizeof(g_leds)/sizeof(g_leds[0]))
        return -EINVAL;

    /* type is one of:
     *   0. battery
     *   1. notifications
     *   2. attention
     * which are multiplexed onto the same physical LED in the above order. */
    led = &g_leds[type];

    if(type == 1){
        pthread_mutex_lock(&g_lock);

        par.RED = ((state->color >> 16) & 0xFF)? 255 : 0;
        par.GREEN = ((state->color >> 8) & 0xFF)? 255 : 0;
        par.BLUE = (state->color & 0xFF)? 255 : 0;

        par.onMs = state->flashOnMS;
        par.offMs = state->flashOffMS;

        pthread_mutex_unlock(&g_lock);

        if(state->color > 0){
            start_notification();
        } else {
            stop_notification();
        }
    }

    switch (state->flashMode) {
        case LIGHT_FLASH_NONE:
                /* Set LED to a solid color, spec is unclear on the exact behavior here. */
                led->delay_on = led->delay_off = 0;
                break;
        case LIGHT_FLASH_TIMED:
        case LIGHT_FLASH_HARDWARE:
                led->delay_on  = state->flashOnMS;
                led->delay_off = state->flashOffMS;
            break;
        default:
                ALOGD("ERROR MODE:%d", state->flashMode);
                return -EINVAL;
    }

    led->color = state->color & 0x00ffffff;

    if (led->color > 0) {
        /* This LED is lit. */
        if (type >= g_cur_led) {
            /* And it has the highest priority, so show it. */
            err = write_leds(led);
            g_cur_led = type;
        }
    } else {
        /* This LED is not (any longer) lit. */
        if ((type == g_cur_led)&&(type != 0)) {
            /* But it is currently showing, switch to a lower-priority LED. */
            int i;

            for (i = type-1; i >= 0; i--) {
                if (g_leds[i].color > 0) {
                    /* Found a lower-priority LED to switch to. */
                    err = write_leds(&g_leds[i]);
                    goto switched;
                }
            }

            /* No LEDs are lit, turn off. */
            err = write_leds(led);
switched:
            g_cur_led = i;
        } else {
            err = write_leds(led);
        }
    }

    return err;
}

static int set_light_leds_battery(struct light_device_t *dev,
            struct light_state_t const *state)
{
    return set_light_leds(state, 0);
}

static int set_light_leds_notifications(struct light_device_t *dev,
            struct light_state_t const *state)
{
    return set_light_leds(state, 1);
}

static int set_light_leds_attention(struct light_device_t *dev,
            struct light_state_t const *state)
{
    struct light_state_t fixed;

    memcpy(&fixed, state, sizeof(fixed));

    /* The framework does odd things with the attention lights, fix them up to
     * do something sensible here. */
    switch (fixed.flashMode) {
    case LIGHT_FLASH_NONE:
        /* LightsService.Light::stopFlashing calls with non-zero color. */
        fixed.color = 0;
        break;
    case LIGHT_FLASH_HARDWARE:
        /* PowerManagerService::setAttentionLight calls with onMS=3, offMS=0, which
         * just makes for a slightly-dimmer LED. */
        if (fixed.flashOnMS > 0 && fixed.flashOffMS == 0)
            fixed.flashMode = LIGHT_FLASH_NONE;
        break;
    }

    return set_light_leds(&fixed, 2);
}

static int open_lights(const struct hw_module_t *module, char const *name,
                        struct hw_device_t **device)
{
    int (*set_light)(struct light_device_t *dev,
        struct light_state_t const *state);

    if (0 == strcmp(LIGHT_ID_BACKLIGHT, name))
        set_light = set_light_backlight;
    else if (0 == strcmp(LIGHT_ID_BUTTONS, name))
        set_light = set_light_buttons;
    else if (0 == strcmp(LIGHT_ID_NOTIFICATIONS, name))
        set_light = set_light_leds_notifications;
    else if (0 == strcmp(LIGHT_ID_ATTENTION, name))
        set_light = set_light_leds_attention;
    else if (0 == strcmp(LIGHT_ID_BATTERY, name)) {
            set_light = set_light_leds_battery;
    }
    else
        return -EINVAL;

    pthread_once(&g_init, init_g_lock);

    struct light_device_t *dev = malloc(sizeof(struct light_device_t));
    memset(dev, 0, sizeof(*dev));

    dev->common.tag = HARDWARE_DEVICE_TAG;
    dev->common.version = 0;
    dev->common.module = (struct hw_module_t *)module;
    dev->common.close = (int (*)(struct hw_device_t *))close_lights;
    dev->set_light = set_light;

    *device = (struct hw_device_t *)dev;

    return 0;
}

static struct hw_module_methods_t lights_module_methods = {
    .open =  open_lights,
};

struct hw_module_t HAL_MODULE_INFO_SYM = {
    .tag = HARDWARE_MODULE_TAG,
    .version_major = 1,
    .version_minor = 0,
    .id = LIGHTS_HARDWARE_MODULE_ID,
    .name = "U8815 Lights Module",
    .author = "The CyanogenMod Project",
    .methods = &lights_module_methods,
};
