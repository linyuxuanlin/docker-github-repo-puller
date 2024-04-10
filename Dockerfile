FROM bash:latest

# 设置工作目录
WORKDIR /app

# 将脚本复制到容器中
COPY github-pull.sh /app/

# 设置可执行权限
RUN chmod +x github-pull.sh

# 安装 git 和 cron
RUN apt-get update && apt-get install -y git cron

# 将定时任务添加到 cron
RUN echo "0 14 * * * /app/github-pull.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/github_repo_puller

# 启动 cron 服务
CMD ["cron", "-f"]
