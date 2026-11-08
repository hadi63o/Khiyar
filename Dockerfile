FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    bash \
    ca-certificates \
    socat \
    tzdata \
    sqlite3 \
    nginx \
    gettext-base \
    fail2ban \
    iptables \
    && ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime \
    && rm -rf /var/lib/apt/lists/*

# دانلود و نصب آخرین نسخه 3x-ui (ثنایی)
RUN curl -fL https://github.com/MHSanaei/3x-ui/releases/latest/download/x-ui-linux-amd64.tar.gz -o /tmp/x-ui.tar.gz \
    && tar -xzf /tmp/x-ui.tar.gz -C /usr/local/ \
    && rm /tmp/x-ui.tar.gz \
    && chmod +x /usr/local/x-ui/x-ui

RUN mkdir -p /etc/x-ui /var/log/x-ui

COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY start.sh /start.sh
RUN chmod +x /start.sh

RUN mkdir -p /usr/share/nginx/html/view
COPY sub-view.html /usr/share/nginx/html/view/index.html

CMD ["/start.sh"]
