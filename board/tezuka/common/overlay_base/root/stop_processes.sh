#!/bin/sh

echo "=== Stopping Tezuka Lite processes ==="

echo ""
echo "--- Services (via init scripts) ---"

echo "Stopping avahi-daemon..."
/etc/init.d/S50avahi-daemon stop 2>/dev/null

echo "Stopping mosquitto (MQTT broker)..."
/etc/init.d/S50mosquitto stop 2>/dev/null

echo "Stopping maia-httpd (web server)..."
/etc/init.d/S60maia-httpd stop 2>/dev/null

echo "Stopping update.sh (MSD)..."
/etc/init.d/S45msd stop 2>/dev/null

echo ""
echo "--- Background watch scripts ---"

echo "Stopping watchconsoletx.sh..."
kill -9 $(ps 2>/dev/null | grep watchconsoletx.sh | grep -v grep | awk '{print $1}') 2>/dev/null

echo "Stopping watchdatveasy.sh..."
kill -9 $(ps 2>/dev/null | grep watchdatveasy.sh | grep -v grep | awk '{print $1}') 2>/dev/null

echo "Stopping watchconsolefreq.sh..."
kill -9 $(ps 2>/dev/null | grep watchconsolefreq.sh | grep -v grep | awk '{print $1}') 2>/dev/null

echo "Stopping api_controller.sh..."
kill -9 $(ps 2>/dev/null | grep api_controller.sh | grep -v grep | awk '{print $1}') 2>/dev/null

echo "Stopping mosquitto_sub (MQTT subscriber)..."
kill -9 $(ps 2>/dev/null | grep "mosquitto_sub" | grep -v grep | awk '{print $1}') 2>/dev/null

echo ""
echo "--- Kernel threads (cannot be killed) ---"
echo "[irq/32-maia-sdr] is a kernel interrupt handler and cannot be terminated."

echo ""
echo "Done."
