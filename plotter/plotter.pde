/*
 * =============================================================================
 *   FileName: processing-raw-plot.pde
 *       Desc: Processing code for plot GY-80 raw data
 *     Author: KuoE0
 *      Email: kuoe0.tw@gmail.com
 *   HomePage: http://kuoe0.ch/
 * LastChange: 2014-09-12 16:56:31
 *=============================================================================
 */

import processing.serial.*;

Serial myPort;
final int MAX_SAMPLE = 400;

int update_ptr = MAX_SAMPLE;
float[] accel_x = new float[MAX_SAMPLE];
float[] accel_y = new float[MAX_SAMPLE];
float[] accel_z = new float[MAX_SAMPLE];

int WINDOW_WIDTH = 800, WINDOW_HEIGHT = 600;
int WINDOW_PADDING = 20;
int CHART_CARD_WIDTH = 480, CHART_CARD_HEIGHT = WINDOW_HEIGHT - WINDOW_PADDING * 2;
int CHART_INTERVAL = 50, CHART_WIDTH = MAX_SAMPLE, CHART_HEIGHT = CHART_INTERVAL * 8;
color CLR_ACCEL_X = #FF5722, CLR_ACCEL_Y = #259B24, CLR_ACCEL_Z = #03A9F4;
color CLR_GYRO_X = #E51C23, CLR_GYRO_Y = #5677FC, CLR_GYRO_Z = #009688;
color CLR_MAGN_X = #795548, CLR_MAGN_Y = #FFC107, CLR_MAGN_Z = #9C27B0;

PFont font;
PGraphics pg_chart, pg_legend;

void setup() {

	size(WINDOW_WIDTH, WINDOW_HEIGHT); // init window size

	int port_idx = get_arduino_dev();

	if (port_idx != -1) {
		String portName = Serial.list()[port_idx];
		myPort = new Serial(this, portName, 19200);
		myPort.clear();
		// myPort.bufferUntil(lf);
		// There are six signals to receive. Two bytes for each signal.
		myPort.buffer(16);
	}

	font = createFont("HelveticaNeue-Light", 22, true);
	textFont(font);

	for (int i = 0; i < MAX_SAMPLE; ++i) {
		accel_x[i] = accel_y[i] = accel_z[i] = 0;
	}
}

void draw() {
	background(225);

	draw_chart();
	gen_random_signal();
	delay(10);
}

// search for the Arduino device
int get_arduino_dev() {

	println(Serial.list());
	for (int i = 0; i < Serial.list().length; ++i) {
		// find name Arduino device
		String[] ret = match(Serial.list()[i], "tty.usbmodem");
		if (ret != null) {
			println("Found " + Serial.list()[i] + "!");
			return i;
		}
	}
	return -1;
}

void card(int x, int y, int width, int height) {

	int x1 = x, y1 = y, x2 = x + width, y2 = y + height;

	// card
	noStroke();
	fill(255);
	rectMode(CORNERS);
	rect(x1, y1, x2, y2);

	// right-bottom shadow
	stroke(200);
	line(x2 + 1, y1, x2 + 1, y2);
	line(x1, y2 + 1, x2, y2 + 1);

	// border shadow
	stroke(220);
	line(x1, y1 - 1, x2, y1 - 1);
	line(x1 - 1, y1, x1 - 1, y2);
	line(x2 + 2, y1, x2 + 2, y2);
	line(x1, y2 + 2, x2, y2 + 2);

}

void draw_chart() {

	// draw card
	card(WINDOW_PADDING, WINDOW_PADDING, CHART_CARD_WIDTH, CHART_CARD_HEIGHT);

	// draw unit
	fill(33);
	textSize(16);
	textAlign(RIGHT, CENTER);
	text(str(0), WINDOW_PADDING * 3.5, WINDOW_PADDING * 3 + CHART_INTERVAL * 4);
	for (int i = 1; i <= 4; ++i) {
		text(str(128 * i), WINDOW_PADDING * 3.5, WINDOW_PADDING * 3 + CHART_INTERVAL * (4 - i));
		text(str(-128 * i), WINDOW_PADDING * 3.5, WINDOW_PADDING * 3 + CHART_INTERVAL * (4 + i));
	}

	// draw chart
	pg_chart = createGraphics(CHART_WIDTH, CHART_HEIGHT + 1);
	pg_chart.beginDraw();
	pg_chart.background(255);
	pg_chart.translate(0, CHART_HEIGHT / 2);

	pg_chart.stroke(225);
	pg_chart.line(0, 0, CHART_WIDTH, 0);
	for (int i = 1; i <= 4; ++i) {
		pg_chart.line(0, CHART_INTERVAL * i, CHART_WIDTH, CHART_INTERVAL * i);
		pg_chart.line(0, -CHART_INTERVAL * i, CHART_WIDTH, -CHART_INTERVAL * i);
	}

	for (int i = 0; i < MAX_SAMPLE / 2 - 1; ++i) {
		int p1 = (i + update_ptr - MAX_SAMPLE / 2 + MAX_SAMPLE) % MAX_SAMPLE;
		int p2 = (i + update_ptr - MAX_SAMPLE / 2 + 1 + MAX_SAMPLE) % MAX_SAMPLE;
		
		// x-axis acceleration
		pg_chart.stroke(CLR_ACCEL_X);
		pg_chart.line(i * 2, -accel_x[p1] * 50 / 128, i * 2 + 1, -accel_x[p2] * 50 / 128);
		// y-axis acceleration
		pg_chart.stroke(CLR_ACCEL_Y);
		pg_chart.line(i * 2, -accel_y[p1] * 50 / 128, i * 2 + 1, -accel_y[p2] * 50 / 128);
		// z-axis acceleration
		pg_chart.stroke(CLR_ACCEL_Z);
		pg_chart.line(i * 2, -accel_z[p1] * 50 / 128, i * 2 + 1, -accel_z[p2] * 50 / 128);
	}

	pg_chart.endDraw();

	// put chart
	image(pg_chart, WINDOW_PADDING * 4, WINDOW_PADDING * 2.5);

	pg_legend = createGraphics(440, 100);
	pg_legend.beginDraw();
	pg_legend.background(255);
	pg_legend.translate(pg_legend.width / 2, pg_legend.height / 2);

	pg_legend.rectMode(CORNERS);
	pg_legend.noStroke();
	pg_legend.textAlign(LEFT, CENTER);

	// acceleromter
	pg_legend.fill(CLR_ACCEL_X);
	pg_legend.rect(-5 - 30 - 140, -25, 5 - 30 - 140, -35);
	pg_legend.text("ACCEL_X", -20 - 140, -30 - 2);

	pg_legend.fill(CLR_ACCEL_Y);
	pg_legend.rect(-5 - 30 - 140, 5, 5 - 30 - 140, -5);
	pg_legend.text("ACCEL_Y", -20 - 140, 0 - 2);

	pg_legend.fill(CLR_ACCEL_Z);
	pg_legend.rect(-5 - 30 - 140, 35, 5 - 30 - 140, 25);
	pg_legend.text("ACCEL_Z", -20 - 140, 30 - 2);

	// gyroscope
	pg_legend.fill(CLR_GYRO_X);
	pg_legend.rect(-5 - 30, -25, 5 - 30, -35);
	pg_legend.text("GYRO_X", -20, -30 - 2);

	pg_legend.fill(CLR_GYRO_Y);
	pg_legend.rect(-5 - 30, 5, 5 - 30, -5);
	pg_legend.text("GYRO_Y", -20, 0 - 2);

	pg_legend.fill(CLR_GYRO_Z);
	pg_legend.rect(-5 - 30, 35, 5 - 30, 25);
	pg_legend.text("GYRO_Z", -20, 30 - 2);

	// magnetometer
	pg_legend.fill(CLR_MAGN_X);
	pg_legend.rect(-5 - 30 + 140, -25, 5 - 30 + 140, -35);
	pg_legend.text("MAGN_X", -20 + 140, -30 - 2);

	pg_legend.fill(CLR_MAGN_Y);
	pg_legend.rect(-5 - 30 + 140, 5, 5 - 30 + 140, -5);
	pg_legend.text("MAGN_Y", -20 + 140, 0 - 2);

	pg_legend.fill(CLR_MAGN_Z);
	pg_legend.rect(-5 - 30 + 140, 35, 5 - 30 + 140, 25);
	pg_legend.text("MAGN_Z", -20 + 140, 30 - 2);

	pg_legend.endDraw();

	// put legend
	image(pg_legend, WINDOW_PADDING * 2, WINDOW_PADDING * 3.5 + CHART_HEIGHT);

}

void gen_random_signal() {

	float x = random(-100, 100);
	float y = random(200, 300);
	float z = random(-300, -200);

	if (update_ptr >= MAX_SAMPLE)
		update_ptr = 0;

	accel_x[update_ptr] = x;
	accel_y[update_ptr] = y;
	accel_z[update_ptr] = z;

	++update_ptr;

}


