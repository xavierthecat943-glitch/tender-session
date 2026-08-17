#!/bin/bash
# tender-session - Session starter script
# This script initializes the tender-session environment

set -e

echo "Starting tender-session..."

# Set up environment
export XDG_SESSION_TYPE=tty
export XDG_SESSION_DESKTOP=tender-session

# Start kitty terminal
exec kitty
