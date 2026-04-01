FROM node:20-slim

# Cài đặt môi trường cơ bản
RUN apt-get update && \
    apt-get install -y git bash curl && \
    rm -rf /var/lib/apt/lists/*

# Cài đặt OpenCode và Bot bản gốc (grinev)
RUN npm install -g opencode-ai opencode-telegram-bot

WORKDIR /workspace

# Đảm bảo môi trường HOME nhất quán để lưu config
ENV HOME=/root

# Tạo script khởi chạy thông minh
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'CONFIG_DIR="$HOME/.config/opencode-telegram-bot"' >> /start.sh && \
    echo 'CONFIG_FILE="$CONFIG_DIR/.env"' >> /start.sh && \
    echo 'mkdir -p "$CONFIG_DIR"' >> /start.sh && \
    # --- Thiết lập các biến Cốt lõi (Tránh Wizard) ---
    echo 'echo "TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}" > "$CONFIG_FILE"' >> /start.sh && \
    echo 'echo "TELEGRAM_ALLOWED_USER_ID=${TELEGRAM_ALLOWED_USER_ID}" >> "$CONFIG_FILE"' >> /start.sh && \
    echo 'echo "OPENCODE_API_URL=${OPENCODE_API_URL:-http://127.0.0.1:4096}" >> "$CONFIG_FILE"' >> /start.sh && \
    echo 'echo "OPENCODE_MODEL_PROVIDER=${OPENCODE_MODEL_PROVIDER:-opencode}" >> "$CONFIG_FILE"' >> /start.sh && \
    echo 'echo "OPENCODE_MODEL_ID=${OPENCODE_MODEL_ID:-big-pickle}" >> "$CONFIG_FILE"' >> /start.sh && \
    echo 'echo "BOT_LOCALE=${BOT_LOCALE:-en}" >> "$CONFIG_FILE"' >> /start.sh && \
    # --- Hàm nạp thêm biến tùy chọn (Chỉ nạp nếu có giá trị trên Dokploy) ---
    echo 'add_env() { if [ ! -z "$(eval echo \$$1)" ]; then echo "$1=$(eval echo \$$1)" >> "$CONFIG_FILE"; fi; }' >> /start.sh && \
    echo 'add_env TELEGRAM_PROXY_URL' >> /start.sh && \
    echo 'add_env OPENCODE_SERVER_USERNAME' >> /start.sh && \
    echo 'add_env OPENCODE_SERVER_PASSWORD' >> /start.sh && \
    # --- Khởi động hệ thống ---
    echo 'echo "🚀 Đang khởi động OpenCode server..."' >> /start.sh && \
    echo 'opencode serve & ' >> /start.sh && \
    echo 'sleep 5' >> /start.sh && \
    echo 'echo "⚙️ Đang cấu hình biến môi trường cho bản..."' >> /start.sh && \
    echo 'echo "🤖 Đang khởi động OpenCode Telegram Bot..."' >> /start.sh && \
    echo 'opencode-telegram-bot start' >> /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]
