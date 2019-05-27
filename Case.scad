//-----------------------------------------------------------------------------
// https://github.com/v42net/Digital-Clock/Cases.scad              version 0.2
//-----------------------------------------------------------------------------
// Configuration parameters:

$fn = 12; // fix the number of fragments in a 360 degrees circle

DC_wt = 1.05;   // Wall thickness
DC_bt = 1.40;   // Backwall thickness (fits USB connector)
DC_ws = 0.25;   // Wall spacing 
DC_sd = 2.00;   // Screw diameter
DC_hd = 1.50;   // Hole diameter (for screws)
DC_vd = 2.00;	// Venthole diameter (grid in back)

PW_xy = 50.0;   // Plexiglass window size
PW_z  = 2.5;    // Plexiglass window thickness

DS_l  = 50.2;   // Display lenght 
DS_h  = 8;      // Height of display
DS_wd = 19.0;   // Width of display
DS_wb = 27;     // Width of board
DS_hx = 43.3;   // distance between center of mounting holes
DS_hy = 22.74;  // distance between center of mounting holes

LS_h  = 6;      // Light sensor mount height
LS_ds = 3;      // diameter of light sensor
LS_dm = 6;      // diameter of mounting pillar

CW_wt = 1.05;   // Case weights - wall thickness
CW_wx = 4.0;    // Case weights - x size of a weight
CW_wy = 10.0;   // Case weights - y size of a weight

NM_bl = 48.4;   // NodeMCU board length
NM_dx = 20.5;   // X distance between center of mounting holes
NM_dy = 43.4;   // Y distance between center of mounting holes
NM_pd = 4.0;    // Diameter of mounting pillars
NM_ph = 10.0;   // Height of mounting pillars

NM_ch = 3.0;    // Height of micro-USB connector
NM_cw = 8.0;    // Width of micro-USB connector
NM_cv = -1.2;   // Vertical offset relative to bottom of board

//-----------------------------------------------------------------------------
// Calculated parameters:

OC_xyz = DS_l + 4*(DC_wt+DC_ws);    // Outer cube xyz sizes
OC_i   = OC_xyz - 2*DC_wt;          // Outer cube inside
IC_xy  = DS_l + 2*(DC_wt+DC_ws);    // Inner cube xy sizes
IC_z   = OC_xyz - PW_z - DC_wt - DC_ws; // Inner cube z size
IC_i   = IC_xy - 2*DC_wt;           // Inner cube xy inside
IC_iz  = IC_z  - DC_bt;             // Inner cube z inside

VH_hd  = DC_vd+DC_wt;               // H distance between center of ventholes
VH_hn  = floor (DS_l/VH_hd);	    // Horizontal number of ventholes
VH_tl  = (IC_xy-VH_hn*VH_hd)/2;     // Center position of topleft venthole
VH_vd  = VH_hd * 0.866;             // V distance between center of ventholes
VH_vn  = floor ((DS_l/2-DC_wt*2)/VH_vd); // Vertical number of ventholes

CW_iw  = DC_wt + CW_wy + 2*DC_ws + CW_wt;   // height of inner wall next to weight
CW_tw  = DC_wt + CW_wx + 2*DC_ws + CW_wt;   // width of top wall above the weight
CW_ix  = DC_wt + CW_wx + 2*DC_ws;           // x position of first inner wall
CW_x   = IC_xy-DC_wt-CW_wt-CW_wx-2*DC_ws;   // x position of both second walls
CW_y   = IC_xy - CW_iw;                     // y position of all of these walls

CW_rw  = 2*CW_wt + DC_ws;                   // width of ridges for MCU mount
CW_rx  = CW_x - CW_rw + CW_wt;              // x position second ridge
CW_ry  = IC_xy - 2*DC_wt - CW_wt - 2*DC_ws; // y position both ridges

NM_sw  = IC_xy - 2*CW_tw - 2* DC_ws;    // NodeMCU mounting surface width
NM_sl  = IC_iz - DC_ws;                 // NodeMCU mounting surface length
NM_cx  = NM_sw / 2;                     // NodeNCU x center position 
NM_cy  = NM_bl / 2 - DC_ws;             // NodeNCU y center position 

//-----------------------------------------------------------------------------
// Render the case:

Front();
Back();

// color ([1,0,0]) // for testing
// translate ([0, IC_xy, DC_bt+DC_ws])
// rotate ([-90,0,0]) mirror ([0,0,1])
Mount();

//-----------------------------------------------------------------------------
module Front() {

    translate ([DC_wt-OC_xyz,DC_wt,DC_wt]) {
        difference() {
            FrontBase();
            FrontHoles();
        }
    }
}
module FrontBase() {
    
    d = (OC_i - DS_l) / 2;      // xy offset of display mount
    p = (OC_i - PW_xy) / 2;     // xy offset of window
    sx = d + LS_dm;             // x offset of light sensor
    sy = d + DS_wb + LS_dm / 2; // y offset of light sensor
    z = PW_z - DC_wt + DC_ws;   // z offset of display mount & light sensor

    difference() {
        minkowski() {
            cube ([OC_i, OC_i, OC_i]);
            sphere (r=DC_wt);
        }
        rotate ([90,0,0]) translate ([OC_i/2,OC_i/2,-OC_i-DC_wt-1]) {
            cylinder (h=DC_wt+2,d=DC_sd); // bottom screw
        }
        translate ([p, p, -DC_wt]) cube ([PW_xy, PW_xy, PW_z]); // window
        translate ([0, 0, PW_z]) cube ([OC_i, OC_i, OC_i]); // inside
    }
    translate ([d, d, z]) cube ([DS_l, DS_wb, DS_h]); // display mount
    translate ([sx, sy, z]) cylinder (h=LS_h, d=LS_dm+0.001); // light sensor
}
module FrontHoles() {

    dl = DS_l + 2*DC_ws;                            // length of display hole
    dw = DS_wd + 2*DC_ws;                           // width of display hole
    dx = (OC_i - DS_l) / 2 - DC_ws;                 // x offset of display hole
    dy = (OC_i - DS_l + DS_wb - DS_wd) / 2 - DC_ws; // y offset of display hole
    dz = PW_z - DC_wt;                              // z offset of display hole

    cl = 30;                                        // length of connector hole
    cw = DS_wb + 2*DC_ws;                           // width of connector hole
    cx = (OC_i - cl) / 2;                           // x offset of connector hole
    cy = (OC_i - DS_l) / 2 - DC_ws;                 // y offset of connector hole
    cz = PW_z - DC_wt + DS_h / 2;                   // z offset of connector hole

    hh = OC_xyz;                                    // "height" of all holes
    hx = OC_i / 2;                                  // x-ref for mounting holes
    hy = (OC_i - DS_l + DS_wb) / 2;                 // y-ref for mounting holes

    sx = (OC_i - DS_l) / 2 + LS_dm;                 // x offset of light sensor
    sy = (OC_i - DS_l) / 2 + DS_wb + LS_dm / 2;     // y offset of light sensor
    
    translate ([cx, cy, cz]) cube ([cl, cw, hh]);        // hole for connector
    translate ([dx, dy, dz-0.001]) cube ([dl, dw, hh]);  // hole for display

    translate ([hx-DS_hx/2,hy-DS_hy/2,0]) cylinder (h=hh,d=DC_hd); // screw holes
    translate ([hx-DS_hx/2,hy+DS_hy/2,0]) cylinder (h=hh,d=DC_hd); // screw holes
    translate ([hx+DS_hx/2,hy-DS_hy/2,0]) cylinder (h=hh,d=DC_hd); // screw holes
    translate ([hx+DS_hx/2,hy+DS_hy/2,0]) cylinder (h=hh,d=DC_hd); // screw holes
   
    translate ([sx, sy, 0]) cylinder (h=hh, d=LS_ds); // hole for light sensor
}
module Back() {

    translate ([DC_wt + DC_ws, DC_wt + DC_ws, 0]) {
        difference() {
            BackBase();
            BackVents();
            BackConnector();
        }
    }
}
module BackBase() {

    difference() {
        cube ([IC_xy, IC_xy, IC_z]);
        translate ([DC_wt, DC_wt, DC_wt]) cube ([IC_i, IC_i, IC_z]);

        translate ([IC_xy/2, IC_xy+1, OC_xyz/2]) // bottom screw
            rotate ([90,0,0]) cylinder (h=DC_wt+2,d=DC_sd);
    }

    
    // ridge to strengthen the ventilation grid
    translate ([0,IC_xy/2-DC_wt,0]) cube ([IC_xy, DC_wt, DC_bt+2.5]);
    
    // walls around the two case weights (for stability)
    translate ([CW_ix,CW_y,0]) cube ([CW_wt,CW_iw,IC_z]);
    translate ([CW_x,CW_y,0]) cube ([CW_wt,CW_iw,IC_z]);
    translate ([0,CW_y,0]) cube ([CW_tw,CW_wt,IC_z]);
    translate ([CW_x,CW_y,0]) cube ([CW_tw,CW_wt,IC_z]);

    // ridges for the MCU mounting surface
    translate ([CW_ix,CW_ry,0]) cube ([CW_rw,CW_wt,IC_z]);
    translate ([CW_rx,CW_ry,0]) cube ([CW_rw,CW_wt,IC_z]);
}
module BackVents() {

    for (v = [1:2:VH_vn]) {
        y1 = VH_tl + VH_hd/2 + (v-1) * VH_vd;
        y2 = VH_tl + VH_hd/2 + v * VH_vd;
        for (h = [1:1:VH_hn]) {
            x1 = VH_tl + VH_hd/2 + (h-1) * VH_hd;
            x2 = VH_tl + VH_hd + (h-1) * VH_hd;
            translate ([x1,y1,-1]) cylinder (h=50,d=DC_vd);
            if ((h < VH_hn) && (v < VH_vn)) {
                translate ([x2,y2,-1]) cylinder (h=50,d=DC_vd);
            }
        }
    }
    
}
module BackConnector() {

    w = NM_cw + 2*DC_ws;
    h = NM_ch + 2*DC_ws;
    x = (IC_xy - w)/2;
    y = IC_xy - h - 2*DC_wt - NM_ph - NM_cv + NM_ch/2;

    translate ([x,y,-1]) cube ([w, h, 50]);
}
module Mount() {
    mirror ([0,1,0]) translate ([DC_wt + 2*DC_ws + CW_tw,0,0]) {
        difference() {
            MountBase();
            MountHoles();
        }
    }
}
module MountBase() {
    cube ([NM_sw, NM_sl, DC_wt]);
    // cube ([NM_sw, DC_wt, DC_wt+NM_ph]); // to check the orientation

    // Positioning ridges
    translate ([CW_wt+DC_ws,0,0]) cube ([CW_wt, NM_sl, DC_wt+CW_wt+DC_ws]);
    translate ([NM_sw-2*CW_wt-DC_ws,0,0]) cube ([CW_wt, NM_sl, DC_wt+CW_wt+DC_ws]);
    
    // NodeMCU mounting pillars
    translate ([NM_cx-NM_dx/2, NM_cy-NM_dy/2, 0]) cylinder (d=NM_pd, h=DC_wt+NM_ph);
    translate ([NM_cx-NM_dx/2, NM_cy+NM_dy/2, 0]) cylinder (d=NM_pd, h=DC_wt+NM_ph);
    translate ([NM_cx+NM_dx/2, NM_cy-NM_dy/2, 0]) cylinder (d=NM_pd, h=DC_wt+NM_ph);
    translate ([NM_cx+NM_dx/2, NM_cy+NM_dy/2, 0]) cylinder (d=NM_pd, h=DC_wt+NM_ph);
    
    // Bottom screw
    translate ([NM_sw/2, OC_xyz/2 - DC_bt - DC_ws, 0]) cylinder (h=5,d=5);
}
module MountHoles() {

    translate ([NM_cx-NM_dx/2, NM_cy-NM_dy/2, -1]) cylinder (d=DC_hd, h=DC_wt+NM_ph+2);
    translate ([NM_cx-NM_dx/2, NM_cy+NM_dy/2, -1]) cylinder (d=DC_hd, h=DC_wt+NM_ph+2);
    translate ([NM_cx+NM_dx/2, NM_cy-NM_dy/2, -1]) cylinder (d=DC_hd, h=DC_wt+NM_ph+2);
    translate ([NM_cx+NM_dx/2, NM_cy+NM_dy/2, -1]) cylinder (d=DC_hd, h=DC_wt+NM_ph+2);
    
    translate ([NM_sw/2, OC_xyz/2 - DC_bt - DC_ws, -1]) cylinder (h=7,d=DC_hd);
}
//-----------------------------------------------------------------------------































