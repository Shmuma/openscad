include <BOSL2/std.scad>

// what to generate. Options: pieces, base_simple
// - pieces: set of pices
// - base_simple: base with pushed letters (single color)
// - both: not supposed for printing, but for debugging the alignment
generate = "pieces";

// scale factor from original kvantik size
scale = 0.6;

pieces_grid = 24;
base_border = 10;
base_width = pieces_grid*5 + base_border*2;
base_length = pieces_grid*10 + base_border*2;

base_height = 7;      // total height
base_thick = 2;       // bottom thickness
pieces_thick = 4;     // thickness of pieces

text_size = 8;        // text size in points
text_depth = 0.6;     // should be a layer height
window_offset = -1.5; // offset of the window relative to piece square size

tol = 0.15;           // tolerance for fitting
chamfer = 0.4;        // chamfering of pieces and the base
$fn = 100;

// end of tunable parameters
// size of the inner part
inner_length = base_length - base_border*2;
inner_width = base_width - base_border*2;
inner_thick = base_height - base_thick;

dx = inner_length * scale / 10;
dy = inner_width * scale / 5;

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



module calendar_text() {
  move([(base_border + inner_length/2)*scale, (base_border + inner_width/2)*scale, base_thick*scale - text_depth]) {
    linear_extrude(text_depth + tol) {
      grid_copies(size=[inner_length*scale*9/10, inner_width*scale*4/5], n=[10, 5]) {
	text(texts[4-$row][$col], font="Arial Narrow",
	     size=text_size - (len(texts[4-$row][$col]) - 1) * 1.5,
	     halign="center", valign="center");
      }
    }
  }
}


module base() {
  difference() {
    cuboid(size=[base_length * scale, base_width * scale, base_height * scale], anchor=FWD+LEFT+BOT, chamfer=chamfer);
      
    move([base_border * scale, base_border * scale, base_thick * scale])
      cuboid(size=[inner_length * scale, inner_width * scale, inner_thick * scale + tol], anchor=FWD+LEFT+BOT, chamfer=-chamfer, edges=[TOP]);
    calendar_text();
  }



  if (show_grid) {
    move([base_border*scale, base_border*scale, base_thick*scale + tol]) {
      for (r = [1:4]) {
	y = r*pieces_grid*scale;
	stroke([[0, y], [inner_length*scale, y]], width=0.3);
      }

      for (c = [1:9]) {
	x = c*pieces_grid*scale;
	stroke([[x, 0], [x, inner_width*scale]], width=0.3);
      }
    }
  }

}


function piece_path(pts) = [for (p = pts) [p[0]*dx, p[1]*dy]];
  

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
  offset_sweep(offset(piece_path(points), delta=-tol, closed=true), height=pieces_thick*scale, ends=os_chamfer(.4));
}

module piece_with_hole(points, hole) {
  difference() {
    piece(points);
    down(tol)
      offset_sweep(offset(offset(piece_path(hole), delta=-tol, closed=true),
			  delta=window_offset, closed=true),
		   height=pieces_thick*scale+tol*2, ends=os_chamfer(-.4));
  }
}


module pieces() {
  // without holes
  for (p = [P1, P2, P3, P4, P7, P8, P9, P10, P12]) {
    //polygon(offset(piece_path(p), delta=-tol, closed=true));
    piece(p);
  }

  piece_with_hole(P5, P5_H);
  piece_with_hole(P6, P6_H);
  piece_with_hole(P11, P11_H);
}


if (generate == "pieces")
  pieces();
 else if (generate == "base_simple")
   base();
 else if (generate == "both") {
   base();
   move([base_border*scale, base_border*scale, base_thick*scale]) {
     pieces();
   }
 }
