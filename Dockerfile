# Gemini OpenAI兼容API Docker镜像
# 基于官方Python 3.11 Alpine镜像，最小的体积
FROM python:3.11-alpine

# 设置工作目录
WORKDIR /app

# 安装系统依赖
# curl用于健康检查，build-base用于编译Python包（如果需要）
RUN apk add --no-cache \
    curl \
    && rm -rf /var/cache/apk/*

# 复制依赖文件
COPY requirements.txt .

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用程序文件
COPY . .

# 创建必要的目录
RUN mkdir -p media_cache

# 设置环境变量
ENV PYTHONUNBUFFERED=1
ENV PORT=8000
ENV HOST=0.0.0.0

# # 创建非root用户运行应用（Alpine使用adduser）
# RUN adduser -D -u 1000 appuser && \
#     chown -R appuser:appuser /app
# USER appuser

# 暴露端口
EXPOSE 8000

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/ || exit 1

# 启动命令
CMD ["python", "server.py"]
