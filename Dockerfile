FROM docker.m.daocloud.io/library/golang:1.26-alpine AS builder

WORKDIR /src

COPY go.mod ./
RUN go mod download

COPY main.go .

RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/app .

FROM docker.m.daocloud.io/library/alpine:3.21

COPY --from=builder /out/app /usr/local/bin/app

EXPOSE 8080
USER 65532:65532

ENTRYPOINT ["/usr/local/bin/app"]
