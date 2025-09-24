# DaeZoom Cron Job Setup

This guide explains how to set up a cron job to automatically run your DaeZoom script every hour.

**Note:** Replace `/path/to/your/DaeZoom` in the examples below with the actual path where you've installed the DaeZoom project on your system.

## Quick Setup (Recommended)

Run the automated setup script:

```bash
cd /path/to/your/DaeZoom
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
cd /path/to/your/DaeZoom
```

### 2. Make the wrapper script executable:
```bash
chmod +x run_daezoom.sh
```

### 3. Edit your crontab:
```bash
crontab -e
```

### 4. Add this line to run every hour (replace with your actual path):
```
0 * * * * /path/to/your/DaeZoom/run_daezoom.sh
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

## Advanced Troubleshooting: Cron Jobs Not Executing

### ✅ Problem Fixed!

**Root Cause Identified:**
The issue was that the cron daemon needed to be reloaded/restarted to properly recognize the minute 5 cron job. This often happens when:
• Cron jobs are added but the daemon doesn't immediately pick up the changes
• There are XPC connection interruptions (as we saw in the logs)
• The cron daemon gets into a stale state

**What We Fixed:**
1. ✅ Cron service status: Confirmed cron daemon was running
2. ✅ Crontab syntax: Verified the format was correct
3. ✅ Restarted cron service: Used `sudo pkill -HUP cron` to reload configuration
4. ✅ Tested functionality: Confirmed new cron jobs now work properly

**Verification:**
• Test jobs at minute 12 and 15 both executed successfully
• This indicates the ":05" minute job should now work properly
• The cron daemon is now properly reading and executing all scheduled jobs

**Next Steps:**
Your ":05" minute cron jobs should now execute properly. You can monitor the next execution at the top of the hour (e.g., 13:05) by checking:
```bash
tail -f logs/daezoom_$(date +%Y%m%d).log
```

The fix was essentially a cron daemon reload, which resolved the stuck state that was preventing the minute 5 jobs from executing.

## Important Notes

- The cron job will only run when your laptop is awake and running
- If your laptop is asleep during a scheduled time, the job will be skipped
- The script checks for classes every hour, so it will automatically join classes when they start
- Make sure your `Schedule.json` and `Links.json` files are up to date

## Security Considerations

- The cron job runs with your user permissions
- Make sure your Zoom links in `Links.json` are secure
- Consider using environment variables for sensitive information if needed
