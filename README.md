# Digital Clock
A remote controlled digital clock, using a [NodeMCU](http://www.nodemcu.com/index_en.html) with a [4-Digit 7-Segment Display](https://www.adafruit.com/product/878).

For many years I've had two [DCF77](https://en.wikipedia.org/wiki/DCF77) controlled digital clocks. Signal reception has been degrading over the years, probably due to the growing amount of radio signals in the ether, and some time ago the first of those clocks failed completely. My first idea was to replace the internals with a NodeMCU and a display, but due to size restraints I decided to start from scratch, using a 3D-printed case with a plexiglass front that allows the digits to shine through while hiding the internals.

## The 3D-printed case

I've been experimenting with [OpenSCAD](http://www.openscad.org/) for some time, and I like it because (citing their website) 
*"it is something like a 3D-compiler that reads in a script file that describes the object and renders the 3D model from this script file"*. The result can be exported as an STL-file (or a number of other formats) for printing with your 3D printer of choice.

Please be aware that the design in [Case.scad](Case.scad) and the exported [Case.stl](Case.stl) have not been tested yet ...

## The software

The software is still in development and consists of two parts:
*  A PHP script on a webserver provides the NodeMCU with the time to be displayed.
*  The NodeMCU code that displays the time it is retrieving from the webserver.

More details, including my reasons for the two separate parts, will be published later.
