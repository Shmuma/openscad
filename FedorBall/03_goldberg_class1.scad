// Generic Goldberg polyhedron of class I
// https://en.wikipedia.org/wiki/Goldberg_polyhedron#Class_I

// params to tweak
thick=.01;
side = 10;
shell_thick = 2;
shell_dr = 4;

coeff_side_r = sqrt(10 + 22/sqrt(5))/4; // inner sphere radius to side ratio
penta_face_ang = acos(-1/sqrt(5));

// derived values
pent_a = 180 / 5;
hex_a = 180 / 6;
pent_r = side / (2*sin(pent_a));
hex_r = side / (2*sin(hex_a));

extra_k = 3.8; //6.5; //3.8; // 2.4
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


module dodecaeder() {
    pent_tile();

    // layer 1
    for (i = [0:4]) {
        rotate([0, -(180-penta_face_ang), 2*pent_a*i])
            pent_tile(tile_a=pent_a);
    }

    translate([0, 0, -radius])
    pent_tile(tile_a=pent_a);

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

module pent_lines_half(n) {
    delta_a = (180 - penta_face_ang) / (n+1);
    for (j = [0:4])
    for (i = [1:n]) {
        rotate([0, -delta_a*i, 2*pent_a*j])
            hex_tile();
    }
    
    hor_a = pent_a / (n+1);
    dt_a = 2*pent_a / (n-1);
    
    for (j = [0:4])
    for (i = [1:n]) {
        rotate([0, -(180-penta_face_ang)+5, 2*hor_a*i + 2*pent_a*j])
            hex_tile(tile_a=pent_a - dt_a*(i-1));
    }
    
    
    hex_tile();
}

module pent_lines(n) {
    pent_lines_half(n);
    rotate([0, 0, pent_a])
    mirror([0, 0, 1])
        pent_lines_half(n);
}

dodecaeder();
pent_lines(2);
