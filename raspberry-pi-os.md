# Raspberry Pi OS

```
cat /sys/class/thermal/thermal_zone0/temp
grep . /sys/class/hwmon/hwmon*/{temp,fan,pwm}*
cat /sys/devices/platform/cooling_fan/hwmon/hwmon1/fan1_input
vcgencmd version
vcgencmd measure_temp
vcgencmd measure_volts
vcgencmd measure_clock
vcgencmd bootload_version
```
