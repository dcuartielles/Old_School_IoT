# 2020 Ironland

This is the camping version of the Old-School-IoT project, written during a roadtrip to Sweden in the summer 2020. 

The code was created from the family tent and from a cabin in the Swedish Lappland. The first version of this tutorial was pushed from the Kraja camping at Arjeplog, a colorfull place by the largest lake in Sweden and just 50km away from the Polar Circle. I saw the midnight sun while making part of this code. If you have to focus, need silence, decent internet, and a sauna, this might be a place for you.

## Components

This example is made of a bit of Arduino code and a bit of Processing code. First you will have to program your MKR1010 + ENV Shield with the included firmware that will be sending data periodically over websocket to your computer. There the Processing sketch will set up a websocket server that will get the data and visualize it using simple linegraphs that include autoscaling. The code is made to be upgraded and to include zoom by making the data window a lot bigger than the width. Also the code could host multiple clients and therefore the UI is made a lot wider than the data represented. To build upon this work is entirely up to you ;-) 

I accept pull-requests.

## Needs

* Arduino MKR1010 (it would also work with the MKR1000)
* Arduino MKR ENV Shield, with temperature, humidity, barometric pressure, and different light sensors
* A working WiFi (you could make your own AP)
* One computer, I run Linux, but this code will work in other OSs
* BEWARE: if you have a restrictive firewall you might have to configure the port 8025 TCP/IP to be open for data

## Disclaimer

The code includes the password to the WiFi in the camping ... I left it in there for you to have one more reason to come by ... free WiFi!

## Credits

* S. Mistry: websockets code, ENV library
* T. Igoe: websockets examples
* B. Cuartielles: patience for letting me code during vacation time

## License

This code is in the public domain

(c) 2020 D. Cuartielles, Arjeplog, Lappland
