# Sử dụng Node.js bản slim (dựa trên Debian glibc) để cài đặt mượt mà các thư viện C/C++
FROM node:20-slim

# Cài đặt các công cụ nền tảng cần thiết cho OpenCode Agent (git, bash, curl)
RUN apt-get update && \
    apt-get install -y git bash curl && \
    rm -rf /var/lib/apt/lists/*

# Cài đặt OpenCode và Telegram Bot globally thông qua npm
RUN npm install -g opencode-ai @grinev/opencode-telegram-bot

# Đặt thư mục làm việc mặc định là /workspace (nơi chứa mã nguồn của bạn)
WORKDIR /workspace

# Tạo script khởi chạy thần thánh: 
# 1. Chạy ngầm OpenCode server
# 2. Tạo file cấu hình từ biến môi trường (ENV) để vượt qua màn hình TTY Wizard
# 3. Chạy OpenCode Telegram Bot
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'echo "🚀 Đang khởi động OpenCode server..."' >> /start.sh && \
    echo 'opencode serve & ' >> /start.sh && \
    echo 'sleep 2' >> /start.sh && \
    echo 'echo "⚙️ Đang tạo file cấu hình từ biến môi trường..."' >> /start.sh && \
    echo 'mkdir -p ~/.config/opencode-telegram-bot' >> /start.sh && \
    echo 'echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN" > ~/.config/opencode-telegram-bot/.env' >> /start.sh && \
    echo 'echo "TELEGRAM_ALLOWED_USER_ID=$TELEGRAM_ALLOWED_USER_ID" >> ~/.config/opencode-telegram-bot/.env' >> /start.sh && \
    echo 'echo "OPENCODE_MODEL_PROVIDER=${OPENCODE_MODEL_PROVIDER:-opencode}" >> ~/.config/opencode-telegram-bot/.env' >> /start.sh && \
    echo 'echo "OPENCODE_MODEL_ID=${OPENCODE_MODEL_ID:-big-pickle}" >> ~/.config/opencode-telegram-bot/.env' >> /start.sh && \
    echo 'echo "BOT_LOCALE=${BOT_LOCALE:-en}" >> ~/.config/opencode-telegram-bot/.env' >> /start.sh && \
    echo 'echo "OPENCODE_API_URL=http://127.0.0.1:4096" >> ~/.config/opencode-telegram-bot/.env' >> /start.sh && \
    echo 'echo "🤖 Đang khởi động OpenCode Telegram Bot..."' >> /start.sh && \
    echo 'opencode-telegram start' >> /start.sh && \
    chmod +x /start.sh

# Khởi chạy script khi container bắt đầu
CMD ["/start.sh"]
