// -1 for the left side, 1 for the right, 0 for the middle
piece_side = 1;

// 18 is the limit for my table
cd_count = 18;
rail_thick = 3;
rail_height = 10;
cd_thick = 11.5;

width = 20;
length = (cd_thick + rail_thick)*cd_count + rail_thick;
height = 23;
bot_ofs = 2.3;
// 2.6, 4.6, 21 -> sin(a) = 2/21 a = 5.5 degree
angle = 5.5;
ofs = 0.2;

screw_hole_indices = [1, 3, 14, 16];
screw_d = 3;
screw_head_d = 5;
screw_gap_len = 5;
$fn = 50;

echo("Total length = ", length);

module base() { 
    cube([width, length, height]);
}


module disk() {
    translate([0, bot_ofs, bot_ofs])
    rotate([-angle, 0, 0])
    translate([-ofs, 0, 0])
        cube([width + ofs*2, cd_thick, height]);
}

module screw_hole(idx) {
    translate([width/2, rail_thick + cd_thick/2 + idx*(rail_thick + cd_thick), -ofs]) {
        cylinder(h = height, r = screw_d/2);

        translate([0, 0, rail_thick/4])
        cylinder(rail_thick/2, screw_d/2, screw_head_d/2);        
    }
}

module screw_gap(idx) {
    hull() {
        translate([-screw_gap_len/2, 0, 0])
            screw_hole(idx);
        translate([screw_gap_len/2, 0, 0])
            screw_hole(idx);
    }
}


module base_with_cds() {
    difference() {
        base();
        
        union() {
            for (i = [0:cd_count-1])
                translate([0, i*(cd_thick + rail_thick), 0])
                    disk();
        }
    }
}



difference() {
    union() {
        base_with_cds();
        translate([(width/2 - rail_thick/2)*(piece_side + 1), 0, 0])
            cube([rail_thick, length, rail_height]);
    }
        
    for (idx = screw_hole_indices) 
        screw_gap(idx);
}