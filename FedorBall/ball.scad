// params to tweak
thick=.01;
side = 10;
shell_thick = 2;
shell_dr = 4;


// empirical constants (would be great to have exact formulas)
coeff_side_r = 2.26;     // ratio between polygon side and final radius
coeff_pent_delta_side = 0.06;
ang1 = 37.4;
ang2 = 11.3;
ang3 = 4.5;

// derived values
pent_a = 180 / 5;
hex_a = 180 / 6;
pent_r = side / (2*sin(pent_a));
hex_r = side / (2*sin(hex_a));

radius = side * coeff_side_r;
pent_delta = side * coeff_pent_delta_side;

// https://math.stackexchange.com/questions/2029958/numbering-a-spherical-grid-of-pentagons-and-hexagons-so-neighbours-are-easily

// https://www.americanscientist.org/article/the-topology-and-combinatorics-of-soccer-balls#:~:text=Twelve%20pentagons%20and%2020%20hexagons,as%20the%20standard%20soccer%20ball.


module hex_tile(side = side, thick=thick, tile_a=0) {
    angles = [for (i = [0:5]) 30 + i*(2*hex_a)];
    coords = [for (th=angles) [hex_r * cos(th), hex_r * sin(th)]];
    rotate([0, 0, tile_a])
    linear_extrude(thick)
        polygon(coords);
}


module pent_tile(side = side, thick=thick, tile_a=0) {
    angles = [for (i = [0:4]) i*(2*pent_a)];
    coords = [for (th=angles) [pent_r * cos(th), pent_r * sin(th)]];
    color("lightblue")
    rotate([0, 0, tile_a])
    linear_extrude(thick)
        polygon(coords);
}


module ball() {
    // center
    translate([0, 0, radius+pent_delta])
        pent_tile();
    mirror([0, 0, 1])
    translate([0, 0, radius+pent_delta])
        pent_tile(tile_a=pent_a);

    // layer 1
    for (i = [0:4]) {
        rotate([0, -ang1, i*pent_a*2])
        translate([0, 0, radius])
            hex_tile();
        mirror([0, 0, 1])
        rotate([0, ang1, i*pent_a*2])
        translate([0, 0, radius])
            hex_tile();
    }    

    // center 2
    for (i = [1:2:9]) {
        rotate([0, -ang1*2+ang2, i*pent_a])
        translate([0, 0, radius+pent_delta])
            pent_tile();
        mirror([0, 0, 1])
        rotate([0, -ang1*2+ang2, (i-1)*pent_a])
        translate([0, 0, radius+pent_delta])
            pent_tile();
    }

    // layer 2
    for (i = [1:2:9]) {
        rotate([0, -ang1*2-ang3, pent_a*(i-1)])
        translate([0, 0, radius])
            hex_tile();
        mirror([0, 0, 1])
        rotate([0, -ang1*2-ang3, pent_a*i])
        translate([0, 0, radius])
            hex_tile();
    }
}


module shell(dr=shell_dr) {
    difference() {
        sphere(radius + dr, $fn=100);
        sphere(radius + dr - shell_thick, $fn=100);
    }
}


module diff_shell() {
    difference() {
        shell();
        ball();
    }
}


ball();
//diff_shell();