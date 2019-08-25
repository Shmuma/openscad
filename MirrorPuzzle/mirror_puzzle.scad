// puzzle from "Kvantik" 07-2019
// The task is to assemble box 2x2 from 7 pieces of type A and 1 piece of 
// type B (which is a mirror of A). There is a single way of doing this.

// how many pieces to generate
make_pieces_a = 7;  // 7
make_piece_b = true;  
make_box = true;

// side of single item in mm
side_size = 20;
// thickness of box walls
box_walls = 1.5;
// extra space to add to the box
box_delta = 1;

// end of user customizable parameters list
module puzzle_piece_a() {
    union() {
        cube([side_size, side_size, side_size/2]);
        translate([0, side_size, 0])
        cube([side_size/2, side_size, side_size]);
    }
}

module puzzle_piece_b() {
    translate([side_size, 0, 0])
    mirror([1, 0, 0])
    puzzle_piece_a();
}

if (make_pieces_a > 0) { 
    s = ceil(sqrt(make_pieces_a));
    for (i = [1:make_pieces_a]) {
        y = floor(i/s);
        x = i - y*s;
        translate([(side_size+5)*x, y*(side_size*2+5), 0])
        puzzle_piece_a();
    }
}

if (make_piece_b) {
    puzzle_piece_b();
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