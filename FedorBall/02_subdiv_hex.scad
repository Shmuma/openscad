// subdividing hexagonal tiles to get more holes
// params to tweak
thick=.01;
side = 10;
shell_thick = 2;
shell_dr = 4;
hex_layers = 2;


// empirical constants (would be great to have exact formulas)
coeff_side_r = 2.35*hex_layers;     // ratio between polygon side and final radius
coeff_pent_delta_side = 0.03;
ang1 = 37.4;
ang2 = 11.3;
ang3 = 4.5;

// derived values
pent_a = 180 / 5;
hex_a = 180 / 6;

// radius and height of the right pentagone
pent_r = side / (2*sin(pent_a));
pent_h = pent_r * sin(54);

// radius and height of the right hexagone
hex_r = side / (2*sin(hex_a));
hex_h = hex_r * sin(60);

// angles of the various parts of the tiling
// TODO: fix those calculations for subdivided case
perimeter = 2*(pent_h + 4*hex_h*hex_layers + pent_h + pent_r + side + pent_r);
side_a = 360 * side / perimeter;
pent_r_a = 360 * pent_r / perimeter;
pent_h_a = 360 * pent_h / perimeter;
hex_r_a = 360 * hex_r / perimeter;
hex_h_a = 360 * hex_h / perimeter;

// radius of the sphere we're tiling
radius = side * coeff_side_r;
radius2 = perimeter / PI;
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


// triangle made from hexagonal tiles
module hex_triag(layers = hex_layers) {
    
    for (layer = [0:layers-1]) {
        echo("Layer", layer);
        rotate([0, -pent_h - hex_h - 2*hex_h*layer, 0])
        translate([0, 0, radius2])
            hex_tile();

        for (t = [0:layer+1]) {
            echo("Tile", t);
            
        }
    }
}


module ball() {
    // center
    translate([0, 0, radius2+pent_delta])
        pent_tile();
/*
    mirror([0, 0, 1])
    translate([0, 0, radius+pent_delta])
        pent_tile(tile_a=pent_a);
*/
    hex_triag();

    // layer 1
    for (i = [0:4]) {
        rotate([0, -ang1, i*pent_a*2])
        translate([0, 0, radius])
//            hex_tile();
        ;
/*
        mirror([0, 0, 1])
        rotate([0, ang1, i*pent_a*2])
        translate([0, 0, radius])
            hex_tile();
*/
    }    
/*
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
*/
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