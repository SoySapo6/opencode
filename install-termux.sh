#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_message() {
    local level=$1
    local message=$2
    local color=""

    case $level in
        info) color="${GREEN}" ;;
        warning) color="${YELLOW}" ;;
        error) color="${RED}" ;;
    esac

    echo -e "${color}${message}${NC}"
}

print_message info "Updating Termux packages..."
pkg update -y

print_message info "Installing Go..."
pkg install -y golang git

print_message info "Cloning repository..."
if [ -d "$HOME/opencode" ]; then
    print_message warning "Directory $HOME/opencode already exists. Pulling latest changes..."
    cd "$HOME/opencode"
    git pull origin main
else
    git clone https://github.com/SoySapo6/opencode.git "$HOME/opencode"
    cd "$HOME/opencode"
fi

print_message info "Building opencode..."
make termux

print_message info "Installing opencode..."
mkdir -p $PREFIX/bin
cp bin/opencode $PREFIX/bin/opencode
chmod +x $PREFIX/bin/opencode

print_message info "Verifying installation..."
if command -v opencode >/dev/null 2>&1; then
    print_message info "opencode successfully installed!"
    print_message info "Run 'opencode' to start the application"
else
    print_message error "Installation failed: binary not in PATH"
    exit 1
fi
