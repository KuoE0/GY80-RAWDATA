#include <Wire.h> // enable to communicate with I2C / TWI devices
#include <L3G4200D.h>


void setup() {

	Serial.begin(9600);
	Wire.begin();
}


void loop() {

	Serial.println("Hello");
	delay(1000);

}

