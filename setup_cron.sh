#!/bin/bash

# DaeZoom Cron Job Setup Script
# This script automatically sets up the cron job for DaeZoom

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WRAPPER_SCRIPT="$SCRIPT_DIR/run_daezoom.sh"

echo "Setting up DaeZoom cron job..."
echo "Script directory: $SCRIPT_DIR"
echo "Wrapper script: $WRAPPER_SCRIPT"

# Check if wrapper script exists and is executable
if [ ! -f "$WRAPPER_SCRIPT" ]; then
    echo "ERROR: Wrapper script not found at $WRAPPER_SCRIPT"
    exit 1
fi

if [ ! -x "$WRAPPER_SCRIPT" ]; then
    echo "Making wrapper script executable..."
    chmod +x "$WRAPPER_SCRIPT"
fi

# Create the cron job entry
CRON_ENTRY="0 * * * * $WRAPPER_SCRIPT"

echo "Cron job entry: $CRON_ENTRY"
echo "This will run every hour at minute 0 (e.g., 1:00, 2:00, 3:00, etc.)"

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -q "$WRAPPER_SCRIPT"; then
    echo "WARNING: A cron job for this script already exists!"
    echo "Current crontab entries:"
    crontab -l 2>/dev/null | grep "$WRAPPER_SCRIPT"
    echo ""
    read -p "Do you want to replace the existing cron job? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cron job setup cancelled."
        exit 0
    fi
    
    # Remove existing cron job
    echo "Removing existing cron job..."
    crontab -l 2>/dev/null | grep -v "$WRAPPER_SCRIPT" | crontab -
fi

# Add the new cron job
echo "Adding new cron job..."
(crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -

if [ $? -eq 0 ]; then
    echo "✅ Cron job successfully added!"
    echo ""
    echo "Current crontab entries:"
    crontab -l
    echo ""
    echo "The DaeZoom script will now run every hour."
    echo "Logs will be saved to: $SCRIPT_DIR/logs/"
    echo ""
    echo "To view logs: tail -f $SCRIPT_DIR/logs/daezoom_\$(date +%Y%m%d).log"
    echo "To remove the cron job: crontab -e (then delete the line with run_daezoom.sh)"
else
    echo "❌ Failed to add cron job!"
    exit 1
fi
