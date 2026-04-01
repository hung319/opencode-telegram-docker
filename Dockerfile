FROM node:20-slim

# Cài đặt môi trường cơ bản
RUN apt-get update && \
    apt-get install -y git bash curl && \
    rm -rf /var/lib/apt/lists/*

# Cài đặt OpenCode và Bot bản gốc
RUN npm install -g opencode-ai opencode-telegram-bot

WORKDIR /workspace

# Script khởi chạy và tự động cấu hình (Chỉ thêm biến có giá trị)
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'CONFIG_DIR="/root/.config/opencode-telegram-bot"' >> /start.sh && \
    echo 'CONFIG_FILE="$CONFIG_DIR/.env"' >> /start.sh && \
    echo 'mkdir -p "$CONFIG_DIR"' >> /start.sh && \
    echo '> "$CONFIG_FILE"' >> /start.sh && \
    echo 'add_env() { if [ ! -z "$(eval echo \$$1)" ]; then echo "$1=$(eval echo \$$1)" >> "$CONFIG_FILE"; fi; }' >> /start.sh && \
    echo 'echo "🚀 Đang khởi động OpenCode server..."' >> /start.sh && \
    echo 'opencode serve & ' >> /start.sh && \
    echo 'sleep 2' >> /start.sh && \
    echo 'echo "⚙️ Đang cấu hình biến môi trường..."' >> /start.sh && \
    echo 'add_env TELEGRAM_BOT_TOKEN' >> /start.sh && \
    echo 'add_env TELEGRAM_ALLOWED_USER_ID' >> /start.sh && \
    echo 'add_env TELEGRAM_PROXY_URL' >> /start.sh && \
    echo 'add_env OPENCODE_API_URL' >> /start.sh && \
    echo 'add_env OPENCODE_SERVER_USERNAME' >> /start.sh && \
    echo 'add_env OPENCODE_SERVER_PASSWORD' >> /start.sh && \
    echo 'add_env OPENCODE_MODEL_PROVIDER' >> /start.sh && \
    echo 'add_env OPENCODE_MODEL_ID' >> /start.sh && \
    echo 'add_env BOT_LOCALE' >> /start.sh && \
    echo 'echo "🤖 Đang khởi động OpenCode Telegram Bot"' >> /start.sh && \
    echo 'opencode-telegram-bot start' >> /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]
