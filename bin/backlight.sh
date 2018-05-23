#! /usr/bin/sh
#if [-e /tmp/cur_brightness ];
#then
#  brightness = $(cat /tmp/cur_brightness)
#else
brightness = $(cat /sys/class/backlight/radeon_bl0/brightness)
#fi

if test "$1" = 'up'; then
  brightness = $(($brightness + 10))
elif test "$1" = 'down'; then
  brightness = $(($brightness - 10))
fi

echo $brightness > /sys/class/backlight/radeon_bl0/brightness 2> /dev/null
exit 0;
