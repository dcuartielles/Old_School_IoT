/*
  ENV Shield WebSocket client

  Connects to the WebSocket server, and sends a hello
  message every 5 seconds

  (c) 2020 D. Cuartielles

  Based on work by S. Mistry and T. Igoe

  this example is in the public domain
*/

#include <ArduinoHttpClient.h>
#include <WiFiNINA.h>
#include "arduino_secrets.h"
#include <Arduino_MKRENV.h>

// Wifi Settings
char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;

char serverAddress[] = "172.21.2.64";  // server address
int port = 8025;

WiFiClient wifi;
WebSocketClient client = WebSocketClient(wifi, serverAddress, port);
int status = WL_IDLE_STATUS;

void setup() {
  Serial.begin(9600);

  while (!Serial);

  // init ENV Shield
  if (!ENV.begin()) {
    Serial.println("Failed to initialize MKR ENV shield!");
    while (1);
  }

  // init WiFi
  while ( status != WL_CONNECTED) {
    Serial.print("Attempting to connect to Network named: ");
    Serial.println(ssid);                   // print the network name (SSID);

    WiFi.disconnect();
    // Connect to WPA/WPA2 network:
    status = WiFi.begin(ssid, pass);
  }

  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);
}

void loop() {
  // proceed to sending data to Websocket
  if (WiFi.status() == WL_DISCONNECTED) status = WiFi.begin(ssid, pass);
  Serial.println("starting WebSocket client");
  client.begin();

  while (client.connected()) {
    Serial.print("Sending sensor data");

    // read all the sensor values
    float temperature = ENV.readTemperature();
    float humidity    = ENV.readHumidity();
    float pressure    = ENV.readPressure();
    float illuminance = ENV.readIlluminance();
    float uva         = ENV.readUVA();
    float uvb         = ENV.readUVB();
    float uvIndex     = ENV.readUVIndex();

    // print sensor data to Serial
    Serial.print("Temperature = ");
    Serial.print(temperature);
    Serial.println(" °C");

    Serial.print("Humidity    = ");
    Serial.print(humidity);
    Serial.println(" %");

    Serial.print("Pressure    = ");
    Serial.print(pressure);
    Serial.println(" kPa");

    Serial.print("Illuminance = ");
    Serial.print(illuminance);
    Serial.println(" lx");

    Serial.print("UVA         = ");
    Serial.println(uva);

    Serial.print("UVB         = ");
    Serial.println(uvb);

    Serial.print("UV Index    = ");
    Serial.println(uvIndex);

    // print an empty line
    Serial.println();


    // send data as a comma separated string
    client.beginMessage(TYPE_TEXT);
    client.print(temperature);
    client.print(',');
    client.print(humidity);
    client.print(',');
    client.print(pressure);
    client.print(',');
    client.print(illuminance);
    client.print(',');
    client.print(uva);
    client.print(',');
    client.print(uvb);
    client.print(',');
    client.print(uvIndex);
    client.endMessage();

    // check if a message is available to be received
    int messageSize = client.parseMessage();

    if (messageSize > 0) {
      Serial.println("Received a message:");
      Serial.println(client.readString());
    }

    // wait 5 seconds
    delay(5000);
  }

  Serial.println("disconnected");
}
