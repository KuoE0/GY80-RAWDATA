#include <Wire.h> // enable to communicate with I2C / TWI devices
#include <L3G4200D.h> // gyroscope library
#include <ADXL345.h>  // accelerometer library
#include <HMC5883L.h> // digital compass library
#include <BMP085.h>   // barometric pressure & temperature sensor library
#include <Timer.h>

ADXL345 accel;
L3G4200D gyro;
Vector raw_acc, raw_gyr;
Timer tcb;

void setup() {

	Serial.begin(115200);
	Wire.begin();

	Serial.println("Initialize ADXL345...");
	if (!accel.begin()) {
		Serial.println("Initialize ADXL345 failed...");
		delay(1000);
	}

	if (!gyro.begin(L3G4200D_SCALE_2000DPS, L3G4200D_DATARATE_200HZ_50)) {
		Serial.println("Initialize L3G4200D failed...");
		delay(1000);
	}

	accel.setRange(ADXL345_RANGE_2G);
	accel.setDataRate(ADXL345_DATARATE_200HZ);

	tcb.every(5, updateSample); // 200Hz
}


void loop() {

	tcb.update();
}

void updateSample() {
	raw_acc = accel.readRaw();
	raw_gyr = gyro.readRaw();

	Serial.print(raw_acc.XAxis);
	Serial.print(":");
	Serial.print(raw_acc.YAxis);
	Serial.print(":");
	Serial.print(raw_acc.ZAxis);
	Serial.print(":");
	Serial.print(raw_gyr.XAxis);
	Serial.print(":");
	Serial.print(raw_gyr.YAxis);
	Serial.print(":");
	Serial.println(raw_gyr.ZAxis);

}

