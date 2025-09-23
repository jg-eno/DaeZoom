from datetime import datetime 
import json
from loguru import logger
import webbrowser

class DAEZoom:
    def __init__(self) -> None:
        self.day = None
        self.time = None
        try:
            with open('Schedule.json', 'r') as f:
                self.schedule = json.load(f)
            logger.info("Schedule.json found and loaded !!!")
        except FileNotFoundError:
            logger.error("Schedule.json not found....")
            exit(1)
        try:
            with open('Links.json', 'r') as f:
                self.links = json.load(f)
            logger.info("Links.json found and loaded !!!")
        except FileNotFoundError:
            logger.error("Links.json not found....")
            exit(1)

    def get_current_time(self):
        self.day = datetime.today().strftime("%A")
        logger.info(f"Current Day : {self.day}")
        self.time = datetime.now().strftime("%H:%M") 
        logger.info(f"Current Time : {self.time}")

    def is_time_in_range(self, time_range: str, current_time: str) -> bool:
        start_str, end_str = time_range.split("-")
        start = datetime.strptime(start_str, "%H:%M").time()
        end   = datetime.strptime(end_str, "%H:%M").time()
        current = datetime.strptime(current_time, "%H:%M").time()
        if start <= end:
            return start <= current <= end
        else: # handles ranges crossing midnight like 23:00-02:00
            return current >= start or current <= end

    def get_current_class(self) -> str:
        self.get_current_time()
        day_schedule = self.schedule[self.day]
        for time_slot,room_no in day_schedule.items():
            if self.is_time_in_range(time_slot,self.time):
                logger.info(f"Class Found : {room_no}")
                return room_no
        logger.info("Free Period !!! No classes scheduled")
    
    def join_class(self):
        room_to_join = self.get_current_class()
        if room_to_join:
            joining_url = self.links[room_to_join]
            webbrowser.open(joining_url)
            logger.info("Successfully Joined the Class !!!")

dz = DAEZoom()
dz.join_class()