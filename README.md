# test

一个用于验证 **GitHub Webhook → 阿里云 ACR 自动构建** 链路的最小测试项目。

## 项目内容

- `app.py`：基于 Python 标准库的 HTTP 服务，监听 `8080`，返回一段 JSON
- `Dockerfile`：基于 `python:3.12-slim` 构建镜像
- `.dockerignore` / `.gitignore`

## 本地验证

```bash
python app.py
# 另开终端
curl http://localhost:8080/
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
