#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OS="$(uname)"

case "$OS" in
    Linux*)     "$DIR/bootstrap.linux.sh" ;;
    Darwin*)    "$DIR/bootstrap.mac.sh" ;;
    *)          echo "Unknown OS: $OS"; exit 1 ;;
esac
