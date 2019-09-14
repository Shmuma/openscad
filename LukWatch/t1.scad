OUTER_WIDTH = 15;
OUTER_HEIGHT = 10;
OUTER_LENGTH = 10;

EXT_THICK = 1.6;
EXT_HEIGHT = 3.5;
EXT_WIDTH = 5;
INNER_WIDTH = 7.6;
INNER_LENGTH = 3.2;
INNER_HEIGHT = 8.13;

I2_WIDTH = 8.4;
I2_HEIGHT = 3;
I2_LENGTH = 9;

HOLE_D = 1;
HOLE_DZ = 5;
HOLE_LEN = 3;

EXT_HOLE_D = 7;
TOP_CYL_D = 10;

$fn = 100;

module belt_part() {
    difference() {
        union() {
            cube([OUTER_WIDTH, OUTER_LENGTH, OUTER_HEIGHT]);
            
            translate([0, OUTER_LENGTH, OUTER_HEIGHT - TOP_CYL_D/2])
            rotate(90, [0, 1, 0])
            cylinder(OUTER_WIDTH, d=TOP_CYL_D);    
    
            cube([OUTER_WIDTH, OUTER_LENGTH + TOP_CYL_D/2, TOP_CYL_D/2]);        
        }

        translate([
            (OUTER_WIDTH - INNER_WIDTH)/2,
            EXT_THICK,
            OUTER_HEIGHT - INNER_HEIGHT
        ])
        cube([INNER_WIDTH, INNER_LENGTH, INNER_HEIGHT+0.1]);
        
        // rotated part to make a wedge
        translate([
            (OUTER_WIDTH - INNER_WIDTH)/2,
            EXT_THICK,
            OUTER_HEIGHT - INNER_HEIGHT/2
        ])
        rotate(10, [1, 0, 0])
        cube([INNER_WIDTH, INNER_LENGTH, INNER_HEIGHT/2+0.1]);
                
        translate([
            (OUTER_WIDTH - I2_WIDTH)/2,
            EXT_THICK,
            OUTER_HEIGHT - I2_HEIGHT
        ])
        cube([I2_WIDTH, I2_LENGTH, I2_HEIGHT+0.1]);
        
        translate([
            (OUTER_WIDTH - EXT_WIDTH)/2,
            -0.1,
            EXT_HEIGHT
        ])
        cube([EXT_WIDTH, EXT_THICK+0.2, OUTER_HEIGHT - EXT_HEIGHT + 0.1]);
        
        translate([OUTER_WIDTH/2, EXT_THICK + INNER_LENGTH - 0.1, HOLE_DZ])
        rotate(-90, [1, 0, 0])
        cylinder(HOLE_LEN, d=HOLE_D);  
      
        translate([OUTER_WIDTH/2, -0.1, OUTER_HEIGHT])
        rotate(-90, [1, 0, 0])
        cylinder(EXT_THICK, d=EXT_HOLE_D);  
    }
}

belt_part();