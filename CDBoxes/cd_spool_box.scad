// CD Spool Box generator

// === Those parameters you can customize
// height of the box. Standard 25-disk spool has height of 40 mm
box_height = 20;

// thickness of walls, 1 mm is normally enough
wall_thick = 1;

// count of circular sections
circular_sections = 12;

// count of radial sections
radial_sections = 1;

// radius of the central box, set to 0 if not needed
central_r = 15;

// radius of outer-bottom wall rounding, set to 0 to disable
wall_round_r = 5;

// round parts precision, should be 100 or more for the final generation
$fn = 100;

// === Tweak only if neccessary (not needed for standard 25-CD spool)
// inner hole diameter
inner_d = 15;

// how much to lower the inner tube (needed for some 50-CD spools)
inner_tube_cut = 0;

// outer diameter of the box
outer_d = 119;
// === User customization ends here

module round_wall(diam, height=box_height) {
    difference() {
        cylinder(h=height, r = diam/2);
        translate([0, 0, -0.05])
            cylinder(h=height+0.1, r = diam/2-wall_thick);
    }
}


// rounding near the bottom
module bottom_rounding(radius) {
    translate([0, 0, wall_round_r + wall_thick])
    difference() {
        translate([0, 0, -wall_round_r])
        rotate_extrude() {
            translate([radius - wall_round_r, 0, 0]) {
                  square(wall_round_r);
            }
        }
        
        rotate_extrude() {
            translate([radius - wall_round_r, 0, 0]) {
                  circle(wall_round_r);
            }
        }
    }
}


// bottom
difference() {
    cylinder(h=wall_thick, r = outer_d/2);
    translate([0, 0, -0.05])
        cylinder(h=wall_thick+0.1, r = inner_d/2);
}

// outer wall
round_wall(diam=outer_d);

// inner wall
round_wall(diam=inner_d+wall_thick*2, height=box_height - inner_tube_cut);

// central box
if (central_r > 0) {
    round_wall(diam=inner_d + wall_thick*2 + central_r*2);
}

// circular walls
wall_angle = 360 / circular_sections;

for (i = [0:circular_sections-1]) {
    rotate([0, 0, i*wall_angle])
    translate([inner_d/2 + central_r, 0, 0])
        cube([outer_d/2 - central_r - inner_d/2, wall_thick, box_height]);
}

// radial walls
if (radial_sections > 1) {
    for (i = [0:radial_sections-2]) {
        r = (outer_d/2 - central_r - inner_d/2)*(i+1)/radial_sections;
        d = (central_r + r)*2 + inner_d;
        round_wall(diam=d);
        bottom_rounding(d/2);
    }
}


if (wall_round_r > 0) {
    // outer rounding
    bottom_rounding(outer_d/2);
    // central box rounding
    if (central_r > 0)
        bottom_rounding(inner_d/2 + central_r);
}