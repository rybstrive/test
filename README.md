# test

一个用于验证 **GitHub Webhook → 阿里云 ACR 自动构建** 链路的最小测试项目。

这是一个 Go 写的 HTTP 服务。Dockerfile 采用**多阶段构建**：编译阶段用 `golang:1.26-alpine` 产出静态二进制，运行阶段只把二进制拷入极简的 `alpine` 镜像。

## 项目内容

- `main.go`：HTTP 服务，监听 `8080`，返回一段 JSON
- `go.mod`：Go module 定义（无外部依赖）
- `Dockerfile`：多阶段构建，最终镜像只包含编译后的二进制

## 本地验证

```bash
go build -o app .
./app
# 另开终端
curl http://localhost:8080/
```

交叉编译成与容器一致的 Linux 二进制：

```bash
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o app .
```

构建镜像：

```bash
docker build -t test:local .
docker run --rm -p 8080:8080 test:local
```

## 用于 ACR 构建规则示例

在 ACR 创建镜像仓库并绑定本 GitHub 仓库后，可配置：

- 类型：`Branch`
- Branch/Tag：`main`
- 构建上下文目录：`/`
- Dockerfile 文件名：`Dockerfile`
- 镜像版本：`latest`

之后向 `main` 分支 push 代码，GitHub 会通过 ACR 自动创建的 Webhook 触发镜像构建。
