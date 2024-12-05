# Slim Go

This repository demonstrates how to build a lightweight Go application with a **slim Docker image** and support for **timezone configuration**.

## Features

- Uses a multi-stage Docker build to keep the final image minimal.
- Includes timezone support for accurate timestamp logging.
- Compatible with `logrus` for structured logging with timezone-based timestamps.
- Uses the `Asia/Jakarta` timezone as an example.

## Prerequisites

- Docker installed on your system.
- Go version `1.23.1` or later (for development purposes).

## Project Structure

```
.
├── Dockerfile       # Multi-stage Dockerfile
├── main.go          # Sample Go application
└── README.md        # This file
```

## Dockerfile Breakdown

The `Dockerfile` uses a multi-stage build:

1. **Builder Stage**:
   - Based on `golang:1.23.1-alpine`.
   - Installs `tzdata` to enable timezone support.
   - Builds a statically linked Go binary.
2. **Final Stage**:
   - Based on `scratch`, a minimal base image.
   - Copies the Go binary and timezone data.
   - Sets the `TZ` environment variable to `Asia/Jakarta`.

## How It Works

1. The timezone files are copied from the `builder` stage (`/usr/share/zoneinfo`).
2. The `TZ` environment variable is set to specify the desired timezone.
3. The application automatically uses the configured timezone for logging.

## Example Code

### `main.go`

```go
package main

import (
    "github.com/sirupsen/logrus"
    "time"
)

func main() {
    logrus.SetFormatter(&logrus.TextFormatter{
        TimestampFormat: "2006-01-02 15:04:05",
        FullTimestamp:   true,
    })

    logrus.Info("This is a log entry.")

    currentTime := time.Now()
    logrus.Infof("Current Time: %s (Location: %s)", currentTime.Format("2006-01-02 15:04:05"), currentTime.Location())
}
```

## Dockerfile

```dockerfile
# Builder Stage
FROM golang:1.23.1-alpine AS builder
RUN apk add --no-cache tzdata
WORKDIR /app
COPY go.* ./
RUN go mod download && go mod verify
COPY . .
RUN CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -o main -a -trimpath -ldflags="-s -w" -installsuffix cgo

# Final Stage
FROM scratch
COPY --from=builder /app/main /main
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
ENV TZ=Asia/Jakarta
CMD ["/main"]
```

## Build and Run

1. **Build the Docker image:**

   ```bash
   docker build -t slim-go .
   ```

2. **Run the container:**
   ```bash
   docker run --rm slim-go
   ```

## Expected Output

- The logs will include timestamps in the `Asia/Jakarta` timezone.

Example:

```
INFO[0000] This is a log entry.
INFO[0000] Current Time: 2024-12-05 14:30:00 (Location: Asia/Jakarta)
```

## Notes

- Replace `Asia/Jakarta` with your desired timezone by modifying the `ENV TZ` line in the Dockerfile.
- The resulting image is lightweight because it uses `scratch` as the base image, containing only the compiled binary and necessary timezone files.
