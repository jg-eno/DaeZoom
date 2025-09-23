# DaeZoom Cron Job Setup

This guide explains how to set up a cron job to automatically run your DaeZoom script every hour.

## Quick Setup (Recommended)

Run the automated setup script:

```bash
cd "/Users/user/Documents/Semester 5/DaeZoom"
./setup_cron.sh
```

This script will:
- Check if all required files exist
- Make the wrapper script executable
- Add the cron job to run every hour
- Show you the current crontab entries

## Manual Setup

If you prefer to set up the cron job manually:

### 1. Open Terminal and navigate to your project directory:
```bash
cd "/Users/user/Documents/Semester 5/DaeZoom"
```

### 2. Make the wrapper script executable:
```bash
chmod +x run_daezoom.sh
```

### 3. Edit your crontab:
```bash
crontab -e
```

### 4. Add this line to run every hour:
```
0 * * * * /Users/user/Documents/Semester\ 5/DaeZoom/run_daezoom.sh
```

### 5. Save and exit the editor (in vim: press Esc, then type `:wq` and press Enter)

## How It Works

- **Cron Schedule**: `0 * * * *` means "run at minute 0 of every hour" (1:00, 2:00, 3:00, etc.)
- **Wrapper Script**: `run_daezoom.sh` handles:
  - Setting up the Python virtual environment
  - Running your `join.py` script
  - Logging all output to daily log files
  - Error handling and reporting

## Logging

- Logs are saved in the `logs/` directory
- Each day gets its own log file: `daezoom_YYYYMMDD.log`
- To view today's logs: `tail -f logs/daezoom_$(date +%Y%m%d).log`
- To view all logs: `ls logs/`

## Managing the Cron Job

### View current cron jobs:
```bash
crontab -l
```

### Remove the DaeZoom cron job:
```bash
crontab -e
# Delete the line containing "run_daezoom.sh"
```

### Test the wrapper script manually:
```bash
./run_daezoom.sh
```

## Troubleshooting

### If the cron job doesn't run:
1. Check if cron service is running: `sudo launchctl list | grep cron`
2. Check system logs: `tail -f /var/log/system.log | grep cron`
3. Verify the script path is correct in crontab
4. Check the log files in the `logs/` directory

### If you get permission errors:
- Make sure the script is executable: `chmod +x run_daezoom.sh`
- Check file permissions: `ls -la run_daezoom.sh`

### If Python dependencies are missing:
- Make sure your virtual environment is set up correctly
- Check that all packages in `requirements.txt` are installed

## Important Notes

- The cron job will only run when your laptop is awake and running
- If your laptop is asleep during a scheduled time, the job will be skipped
- The script checks for classes every hour, so it will automatically join classes when they start
- Make sure your `Schedule.json` and `Links.json` files are up to date

## Security Considerations

- The cron job runs with your user permissions
- Make sure your Zoom links in `Links.json` are secure
- Consider using environment variables for sensitive information if needed
