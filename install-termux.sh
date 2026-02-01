#!/usr/bin/env bash
set -e

print_message() {
    local level=$1
    local message=$2
    echo "[${level}] ${message}"
}

print_message info "Updating Termux packages..."
pkg update -y || true

print_message info "Checking for required packages..."
for pkg in golang git make clang; do
    if ! command -v $pkg >/dev/null 2>&1; then
        print_message info "Installing $pkg..."
        pkg install -y $pkg
    else
        print_message info "$pkg already installed"
    fi
done

print_message info "Cloning repository..."
if [ -d "$HOME/opencode" ]; then
    print_message info "Updating existing repository..."
    cd "$HOME/opencode"
    git pull origin main
else
    git clone https://github.com/SoySapo6/opencode.git "$HOME/opencode"
    cd "$HOME/opencode"
fi

print_message info "Building opencode for Android ARM64..."
print_message info "This may take 3-10 minutes depending on your device..."
make termux

if [ ! -f "bin/opencode" ]; then
    print_message error "Build failed! bin/opencode not found"
    exit 1
fi

print_message info "Installing opencode..."
mkdir -p $PREFIX/bin
cp bin/opencode $PREFIX/bin/opencode
chmod +x $PREFIX/bin/opencode

print_message info "Verifying installation..."
if [ -f "$PREFIX/bin/opencode" ]; then
    print_message info "========================================="
    print_message info "opencode successfully installed!"
    print_message info "========================================="
    print_message info ""
    print_message info "To start: opencode"
    print_message info ""
    print_message info "To configure API keys:"
    print_message info "1. Run: opencode"
    print_message info "2. Press Ctrl+O to open model dialog"
    print_message info "3. Select your provider and enter API key"
else
    print_message error "Installation failed"
    exit 1
fi

