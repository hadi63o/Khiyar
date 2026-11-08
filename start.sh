#!/bin/bash
set -e

echo "🚀 Starting X-UI + nginx reverse proxy..."

# nginx همیشه روی پورت ثابت 3000 گوش می‌دهد
export NGINX_PORT=3000

cd /usr/local/x-ui

echo "🔧 Applying panel settings via x-ui CLI..."
./x-ui setting -port 2053 -webBasePath /managepanel/ \
  -username "${PANEL_USER:?PANEL_USER is not set}" \
  -password "${PANEL_PASS:?PANEL_PASS is not set}"
./x-ui setting -show true

echo "🧪 Checking iptables permission (needed for Fail2ban)..."
iptables -L >/dev/null 2>&1 && echo "✅ iptables OK" || echo "❌ iptables NOT permitted"

echo "🔧 Building nginx.conf for fixed port: $NGINX_PORT"
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "▶️ Starting x-ui in background..."
./x-ui &

sleep 3

echo "▶️ Starting nginx in foreground on port $NGINX_PORT..."
nginx -t
exec nginx -g "daemon off;"
