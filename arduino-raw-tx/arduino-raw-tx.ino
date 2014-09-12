#include <Wire.h> // enable to communicate with I2C / TWI devices
#include <L3G4200D.h> // gyroscope library
#include <ADXL345.h>  // accelerometer library
#include <HMC5883L.h> // digital compass library
#include <BMP085.h>   // barometric pressure & temperature sensor library

ADXL345 accel;
Vector raw, norm;

void setup() {

	Serial.begin(9600);
	Wire.begin();

	Serial.println("Initialize ADXL345...");
	if (!accel.begin()) {
		Serial.println("Initialize ADXL345 failed...");
		delay(1000);
	}

	accel.setRange(ADXL345_RANGE_2G);
	accel.setDataRate(ADXL345_DATARATE_100HZ);
}


void loop() {

	raw = accel.readRaw();

	Serial.print("RAW:  ");
	Serial.print(raw.XAxis);
	Serial.print("\t");
	Serial.print(raw.YAxis);
	Serial.print("\t");
	Serial.println(raw.ZAxis);

	delay(10);
}

