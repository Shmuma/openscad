include <BOSL2/std.scad>
// Puzzle from MathEtudes: https://etudes.ru/models/puzzle-calendar/
// Variant with 10x5 field

// what to generate. Options: pieces, base_simple
// - pieces: set of pices
// - simple_base: base with pushed letters (single color)
// - simple_full: not supposed for printing, but for debugging the alignment
// - 2col_frame: frame for two-color version
// - 2col_plate: plate for two-color version
// - 2col_text: letters text for two-color version
// - 2col_full: for debugging the alignment 

// Model to generate
generate = "simple_base"; // [pieces, simple_base, 2col_frame, 2col_plate, 2col_text]

// Size of one basic square
pieces_grid = 15;     // [10:20]

// Size of outer border
base_border = 6;      // [1:10]

// Total height of base
base_height = 5;
// Thickness of the bottom plate
base_thick = 2;
// Thickness of the pieces
pieces_thick = 2;

// Language of calendar text
text_lang = "ru";     // [ru, en, de, fr, sv]
text_font = "PT Sans Narrow:style=Bold";
// Font size in points
text_size = 8.5;
// Thickness of the printing layer
layer_height = 0.3;
text_depth = layer_height*2;     // text depth in simple_base variant

// Tolerance for pieces fitting
tol = 0.2;
// Chamfer of pieces and base
chamfer = 0.4;
// Circle extrapolation
$fn = 10;

// end of tunable parameters
// size of the inner part
inner_width = pieces_grid*7;
inner_length = pieces_grid*7;
inner_thick = base_height - base_thick;
base_width = inner_width + base_border*2;
base_length = inner_length + base_border*2;


// temporary grid to check the text location and alignment
show_grid = false;

texts_ru =
  [["ЯНВ", "ФЕВ", "МАР", "АПР", "МАЙ", "ИЮН",   ""], 
   ["ИЮЛ", "АВГ", "СЕН", "ОКТ", "НОЯ", "ДЕК",   ""],
   [  "1",   "2",   "3",   "4",   "5",   "6",  "7"],
   [  "8",   "9",  "10",  "11",  "12",  "13", "14"],
   [ "15",  "16",  "17",  "18",  "19",  "20", "21"],
   [ "22",  "23",  "24",  "25",  "26",  "27", "28"],
   [ "29",  "30",  "31",    "",    "",    "",   ""]];

texts_en =
  [["JAN", "FEB", "MAR", "APR", "MAY", "JUN",   ""], 
   ["JUL", "AUG", "SEP", "OCT", "NOV", "DEC",   ""],
   [  "1",   "2",   "3",   "4",   "5",   "6",  "7"],
   [  "8",   "9",  "10",  "11",  "12",  "13", "14"],
   [ "15",  "16",  "17",  "18",  "19",  "20", "21"],
   [ "22",  "23",  "24",  "25",  "26",  "27", "28"],
   [ "29",  "30",  "31",    "",    "",    "",   ""]];

texts_de =
  [["JAN", "FEB", "MÄR", "APR", "MAI", "JUN",   ""], 
   ["JUL", "AUG", "SEP", "OKT", "NOV", "DEZ",   ""],
   [  "1",   "2",   "3",   "4",   "5",   "6",  "7"],
   [  "8",   "9",  "10",  "11",  "12",  "13", "14"],
   [ "15",  "16",  "17",  "18",  "19",  "20", "21"],
   [ "22",  "23",  "24",  "25",  "26",  "27", "28"],
   [ "29",  "30",  "31",    "",    "",    "",   ""]];

texts_sv =
  [["JAN", "FEB", "MAR", "APR", "MAJ", "JUN",   ""], 
   ["JUL", "AUG", "SEP", "OKT", "NOV", "DEC",   ""],
   [  "1",   "2",   "3",   "4",   "5",   "6",  "7"],
   [  "8",   "9",  "10",  "11",  "12",  "13", "14"],
   [ "15",  "16",  "17",  "18",  "19",  "20", "21"],
   [ "22",  "23",  "24",  "25",  "26",  "27", "28"],
   [ "29",  "30",  "31",    "",    "",    "",   ""]];

texts_fr =
  [["JAN", "FEV", "MAR", "AVR", "MAI", "JUN",   ""], 
   ["JUI", "AOU", "SEP", "OCT", "NOV", "DEC",   ""],
   [  "1",   "2",   "3",   "4",   "5",   "6",  "7"],
   [  "8",   "9",  "10",  "11",  "12",  "13", "14"],
   [ "15",  "16",  "17",  "18",  "19",  "20", "21"],
   [ "22",  "23",  "24",  "25",  "26",  "27", "28"],
   [ "29",  "30",  "31",    "",    "",    "",   ""]];

texts = (text_lang == "en" ?
	 texts_en :
	 (text_lang == "ru" ?
	  texts_ru :
	  (text_lang == "de" ?
	   texts_de :
	   (text_lang == "fr" ?
	    texts_fr :
	    (text_lang == "sv" ?
	     texts_sv :
	     (assert_equal(1, 2, "Language is not supported")))))));


module calendar_text(depth) {
  move([inner_length/2, inner_width/2])
  linear_extrude(depth) {
    grid_copies(size=[inner_length*6/7, inner_width*6/7], n=[7, 7]) {
      let (tsize = text_size - (len(texts[6-$row][$col]) - 1) * 1.5) {
	move([0, -tsize/2, 0])
	text(texts[6-$row][$col], font=text_font, size=tsize, halign="center", valign="baseline");
      }
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

  // forward-right bump
  move([base_border + pieces_grid*3, base_border-chamfer, base_thick])
    cuboid(size=[pieces_grid*4+chamfer, pieces_grid+chamfer, inner_thick], anchor=FWD+LEFT+BOT, chamfer=chamfer, edges=[TOP+LEFT, TOP+BACK]);

  // top-right bump
  move([base_border + pieces_grid*6, base_border + pieces_grid*5+chamfer, base_thick])
    cuboid(size=[pieces_grid+chamfer, pieces_grid*2+chamfer, inner_thick], anchor=FWD+LEFT+BOT, chamfer=chamfer, edges=[TOP+LEFT, TOP+FWD]);
  
  if (show_grid) {
    move([base_border, base_border, base_thick + tol]) {
      for (r = [1:6]) {
	y = r*pieces_grid;
	stroke([[0, y], [inner_length, y]], width=0.3);
      }

      for (c = [1:6]) {
	x = c*pieces_grid;
	stroke([[x, 0], [x, inner_width]], width=0.3);
      }
    }
  }

}


function piece_path(pts) = [for (p = pts) [p[0]*pieces_grid, p[1]*pieces_grid]];
  

// Pieces coordinates
P1 = [[1, 0], [3, 0], [3, 2], [0, 2], [0, 1], [1, 1]];
P2 = [[3, 1], [7, 1], [7, 3], [6, 3], [6, 2], [3, 2]];
P3 = [[2, 2], [6, 2], [6, 3], [4, 3], [4, 4], [3, 4], [3, 3], [2, 3]];
P4 = [[0, 2], [2, 2], [2, 5], [0, 5]];
P5 = [[2, 3], [3, 3], [3, 4], [4, 4], [4, 7], [3, 7], [3, 5], [2, 5]];
P6 = [[0, 5], [3, 5], [3, 7], [2, 7], [2, 6], [1, 6], [1, 7], [0, 7]];
P7 = [[4, 3], [7, 3], [7, 4], [5, 4], [5, 6], [4, 6]];
P8 = [[5, 4], [7, 4], [7, 5], [6, 5], [6, 7], [4, 7], [4, 6], [5, 6]];



module piece(points) {
  offset_sweep(offset(piece_path(points), delta=-tol, closed=true), height=pieces_thick, ends=os_chamfer(chamfer));
}


module pieces() {
  for (p = [P1, P2, P3, P4, P5, P6, P7, P8]) {
    piece(p);
  }
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
