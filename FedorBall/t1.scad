// size of hex tile
side_x=1;
side_y=side_x / cos(30);
bound=0.1;
thick=0.1;
// how many tiles are layed on a sphere perimeter
tiles_count = 60;

// https://math.stackexchange.com/questions/2029958/numbering-a-spherical-grid-of-pentagons-and-hexagons-so-neighbours-are-easily


module hex_tile(side = side_x, thick=thick, tile_a=0) {
    r = side / cos(30);
    angles = [for (i = [0:5]) 30 + i*(360/6)];
    coords = [
        for (th=angles) 
            [r * cos(th), r * sin(th)]
    ];
    rotate([0, 0, tile_a])
    linear_extrude(thick)
        polygon(coords);
}

delta_a = 360 / tiles_count;
echo(delta_a);

out_radius = (2*side_x + bound) / sin(delta_a);
h = out_radius - sqrt(out_radius^2 - (side_x*2)^2/4);
radius = out_radius - h*2;
echo("Radius: ", radius);

module hex_ring(step=1, tile_a=0, delta_a=delta_a) {
    for (i = [0:step:tiles_count-1]) {
        rotate([0, delta_a*i, 0])
        translate([0, 0, radius])
            hex_tile(tile_a=tile_a);
    }
}



for (i = [0:3]) {
    rotate([0, 0, i*60])
        hex_ring(step=1);
}

/*
for (i = [0:0]) {
    rotate([0, 0, 30+i*60])
        hex_ring(step=2, tile_a=30);
}
*/

