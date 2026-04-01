# Sử dụng Node.js bản slim (glibc) - Rất nhẹ và chuẩn bài cho các thư viện C++
FROM node:20-slim

# Cài đặt git, bash và curl (cần thiết cho OpenCode Agent)
RUN apt-get update && apt-get install -y git bash curl && rm -rf /var/lib/apt/lists/*

# Cài đặt OpenCode và Telegram Bot qua npm
RUN npm install -g opencode-ai @grinev/opencode-telegram-bot

# Đặt thư mục làm việc mặc định là /workspace
WORKDIR /workspace

# Tạo script khởi chạy
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'echo "🚀 Đang khởi động OpenCode server..."' >> /start.sh && \
    echo 'opencode serve & ' >> /start.sh && \
    echo 'sleep 2' >> /start.sh && \
    echo 'echo "🤖 Đang khởi động OpenCode Telegram Bot..."' >> /start.sh && \
    echo 'opencode-telegram start' >> /start.sh && \
    chmod +x /start.sh

# Khởi chạy script
CMD ["/start.sh"]
