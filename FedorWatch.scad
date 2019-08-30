// Fedor watch ring
height = 6;
width = 24;
length = 8.5;
thick = 0.8;

use <scad-utils/morphology.scad>;

/*
difference() {
    cube([width, length, height]);
    translate([thick, thick, -0.1])
    cube([width - thick*2, length-thick*2, height + 0.2]);
}
*/

$fn = 100;
linear_extrude(height)
//fillet(r=0.6)
rounding(r=0.2)
difference() {
    square([width, length]);
    translate([thick, thick])
    square([width - thick*2, length - thick*2]);
}