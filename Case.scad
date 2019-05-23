//-----------------------------------------------------------------------------
// https://github.com/v42net/Digital-Clock/Case.scad               version 0.1
//-----------------------------------------------------------------------------

$fn = 12; // fix the number of fragments in a 360 degrees circle

wt = 1.05;  // wall thickness
ws = 0.25;  // wall spacing
ww = 10.5;  // weight width
wh = 4.0;   // weight height
hd = 1.0;   // mounting hole diameter (used for all mounting holes)

gs = 50.0;  // glass size (square)
gt = 2.5;   // glass thickness

dl = 50;    // display length
dw1 = 19;   // width of the display itself
dw2 = 27;   // width of the circuit board
dh1 = 7.5;  // height of the display itself
dh2 = 9.0;  // height of the display with circuit board
dx = 43.3;  // distance between center of mounting holes
dy = 22.74; // distance between center of mounting holes

ml = 48.4;  // MCU board length
mx = 20.5;  // MCU distance between center of mounting holes
my = 43.4;  // MCU distance between center of mounting holes
mh = 10.0;  // MCU mounting pillar height
md = 4.0;   // MCU mounting pillar diameter
mc = 10.0;  // MCU connector (center) above adapter surface (= 1.2 above board)

//-----------------------------------------------------------------------------

translate ([-60,0,0]) Front(); // front with plexiglass window
translate ([wt+ws,wt+ws,0]) Back(); // back with connection/ventilation holes
mirror ([0,1,0]) Mount(); // NodeMCU mounting adapter

//-----------------------------------------------------------------------------
module Front() {
	difference() {
		FrontBase();
		FrontHoles();
    }
}
module FrontBase() {
    o = 30 - gs/2; // offset of glass window
	s = 60 - 2 * wt; // inner size of cube
    translate ([wt,wt,wt]) {
        difference() {
            minkowski() {
                cube([s,s,s]);
                sphere(r=wt);
            }
            translate ([o-wt,o-wt,-ws-wt-wt]) cube([gs,gs,ws+wt+gt]); // glass window
            translate ([0,0,gt+wt]) cube([s,s,s]); // inside of cube
        }
    }
    o = 30 - dl/2; // offset of display
    translate ([o,o,gt]) cube([dl,dw2,dh1+ws]); // display
    translate ([o+6,o+3+dw2,gt]) cylinder (h=6,d=6.001); // light sensor
}
module FrontHoles() {
    x1 = 30 - dl/2 - ws; // offset of hole for display
    y1 = 30 - dl/2 - ws + (dw2-dw1)/2;
    z1 = gt - 0.001;
    translate ([x1,y1,z1]) cube ([dl+2*ws,dw1+2*ws,60]);
    
    x2 = 30 - dl/2 - ws; // offset of hole for display board
    y2 = 30 - dl/2 - ws;
    z2 = gt + dh1 + ws + 0.001;
    translate ([x2,y2,z2]) cube ([dl+2*ws,dw2+2*ws,60]);
    
    y3 = 30 - dl/2 + dw2/2; // center of the 4 mounting holes
    translate ([30-dx/2,y3-dy/2,gt+wt]) cylinder (h=60,d=hd+ws);
    translate ([30-dx/2,y3+dy/2,gt+wt]) cylinder (h=60,d=hd+ws);
    translate ([30+dx/2,y3-dy/2,gt+wt]) cylinder (h=60,d=hd+ws);
    translate ([30+dx/2,y3+dy/2,gt+wt]) cylinder (h=60,d=hd+ws);

    x3 = 30 - 12.5/2 - ws; // hole for display connector
    translate ([x3,y2,z2-3]) cube ([12.5,dw2+2*ws,60]);
    
    o = 30 - dl/2; // reference for hole for light sensor
    translate ([o+6,o+3+dw2]) cylinder (h=7+gt,d=3+ws);
}
module Back() {
	difference() {
		BackBase();
        BackVentilation();
		BackConnector();
    }
}
module BackBase() {
    x = 60-2*(wt+ws);
    y = 60-2*(wt+ws);
    z = 60-gt-wt; // no spacing ...
    difference() {
        cube([x, y, z]);
        translate ([wt,wt,wt]) cube([x-2*wt,y-2*wt,z]);
    }
    
    translate ([0,30-wt-ws-wt,0]) cube([x, wt, 10]); // stability ridge

    x1 = wh + wt + 1; // space for weights
    y1 = ww + wt + 1; 
    translate ([wt+wh,y-y1,0]) cube([1,y1,z-1]);
    translate ([x-2*wt-wh,y-y1,0]) cube([1,y1,z-1]);
    translate ([0,y-y1,0]) cube([x1,1,z-1]);
    translate ([x-x1,y-y1,0]) cube([x1,1,z-1]);
    
    y2 = y - 3*wt - 2*ws; // ridges for adapter
    translate ([wt+wh,y2,0]) cube([2+ws,1,z-1]);
    translate ([x-wt-wh-2-ws,y2,0]) cube([2+ws,1,z-1]);
}
module BackVentilation() {
    o = 6 - wt - ws; // position of the first ventilation hole
    for (y=[o:5:25]) for (x=[0:3:49]) 
        translate ([o+x,y,-1]) cylinder (h=wt+2,d=2+ws);
    for (y=[o+2.5:5:25]) for (x=[1.5:3:49]) 
        translate ([o+x,y,-1]) cylinder (h=wt+2,d=2+ws);
}
module BackConnector() {
    x1 = 8.0; // width of connector
    y1 = 3.0; // height of connector
    x2 = 30-wt-ws-x1/2-ws; // x center of connector
    y2 = wt+ws+wt+y1/2+ws+mc; // y center of connector
    translate ([x2,60-2*(wt+ws)-y2,0]) cube ([x1+2*ws,y1+2*ws,wt+2]);
}
module Mount() {
    x = 60-6*wt-4*ws-2*wh;
    y = 60-gt-wt-ws;
    translate ([(60-x)/2,0,0]) {
        cube ([x,y,wt]);
        translate ([1+ws,0,0]) cube ([1,y,wt+1+ws]); // ridge
        translate ([x-2-ws,0,0]) cube ([1,y,wt+1+ws]); // ridge
        translate ([x/2-mx/2,ml/2-ws-my/2,0]) MountStand();
        translate ([x/2-mx/2,ml/2-ws+my/2,0]) MountStand();
        translate ([x/2+mx/2,ml/2-ws-my/2,0]) MountStand();
        translate ([x/2+mx/2,ml/2-ws+my/2,0]) MountStand();
    }
}
module MountStand() {
    difference() {
        cylinder (h=wt+mh,d=md);
        cylinder (h=wt+mh+1,d=hd+ws);
    }
}
//-----------------------------------------------------------------------------
