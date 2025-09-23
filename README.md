# DaeZoom - Automated Class Joiner

A Python automation tool that automatically joins your online classes based on your timetable and room assignments.

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

## Usage

1. Configure your class schedule in `Schedule.json`
2. Add your Zoom meeting links to `Links.json`
3. Run the automation script to automatically join classes based on your timetable

## Requirements

- Python 3.x
- Required packages listed in `requirements.txt`