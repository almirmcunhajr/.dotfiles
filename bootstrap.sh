#!/bin/bash

# Install uv
wget -qO- https://astral.sh/uv/install.sh | sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OS="$(uname)"

case "$OS" in
    Linux*)     "$DIR/bootstrap.linux.sh" ;;
    Darwin*)    "$DIR/bootstrap.mac.sh" ;;
    *)          echo "Unknown OS: $OS"; exit 1 ;;
esac
