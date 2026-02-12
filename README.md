# JetBra Viewer

A Vue 3 application for viewing and managing activation codes.

## ⚠️ Disclaimer

**Please read the following carefully before using this project:**

*   **For educational and testing purposes only. Not for commercial use.**
*   **This is a personal page, not an official website.**
*   **All the above keys are collected from the Internet and are for testing purposes only, not for commercial use!**

Please support the official software and developers. If you find the software useful, please purchase a valid license from the official website.

## Development

This project uses [Vue 3](https://vuejs.org/) + [Vite](https://vitejs.dev/).

### Prerequisites

*   Node.js (v18 or higher recommended)
*   pnpm

### Installation

```bash
pnpm install
```

### Development

```bash
pnpm run dev
```

### Build

```bash
pnpm run build
```

## Docker

### 使用 Docker Hub 镜像 (推荐)

如果你已经配置了 GitHub Actions 自动推送镜像，可以直接运行：

```bash
docker run -d -p 8080:80 --name jetbra-viewer YOUR_DOCKERHUB_USERNAME/jetbra-viewer:latest
```

### 本地构建并运行

1. 构建镜像:
```bash
docker build -t jetbra-viewer .
```

2. 启动容器:
```bash
docker run -d -p 8080:80 --name jetbra-viewer jetbra-viewer
```

启动后可通过 `http://localhost:8080` 访问。

## License

MIT
