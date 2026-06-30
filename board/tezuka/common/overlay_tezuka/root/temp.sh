#!/bin/sh

find_iio_dev() {
    for d in /sys/bus/iio/devices/iio:device*; do
        n=$(cat "$d/name" 2>/dev/null)
        if [ "$n" = "$1" ]; then
            echo "$d"
            return 0
        fi
    done
    return 1
}

read_temp_c() {
    raw=$(cat "$1" 2>/dev/null)
    if [ -n "$raw" ] && [ "$raw" -gt 0 ] 2>/dev/null; then
        _int=$((raw / 1000))
        _frac=$(( (raw % 1000) / 100 ))
        echo "${_int}.${_frac}C"
    else
        echo "n/a"
    fi
}

read_xadc_temp_c() {
    d="$1"
    raw=$(cat "${d}/in_temp0_raw" 2>/dev/null)
    offset=$(cat "${d}/in_temp0_offset" 2>/dev/null)
    scale=$(cat "${d}/in_temp0_scale" 2>/dev/null)
    if [ -n "$raw" ] && [ -n "$offset" ] && [ -n "$scale" ]; then
        millideg=$(awk "BEGIN {printf \"%d\", ($raw + $offset) * $scale}")
        _int=$((millideg / 1000))
        _frac=$(( (millideg % 1000) / 100 ))
        echo "${_int}.${_frac}C"
    else
        echo "n/a"
    fi
}

echo "=== Temperature Readings ==="
echo ""

ad9361=$(find_iio_dev ad9361-phy)
if [ -n "$ad9361" ]; then
    t=$(read_temp_c "${ad9361}/in_temp0_input")
    echo "AD9361 Tuner IC:  $t"
else
    echo "AD9361 Tuner IC:  not found"
fi

xadc=$(find_iio_dev xadc)
if [ -n "$xadc" ]; then
    t=$(read_xadc_temp_c "$xadc")
    echo "Zynq SoC/FPGA:    $t"
else
    echo "Zynq SoC/FPGA:    not found"
fi

echo ""
echo "---"
echo "sysfs paths:"
echo "  AD9361: ${ad9361:-n/a}"
echo "  XADC:   ${xadc:-n/a}"
