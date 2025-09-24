# DaeZoom - Automated Class Joiner

A Python automation tool that automatically joins your online classes based on your timetable and room assignments.

## Quick Start - Automated Execution (Recommended)

Set up a cron job to automatically run the script every hour:

```bash
./setup_cron.sh
```

This will automatically:
- Set up a cron job to run every hour
- Handle virtual environment activation
- Log all executions to daily log files
- Provide error handling and reporting

For detailed cron job setup instructions, troubleshooting, and management, see [CRON_SETUP_README.md](CRON_SETUP_README.md).

## macOS Setup

To enable cron functionality on macOS, grant Full Disk Access permission:

1. Open System Preferences from the  Apple menu, then choose "Security & Privacy"
2. Go to the "Privacy" tab, then select "Full Disk Access" from the side menu options
3. ⌘ + Shift + G (Go → Go to Folder) : To enter the location to go to
4. Enter the path: `/usr/sbin/cron` and choose Go
5. Drag and drop "cron" into the list of apps and processes with Full Disk Access permission, 'cron' should now appear in the list
6. Close out of System Preferences and the open Finder sbin window when finished

## Zoom Instructions (In Zoom Settings)

Before using DaeZoom, configure your Zoom application with the following settings for optimal automated joining:

### Recommended Zoom Settings:

1. **Disable "Always show preview before joining"**
   - Go to Zoom Settings → General
   - Uncheck "Always show preview before joining"
   - This allows automatic joining without manual confirmation

2. **Enable "Always mute while joining"**
   - Go to Zoom Settings → Audio
   - Check "Always mute my microphone when joining a meeting"
   - Prevents accidental audio disruption when joining classes

3. **Enable "Always turn off video while joining"**
   - Go to Zoom Settings → Video
   - Check "Always turn off my video when joining a meeting"
   - Ensures privacy and prevents accidental video sharing

These settings ensure that DaeZoom can join your classes automatically without requiring manual intervention or causing disruptions.

## Configuration Files

### Schedule.json
Contains your weekly class schedule with room assignments. The file maps time slots to classroom locations for each day of the week (Monday through Friday).

**Format:**
```json
{
    "Monday": {
        "09:00-09:55": "AA_111",
        "10:00-10:55": "AA_111",
        "11:05-12:00": "AC_306",
        "12:05-13:00": "AA_111",
        "14:00-14:55": "AC_306",
        "15:00-16:55": "AA_111"
    },
    "Tuesday": {
        // ... more time slots
    }
    // ... more days
}
```

**Time Format:** 24-hour format (HH:MM-HH:MM)
**Room Codes:** Match the classroom identifiers used in your institution

### Links.json
Maps classroom codes to their corresponding Zoom meeting links. This file securely stores the authentication URLs for each classroom.

**Format:**
```json
{
    "AA_111": "https://zoom.us/w/[meeting-id]?tk=[auth-token]&pwd=[password]",
    "AC_306": "https://zoom.us/w/[meeting-id]?tk=[auth-token]&pwd=[password]",
    "AA_126": "https://zoom.us/w/[meeting-id]?tk=[auth-token]&pwd=[password]"
}
```

**Security Note:** Keep this file secure and never commit actual authentication URLs to version control. Use placeholder URLs in examples and documentation.

## Manual Execution

For one-time or testing purposes:

1. Configure your class schedule in `Schedule.json`
2. Add your Zoom meeting links to `Links.json`
3. Run the automation script: `python join.py`

## Requirements

- Python 3.x
- Required packages listed in `requirements.txt`