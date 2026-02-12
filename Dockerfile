# 使用 node 镜像进行构建
FROM node:20-slim AS build

# 设置工作目录
WORKDIR /app

# 安装 pnpm
RUN npm install -g pnpm

# 复制 package.json 和 pnpm-lock.yaml (如果存在)
COPY package.json pnpm-lock.yaml* ./

# 安装依赖
RUN pnpm install

# 复制所有文件并构建
COPY . .
RUN pnpm run build:docker

# 使用 nginx 镜像进行部署
FROM nginx:stable-alpine

# 复制构建产物到 nginx 目录
COPY --from=build /app/dist /usr/share/nginx/html

# 暴露 80 端口
EXPOSE 80

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]
