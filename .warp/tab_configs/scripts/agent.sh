#!/bin/bash

AGENT=$1

case $AGENT in
  "claude")
    claude
    ;;
  "gemini")
    gemini
    ;;
  "opencode")
    opencode --port
    ;;
esac
