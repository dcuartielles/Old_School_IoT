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

int bID;
float temperature;
float humidity;
float pressure;
float illuminance;
float uva;
float uvb;
float uvIndex;
float cX = 0;

void setup() {
  size(800, 600);
  ws = new WebsocketServer(this, 8025, "/");
  now = millis();
}

void draw() {
  background(255);
  
  // print the info as text on the UI
  textSize(20);
  fill(0);  // black text
  text("temperature: " + temperature, 20, 40);
  text("humidity: " + humidity, 20, 65);
  text("pressure: " + pressure, 20, 90);
  text("illuminance: " + illuminance, 20, 115);
  text("uva: " + uva, 20, 140);
  text("uvb: " + uvb, 20, 165);
  text("uvIndex: " + uva, 20, 190);

  // ping
  if (millis() > now + PING_DELAY) {
    ws.sendMessage("ping");
    now = millis();
  }
}

void webSocketServerEvent(String msg) {
  println(msg);
  
  // split data
  String[] listData = split(msg, ',');

  // continue only if the amount of received
  // data is the one expected
  if (listData.length == 8) {
    // convert each data bit to the expected type
    bID = int(listData[0]);
    temperature = float(listData[1]);
    humidity = float(listData[2]);
    pressure = float(listData[3]);
    illuminance = float(listData[4]);
    uva = float(listData[5]);
    uvb = float(listData[6]);
    uvIndex = float(listData[7]);
  }
}
