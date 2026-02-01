.PHONY: build termux clean test

VERSION=$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
LDFLAGS=-ldflags="-s -w -X github.com/opencode-ai/opencode/internal/version.Version=$(VERSION)"

build:
	@echo "Building opencode for current platform..."
	go build $(LDFLAGS) -o bin/opencode .

termux:
	@echo "Building opencode for Termux (Android ARM64)..."
	@echo "This may take several minutes, please wait..."
	@mkdir -p bin
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=arm64 \
	CC=clang \
	CXX=clang++ \
	CFLAGS="-O2" \
	go build $(LDFLAGS) -o bin/opencode .
	@echo "Build complete! Binary: bin/opencode"

clean:
	@echo "Cleaning build artifacts..."
	rm -rf bin/
	go clean

test:
	@echo "Running tests..."
	go test -v ./...
