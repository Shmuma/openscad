base_width = 55;
base_length = 20;
base_thick = 3;
base_leg_ofs = 15;

leg_hole_extra = 0.4;
leg_dim = 2;
leg_x_ofs = 3;
leg_len = 25;

module base() {
    cube([base_width, base_length, base_thick]);
    
    translate([base_leg_ofs + leg_dim, 0, base_thick])
    cube([leg_dim, base_length, leg_dim]);
    
    translate([base_width - base_leg_ofs - leg_dim, 0, base_thick])
    cube([leg_dim, base_length, leg_dim]);
}



module leg() {
    difference() {
        cube([base_length+leg_dim*2, base_thick+leg_dim*2, leg_dim]);
        translate([leg_dim-leg_hole_extra/2, leg_dim-leg_hole_extra/2, -0.1])
        cube([base_length+leg_hole_extra, base_thick+leg_hole_extra, leg_dim + 0.2]);
    }
    
    translate([leg_x_ofs, base_thick+leg_dim*2, 0])
    cube([leg_dim, leg_len, leg_dim]);
}

base();

translate([0, base_length*2, 0])
leg();

translate([base_length*2, base_length*2, 0])
leg();