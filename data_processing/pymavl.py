import pymavlink  #mavlink
import RPi.GPIO as GPIO
import time  # For timing actions

mavlink_connection = pymavlink.connect('/dev/ttyAMA0', baudrate=115200)  # Adjust 
GPIO.setmode(GPIO.BCM) 
docking_sensor_pin = 17 
GPIO.setup(docking_sensor_pin, GPIO.IN) 


while True:
    sensor_value = GPIO.input(docking_sensor_pin)

    if sensor_value == 1:  
        
        print("Docking successful!")
        
    time.sleep(0.1) 
