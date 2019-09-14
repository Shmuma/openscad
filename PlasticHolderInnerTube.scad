// cylinder for plastic holder
inner_diam = 10;
outer_diam = 50;
walls_thick = 2;
sectors = 6;
cylinder_height = 50;

$fn = 100;

module pattern() {
    difference() {
        circle(d=outer_diam);
        circle(d=outer_diam-walls_thick);
    }


    middle_diam = (outer_diam+inner_diam)/2;
    difference() {
        circle(d=middle_diam);
        circle(d=middle_diam-walls_thick);
    }

    difference() {
        union() {
            circle(d=inner_diam+walls_thick);

            for (n = [0:sectors]) {
                angle = n*360/sectors;
                rotate(angle, [0, 0, 1])
                translate([0, -walls_thick/4])
                square([outer_diam/2 - walls_thick/2, walls_thick/2]);
            }
        }
        circle(d=inner_diam);
    }
}

linear_extrude(cylinder_height)
pattern();

//translate([0, -walls_thick/4])
//square([outer_diam/2 - walls_thick/2, walls_thick/2]);

//circle(d=inner_diam);