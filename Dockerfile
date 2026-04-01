# Sử dụng Bun Alpine image cho dung lượng siêu nhẹ
FROM oven/bun:alpine

# Cài đặt git, bash và curl (OpenCode Agent cần các công cụ này để thao tác)
RUN apk add --no-cache git bash curl

# Tạo symlink 'node' trỏ tới 'bun' để tương thích với các script yêu cầu Node.js
RUN ln -s $(which bun) /usr/local/bin/node

# SỬA LỖI Ở ĐÂY: Dùng đúng tên package là 'opencode-ai'
RUN bun install -g opencode-ai @grinev/opencode-telegram-bot

# Đặt thư mục làm việc mặc định là /workspace (nơi chứa mã nguồn của bạn)
WORKDIR /workspace

# Tạo script khởi chạy cả 2 tiến trình: OpenCode chạy ngầm, Bot chạy chính
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'echo "🚀 Đang khởi động OpenCode server..."' >> /start.sh && \
    echo 'opencode serve & ' >> /start.sh && \
    echo 'sleep 2' >> /start.sh && \
    echo 'echo "🤖 Đang khởi động OpenCode Telegram Bot..."' >> /start.sh && \
    echo 'opencode-telegram start' >> /start.sh && \
    chmod +x /start.sh

# Khởi chạy script
CMD ["/start.sh"]
