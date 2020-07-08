/*
  WebSocket server with simple Dataviz
 
 Pings every 5 seconds to clients
 
 Gets data from clients and splits the arrays
 (that should be properly formatted) as a way
 to simplify visualizing the information
 
 (c) 2020 D. Cuartielles, Arjeplog, Lappland
 
 this example is in the public domain
 */

import websockets.*;

WebsocketServer ws;
long now;
long PING_DELAY = 5000;

boolean newData = false;
int bID;

// let's make the data into arrays of a certain size
int dataWidth = 4 * width; // make it multiple of the WIDTH
float temperature[] = new float[dataWidth];
float humidity[] = new float[dataWidth];
float pressure[] = new float[dataWidth];
float illuminance[] = new float[dataWidth];
float uva[] = new float[dataWidth];
float uvb[] = new float[dataWidth];
float uvIndex[] = new float[dataWidth];

// determine the color for each data field
color cTemperature = color(255, 0, 0);
color cHumidity = color(0, 255, 0);
color cPressure = color(0, 0, 255);
color cIlluminance = color(150, 150, 150);
color cUva = color(115, 115, 115);
color cUvb = color(80, 80, 80);
color cUvIndex = color(50, 50, 50);

// indexes to handle the data
int nIndex = 0; // navigation
int wIndex = 0; // writing pointer

void setup() {
  size(800, 600);
  ws = new WebsocketServer(this, 8025, "/");
  now = millis();
}

void draw() {
  background(255);

  // print incoming data only after having got data for the first time
  if (wIndex > 0) {
    printDataToScreen(20, 40);
  } else  {
    fill(0);
    textSize(20);
    text("NO DATA", 20, 40);
  }

  // represent the graphs
  drawGraph(temperature, cTemperature, 20, 300, 200, 40, nIndex);
  drawGraph(humidity, cHumidity, 20, 345, 200, 40, nIndex);
  drawGraph(pressure, cPressure, 20, 390, 200, 40, nIndex);
  drawGraph(illuminance, cIlluminance, 20, 435, 200, 40, nIndex);
  drawGraph(uva, cUva, 20, 480, 200, 40, nIndex);
  drawGraph(uvb, cUvb, 20, 525, 200, 40, nIndex);
  drawGraph(uvIndex, cUvIndex, 20, 570, 200, 40, nIndex);

  // ping
  if (millis() > now + PING_DELAY) {
    ws.sendMessage("ping");
    now = millis();
  }
}

void webSocketServerEvent(String msg) {
  print(msg);

  // split data
  String[] listData = split(msg, ',');

  // continue only if the amount of received
  // data is the one expected
  if (listData.length == 8) {
    // notify data is Ok
    println(", Ok " + wIndex);
    
    // convert each data bit to the expected type
    bID = int(listData[0]);
    temperature[wIndex] = float(listData[1]);
    humidity[wIndex] = float(listData[2]);
    pressure[wIndex] = float(listData[3]);
    illuminance[wIndex] = float(listData[4]);
    uva[wIndex] = float(listData[5]);
    uvb[wIndex] = float(listData[6]);
    uvIndex[wIndex] = float(listData[7]);

    // increase wIndex
    wIndex++;

    // our array is a round window, when reaching the end, restart
    if (wIndex >= dataWidth) wIndex = 0;
  } else {
    // notify data is NOT Ok
    println(", not Ok");
  }
}

void printDataToScreen(int xOffset, int yOffset) {
  // print the info as text on the UI
  // add a small square just before to show the legend
  int fontSize = 20;
  int rectSize = 10;

  // correct the offsets
  xOffset += rectSize + 5;
  yOffset += fontSize; // balance the offset to the typeface size

  textSize(fontSize);

  noStroke(); // no external line
  fill(cTemperature);
  rect(xOffset - rectSize - 5, yOffset - rectSize, rectSize, rectSize);
  fill(0);  // black text
  text("temperature: " + temperature[wIndex - 1], xOffset, yOffset);
  fill(cHumidity);
  rect(xOffset - rectSize - 5, yOffset - rectSize + fontSize + 5, rectSize, rectSize);
  fill(0);  // black text
  text("humidity: " + humidity[wIndex - 1], xOffset, yOffset + fontSize + 5);
  fill(cPressure);
  rect(xOffset - rectSize - 5, yOffset - rectSize + 2*(fontSize + 5), rectSize, rectSize);
  fill(0);  // black text
  text("pressure: " + pressure[wIndex - 1], xOffset, yOffset + 2*(fontSize + 5));
  fill(cIlluminance);
  rect(xOffset - rectSize - 5, yOffset - rectSize + 3*(fontSize + 5), rectSize, rectSize);
  fill(0);  // black text
  text("illuminance: " + illuminance[wIndex - 1], xOffset, yOffset + 3*(fontSize + 5));
  fill(cUva);
  rect(xOffset - rectSize - 5, yOffset - rectSize + 4*(fontSize + 5), rectSize, rectSize);
  fill(0);  // black text
  text("uva: " + uva[wIndex - 1], xOffset, yOffset + 4*(fontSize + 5));
  fill(cUvb);
  rect(xOffset - rectSize - 5, yOffset - rectSize + 5*(fontSize + 5), rectSize, rectSize);
  fill(0);  // black text
  text("uvb: " + uvb[wIndex - 1], xOffset, yOffset + 5*(fontSize + 5));
  fill(cUvIndex);
  rect(xOffset - rectSize - 5, yOffset - rectSize + 6*(fontSize + 5), rectSize, rectSize);
  fill(0);  // black text
  text("uvIndex: " + uvIndex[wIndex - 1], xOffset, yOffset + 6*(fontSize + 5));
}

void drawGraph(float data[], color cData, int xOffset, int yOffset, 
  int maxX, int maxY, int nIndex) {

  // create temporary array of data
  float temp[] = new float[dataWidth];

  // copy the data
  //temp = data;
  for (int i = 0; i < dataWidth; i++) {
    temp[i] = data[i];
  }

  // normalize the data, first get the max on the current set
  float maxData = -1000;
  for (int i = 0; i < dataWidth; i++) {
    maxData = max(maxData, temp[i]);
  }

  // normalize the data, adjust the representation range to correspond to maxY
  for (int i = 0; i < dataWidth; i++) {
    temp[i] = map(temp[i], 0, maxData, 0,  maxY);
  }

  // represent the data
  stroke(cData);
  strokeWeight(1);
  for (int i = 0; i < maxX; i++) {
    line(xOffset + i, - temp[i] + yOffset, xOffset + i + 1, - temp[i+1] + yOffset);
  }
}
