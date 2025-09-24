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

# Create the cron job entries
CRON_ENTRY_0="0 * * * * $WRAPPER_SCRIPT"
CRON_ENTRY_5="5 * * * * $WRAPPER_SCRIPT"

echo "Cron job entries:"
echo "  $CRON_ENTRY_0"
echo "  $CRON_ENTRY_5"
echo "This will run every hour at minute 0 and minute 5 (e.g., 1:00, 1:05, 2:00, 2:05, etc.)"
echo "This ensures classes starting at :00 and :05 minutes are properly detected."

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

# Add the new cron jobs
echo "Adding new cron jobs..."
(crontab -l 2>/dev/null; echo "$CRON_ENTRY_0"; echo "$CRON_ENTRY_5") | crontab -

if [ $? -eq 0 ]; then
    echo "✅ Cron jobs successfully added!"
    echo ""
    echo "Current crontab entries:"
    crontab -l
    echo ""
    echo "The DaeZoom script will now run every hour at minute 0 and minute 5."
    echo "This ensures classes starting at :00 and :05 minutes are properly detected."
    echo "Logs will be saved to: $SCRIPT_DIR/logs/"
    echo ""
    echo "To view logs: tail -f $SCRIPT_DIR/logs/daezoom_\$(date +%Y%m%d).log"
    echo "To remove the cron jobs: crontab -e (then delete the lines with run_daezoom.sh)"
else
    echo "❌ Failed to add cron jobs!"
    exit 1
fi
