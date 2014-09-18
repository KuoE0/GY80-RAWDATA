Arduino Code for GY-80
======================

Hardware
--------

- Arduino UNO
- GY-80 (10 DOF IMU Module with L3G4200D, ADXL345, HMC5883L and BMP085)

Wire Connection
---------------

| Arduino | GY-80  |
|:-------:|:------:|
| 5V      | VCC_IN |
| GND     | GND    |
| A4      | SDA    |
| A5      | SCL    |

System Requirement
------------------

- [Ino](http://inotool.org/)
- [Arduino IDE](http://arduino.cc/en/main/software)
- [Picocom](https://code.google.com/p/picocom/)

Usage
-----

1. Connect your Arduino UNO to your computer.
2. Open terminal and locate to this folder.
3. Type ```make build``` to compile the code.
4. Type ```make upload``` to upload the binary file to Arduino UNO.
5. Type ```picocom -b 9600 /dev/tty.usbmodem1421``` to comunicate with Arduino.
6. If you want to rebuild the code, you can type ```make clean``` to clean the original binary file.
7. You can also type ```make all``` to finish ```make clean```, ```make build``` and ```make upload``` at one time.
