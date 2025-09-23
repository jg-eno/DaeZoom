#!/bin/bash

# DaeZoom Cron Job Wrapper Script
# This script sets up the environment and runs the DaeZoom join.py script

# Set the working directory to the script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Set up logging
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/daezoom_$(date +%Y%m%d).log"

# Function to log with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_message "Starting DaeZoom cron job execution"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    log_message "ERROR: Virtual environment not found at $SCRIPT_DIR/venv"
    exit 1
fi

# Activate virtual environment
source venv/bin/activate

# Check if activation was successful
if [ -z "$VIRTUAL_ENV" ]; then
    log_message "ERROR: Failed to activate virtual environment"
    exit 1
fi

log_message "Virtual environment activated: $VIRTUAL_ENV"

# Check if required files exist
if [ ! -f "join.py" ]; then
    log_message "ERROR: join.py not found"
    exit 1
fi

if [ ! -f "Schedule.json" ]; then
    log_message "ERROR: Schedule.json not found"
    exit 1
fi

if [ ! -f "Links.json" ]; then
    log_message "ERROR: Links.json not found"
    exit 1
fi

log_message "All required files found"

# Run the Python script
log_message "Executing join.py..."
python join.py >> "$LOG_FILE" 2>&1
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    log_message "DaeZoom execution completed successfully"
else
    log_message "ERROR: DaeZoom execution failed with exit code $EXIT_CODE"
fi

# Deactivate virtual environment
deactivate

log_message "DaeZoom cron job execution finished"
exit $EXIT_CODE
