height = 16;
wall_outer_thickness = 2;
base_thickness = 1;
wall_inner_thickness = 1;
slots_x = 5;
slots_y = 3;

$fn = 20;
pin_diameter = 3;
pin_height = 3;
pin_hole_diameter = 3.5;
pin_hole_height = 10;
corner_outer_diameter = 6;
base_side = 80;
base_size = [base_side, base_side, height];

function corner_coords(i, j) = [
    i * base_side + (1/2-i)*wall_outer_thickness, 
    j * base_side + (1/2-j)*wall_outer_thickness, 
    0];

module corner(i, j) {
    translate(corner_coords(i, j))
        {
            cylinder(h = height, d = corner_outer_diameter);
            translate([0, 0, height]) {
                cylinder(h = pin_height, d = pin_diameter);
                translate([0, 0, pin_height])
                    sphere(d = pin_diameter);
            }
        }
}

module pin_hole(i, j) {
    translate(corner_coords(i, j))
        translate([0, 0, -1])
            cylinder(h = pin_hole_height+1, d = pin_hole_diameter);
}

union() {
    difference() {
        union() {
            difference() {
                cube(base_size, center = false);
                translate([wall_outer_thickness, wall_outer_thickness, base_thickness])
                    cube(base_size - [wall_outer_thickness*2, wall_outer_thickness*2, 0]);
            }
            corner(0, 0);
            corner(0, 1);
            corner(1, 0);
            corner(1, 1);
        }
        pin_hole(0, 0);
        pin_hole(1, 0);
        pin_hole(0, 1);
        pin_hole(1, 1);
    }
}

inner_space = base_side - wall_outer_thickness*2 + wall_inner_thickness;
x_ofs = inner_space / slots_x;
y_ofs = inner_space / slots_y;
translate([wall_outer_thickness, 0, 0])
    for (i = [1:slots_x-1]) {
        translate([i*x_ofs - wall_inner_thickness, 0, 0])
            cube([wall_inner_thickness, base_side, height]);
    }

translate([0, wall_outer_thickness, 0])
    for (i = [1:slots_y-1]) {
        translate([0, i*y_ofs - wall_inner_thickness, 0])
            cube([base_side, wall_inner_thickness, height]);
    }