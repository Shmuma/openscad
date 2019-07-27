// puzzle from "Kvantik" 07-2019
// The task is to assemble box 2x2 from 7 pieces of type A and 1 piece of 
// type B (which is a mirror of A). There is a single way of doing this.

// how many pieces to generate
make_pieces_a = 7;  // 7
make_pieces_b = 1;  // 1
make_box = true;

// side of single item in mm
side_size = 10;
// thickness of box walls
box_walls = 2;
// extra space to add to the box
box_delta = 0.5;

// end of user customizable parameters list
module puzzle_piece_a() {
    union() {
        cube([side_size, side_size, side_size/2]);
        translate([0, side_size, 0])
        cube([side_size/2, side_size, side_size]);
    }
}

module puzzle_piece_b() {
    mirror([1, 0, 0])
    puzzle_piece_a();
}

if (make_pieces_a > 0) { 
    for (i = [1:make_pieces_a]) {
        translate([side_size*2*(i-1), 0, 0])
        puzzle_piece_a();
    }
}

if (make_pieces_b > 0) {
    translate([0, side_size*3, 0]) {
        for (i = [1:make_pieces_b]) {
            translate([side_size*2*i, 0, 0])
            puzzle_piece_b();
        }
    }
}

if (make_box) {
    translate([0, -side_size*3, 0])
    puzzle_box();
}

module puzzle_box() {
    side_inner = side_size*2 + box_delta;
    side_outer = side_inner + box_walls*2;
    difference() {
        cube([side_outer, side_outer, side_outer]);
        translate([box_walls, box_walls, box_walls])
        cube([side_inner, side_inner, side_inner*2]);
    }
    
}