// Generic Goldberg polyhedron of class I
// https://en.wikipedia.org/wiki/Goldberg_polyhedron#Class_I

// params to tweak
thick=10.01;
side = 10;
shell_thick = 2;
shell_dr = 10;
ring_thick = 3;

coeff_side_r = sqrt(10 + 22/sqrt(5))/4; // inner sphere radius to side ratio
penta_face_ang = acos(-1/sqrt(5));

// derived values
pent_a = 180 / 5;
hex_a = 180 / 6;
pent_r = side / (2*sin(pent_a));
hex_r = side / (2*sin(hex_a));

extra_k = 3.9; //6.5; //3.8; // 2.4
radius = side * coeff_side_r * extra_k;


module hex_tile(side = side, thick=thick, tile_a=0, tr_z=radius) {
    angles = [for (i = [0:5]) 30 + i*(2*hex_a)];
    coords = [for (th=angles) [hex_r * cos(th), hex_r * sin(th)]];
    translate([0, 0, tr_z])
    rotate([0, 0, tile_a])
    linear_extrude(thick)
        polygon(coords);
}


module pent_tile(side = side, thick=thick, tile_a=0, tr_z=radius) {
    angles = [for (i = [0:4]) i*(2*pent_a)];
    coords = [for (th=angles) [pent_r * cos(th), pent_r * sin(th)]];
    color("lightblue")
    translate([0, 0, tr_z])
    rotate([0, 0, tile_a])
    linear_extrude(thick)
        polygon(coords);
}


module dodecaeder(full = false) {
    pent_tile();

    // layer 1
    for (i = [0:4]) {
        rotate([0, -(180-penta_face_ang), 2*pent_a*i])
            pent_tile(tile_a=pent_a);
    }

    if (full) {
        pent_tile(tile_a=pent_a, tr_z=-radius);
        // layer 2 is a mirror of layer 1, rotated on pent_a
        mirror([0, 0, 1]) 
        rotate([0, 0, pent_a])
        {
            for (i = [0:4]) {
                rotate([0, -(180-penta_face_ang), 2*pent_a*i])
                    pent_tile(tile_a=pent_a);
            }
        }
    }
}

module pent_lines_half(n) {
    delta_a = (180 - penta_face_ang) / (n+1) + 1.2;
    for (j = [0:4])
    for (i = [1:n]) {
        rotate([0, 1.5-delta_a*i, 2*pent_a*j])
            hex_tile();
    }
    
    hor_a = pent_a / (n+1) - 0.5;
    dt_a = 2*pent_a / (n-1);
    corr_a = 3;
    
    for (j = [0:4])
    for (i = [0:n-1]) {
        rotate([0, -(180-penta_face_ang) + 4, 
                2*hor_a*(i+1) + corr_a*i + 2*pent_a*j])
            hex_tile(tile_a=pent_a - dt_a*i);
    }
    
    z_ang = 360 / 16 + 1.5;

    for (i = [0:15]) 
    rotate([0, (180-penta_face_ang) + delta_a - 6, i*z_ang])
        hex_tile(tile_a=hex_a);
}


module pent_fills_half(n) {
    for (i = [0:4])
        rotate([0, -(180-penta_face_ang)/2 - 6, pent_a + 2*pent_a*i])
            hex_tile(tile_a=hex_a);
    
}


module pent_lines(n) {
    pent_lines_half(n);
    rotate([0, 0, pent_a])
    mirror([0, 0, 1])
        pent_lines_half(n);
}

module ball() {
    dodecaeder();
    pent_lines_half(2);
    pent_fills_half(1);
}


module shell(dr=shell_dr) {
    difference() {
        sphere(radius + dr, $fn=100);
        sphere(radius + dr - shell_thick, $fn=100);
    }
}


module ring() {
    difference() {
        shell();
        translate([0, 0, -(radius + shell_dr)])
            cube((radius + shell_dr)*2, center=true);        
        translate([0, 0, (radius + shell_dr) + ring_thick])
            cube((radius + shell_dr)*2, center=true);        
    }
}


module diff_shell() {
    difference() {
        shell();
        ball();
        translate([0, 0, -(radius + shell_dr)])
            cube((radius + shell_dr)*2, center=true);        
    }
    ring();
}


diff_shell();
