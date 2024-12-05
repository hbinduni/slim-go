FROM golang:1.23.4-alpine AS builder
RUN apk add --no-cache tzdata upx
WORKDIR /app
COPY go.* ./
RUN go mod download && go mod verify
COPY . .
RUN CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -o main -a -trimpath -ldflags="-s -w" -installsuffix cgo
RUN upx --ultra-brute -qq main && upx -t main

FROM scratch
COPY --from=builder /app/main /main
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
ENV TZ=Asia/Jakarta
CMD ["/main"]
