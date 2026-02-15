include <BOSL2/std.scad>

// what to generate. Options: pieces, base_simple
// - pieces: set of pices
// - simple_base: base with pushed letters (single color)
// - simple_full: not supposed for printing, but for debugging the alignment
// - 2col_frame: frame for two-color version
// - 2col_plate: plate for two-color version
// - 2col_text: letters text for two-color version
// - 2col_full: for debugging the alignment 
generate = "2col_plate";

pieces_grid = 15;     // size of basic piece square
base_border = 6;      // border width

base_height = 5;      // total height
base_thick = 2;       // bottom thickness
pieces_thick = 2;     // thickness of pieces

text_size = 8;        // text size in points
layer_height = 0.3;   // printing layer height
text_depth = layer_height*2;     // text depth in simple_base variant
window_offset = -1.5; // offset of the window relative to piece square size

tol = 0.2;           // tolerance for fitting
chamfer = 0.4;        // chamfering of pieces and the base
$fn = 100;

// end of tunable parameters
// size of the inner part
inner_width = pieces_grid*5;
inner_length = pieces_grid*10;
inner_thick = base_height - base_thick;
base_width = inner_width + base_border*2;
base_length = inner_length + base_border*2;


// temporary grid to check the text location and alignment
show_grid = false;

texts =
  [
   ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ", "ВС", "1", "2", "3"],
   ["4", "5", "6", "7", "8", "9", "10", "11", "12", "13"],
   ["14", "15", "16", "17", "18", "19", "20", "21", "22", "23"],
   ["24", "25", "26", "27", "ЯНВ", "ФЕВ", "МАР", "АПР", "МАЙ", "ИЮН"],
   ["28", "29", "30", "31", "ИЮЛ", "АВГ", "СЕН", "ОКТ", "НОЯ", "ДЕК"],
  ];



module calendar_text(depth) {
  move([inner_length/2, inner_width/2])
  linear_extrude(depth) {
    grid_copies(size=[inner_length*9/10, inner_width*4/5], n=[10, 5]) {
      text(texts[4-$row][$col], font="Arial Narrow",
	   size=text_size - (len(texts[4-$row][$col]) - 1) * 1.5,
	   halign="center", valign="center");
    }
  }
}


module base() {
  difference() {
    cuboid(size=[base_length, base_width, base_height], anchor=FWD+LEFT+BOT, chamfer=chamfer);
      
    move([base_border, base_border, base_thick])
      cuboid(size=[inner_length, inner_width, inner_thick + tol], anchor=FWD+LEFT+BOT, chamfer=-chamfer, edges=[TOP]);
    move([base_border, base_border, base_thick - text_depth])
      calendar_text(text_depth + tol);
  }



  if (show_grid) {
    move([base_border, base_border, base_thick + tol]) {
      for (r = [1:4]) {
	y = r*pieces_grid;
	stroke([[0, y], [inner_length, y]], width=0.3);
      }

      for (c = [1:9]) {
	x = c*pieces_grid;
	stroke([[x, 0], [x, inner_width]], width=0.3);
      }
    }
  }

}


function piece_path(pts) = [for (p = pts) [p[0]*pieces_grid, p[1]*pieces_grid]];
  

// Pieces coordinates
P1 = [[0, 0], [3, 0], [3, 1], [1, 1], [1, 2], [0, 2]];
P2 = [[0, 2], [1, 2], [1, 3], [2, 3], [2, 5], [0, 5]];
P3 = [[1, 1], [2, 1], [2, 2], [3, 2], [3, 4], [2, 4], [2, 3], [1, 3]];
P4 = [[2, 1], [3, 1], [3, 0], [5, 0], [5, 1], [4, 1], [4, 2], [2, 2]];

P5 = [[3, 2], [4, 2], [4, 5], [2, 5], [2, 4], [3, 4]];
P5_H = [[3, 4], [4, 4], [4, 5], [3, 5]];
P5_P = [[0, 1, 2, 3, 4, 5], [6, 7, 8, 9]];

P6 = [[4, 1], [5, 1], [5, 5], [4, 5]];
P6_H = [[4, 1], [5, 1], [5, 2], [4, 2]];
P6_P = [[0, 1, 2, 3], [4, 5, 6, 7]];

P7 = [[5, 0], [7, 0], [7, 2], [6, 2], [6, 3], [5, 3]];
P8 = [[7, 0], [10, 0], [10, 1], [9, 1], [9, 2], [8, 2], [8, 1], [7, 1]];
P9 = [[7, 1], [8, 1], [8, 2], [9, 2], [9, 3], [6, 3], [6, 2], [7, 2]];
P10 = [[5, 3], [7, 3], [7, 5], [5, 5]];

P11 = [[7, 3], [9, 3], [9, 5], [7, 5]];
P11_H = [[7, 4], [8, 4], [8, 5], [7, 5]];
P11_P = [[0, 1, 2, 3], [4, 5, 6, 7]];

P12 = [[9, 1], [10, 1], [10, 5], [9, 5]];


module piece(points) {
  offset_sweep(offset(piece_path(points), delta=-tol, closed=true), height=pieces_thick, ends=os_chamfer(chamfer));
}

module piece_with_hole(points, hole) {
  difference() {
    piece(points);
    down(tol)
      offset_sweep(offset(offset(piece_path(hole), delta=-tol, closed=true),
			  delta=window_offset, closed=true),
		   height=pieces_thick+tol*2, ends=os_chamfer(-chamfer));
  }
}


module pieces() {
  // without holes
  for (p = [P1, P2, P3, P4, P7, P8, P9, P10, P12]) {
    piece(p);
  }

  piece_with_hole(P5, P5_H);
  piece_with_hole(P6, P6_H);
  piece_with_hole(P11, P11_H);
}



// Two color frame profile
FRAME_PROFILE = [[0, base_height],
		 [0, 0], [base_border, 0],
		 [base_border - base_thick, base_thick],
		 [base_border + inner_width + base_thick, base_thick],
		 [base_border + inner_width, 0], [base_width, 0],
		 [base_width, base_height]];


module twocol_frame() {
  difference() {
    move([0, base_width, base_height])
      zrot(-90)
      xrot(-90)
      offset_sweep(FRAME_PROFILE, height=base_length, ends=os_chamfer(chamfer));
    
    move([base_border, base_border, -tol/2])
      cuboid([inner_length, inner_width, inner_thick + tol], anchor=FWD+LEFT+BOT);
  }
}


module text_mask() {
  //  move([base_length, base_thick_2col])
  xflip(x=base_length/2)
  move([base_border, base_thick])
    calendar_text(layer_height);
}


// Two color plate profile
PLATE_PROFILE = [[0, 0], [inner_width + base_thick * 2, 0],
		 [inner_width + base_thick, base_thick],
		 [base_thick, base_thick]];


module twocol_plate() {
  difference() {
    zrot(90)
      xrot(90)
      offset_sweep(PLATE_PROFILE, height=base_length);
    text_mask();
  }
}


if (generate == "pieces")
  pieces();
else if (generate == "simple_base")
  base();
else if (generate == "simple_full") {
  base();
  move([base_border, base_border, base_thick]) {
    pieces();
  }
} else if (generate == "2col_frame")
  twocol_frame();
else if (generate == "2col_plate")
  twocol_plate();
else if (generate == "2col_text")
  text_mask();
else if (generate == "2col_full") {
  twocol_frame();
  
  move([0, base_border - base_thick, inner_thick])
    twocol_plate();
}
