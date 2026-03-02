// Computer leg from TPU
include <BOSL2/std.scad>

inner_d = 12.5;
outer_d = 20;
inner_h = 4;
outer_h = 10;
$fn = 100;

cylinder(h=outer_h, d=outer_d);

up(outer_h)
cylinder(h=inner_h, d=inner_d);
