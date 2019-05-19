// Slide puzzle - need to place 5 pieces in the field in a way 
// that no one could slide sideways
// There are four levels with field of size 6x6, 6x7, 6x8 and 6x9

// Tunable params
FIELD_ROWS = 6;  
FIELD_COLS = 9;             // change to 7, 8 or 9 for athother levels

CELL_SIZE = 10;             // size of one cell in mm
CELL_THICK = 2;             // thickness of cell in mm
FIELD_BORDER = 2;           // border around the field in mm
FIELD_BORDER_EXTRA = 1;     // extra thickness of field
FIELD_FLOOR_THICK = 2;      // thickness of field's floor
FIELD_LINE_THICK = 1;       // thickness of grid lines
FIELD_LINE_DEPTH = 0.2;

PIECES_OFFSET = 0.2;        // decrease pieces sizes to prevent PLA flatten (probably my printer is not properly calibrated)

// objects to make
MAKE_FIELD = true;          // build a field
MAKE_COVER = true;          // build a cover
MAKE_HEXA_PIECES = true;    // build two hexamino pieces
MAKE_TETR_PIECES = true;    // build three tetramino pieces

// end of tunables

module field_base() {
    difference() {
        cube([
            FIELD_COLS * CELL_SIZE + 2*FIELD_BORDER,
            FIELD_ROWS * CELL_SIZE + 2*FIELD_BORDER,
            FIELD_FLOOR_THICK + CELL_THICK + FIELD_BORDER_EXTRA
        ]);
        translate([FIELD_BORDER, FIELD_BORDER, FIELD_FLOOR_THICK])
        cube([
            FIELD_COLS * CELL_SIZE,
            FIELD_ROWS * CELL_SIZE,
            CELL_THICK + FIELD_BORDER_EXTRA + 1
        ]);
    }    
}

module cover_base() {
    difference() {
        cube([
            FIELD_COLS * CELL_SIZE + 4*FIELD_BORDER,
            FIELD_ROWS * CELL_SIZE + 4*FIELD_BORDER,
            FIELD_FLOOR_THICK*2 + CELL_THICK + FIELD_BORDER_EXTRA
        ]);
        translate([FIELD_BORDER, FIELD_BORDER, FIELD_FLOOR_THICK])
        cube([
            FIELD_COLS * CELL_SIZE + 2*FIELD_BORDER,
            FIELD_ROWS * CELL_SIZE + 2*FIELD_BORDER,
            CELL_THICK+FIELD_FLOOR_THICK+FIELD_BORDER_EXTRA+1
        ]);
    }    
}



module field_vline(i) {
    thick = FIELD_LINE_THICK/2;
    translate([FIELD_BORDER, FIELD_BORDER, FIELD_FLOOR_THICK-FIELD_LINE_DEPTH]) {
        if (i < FIELD_ROWS) {
            translate([CELL_SIZE*i, 0, 0])
            cube([thick, FIELD_ROWS*CELL_SIZE, FIELD_LINE_DEPTH*2]);
        }
        if (i > 0) {
            translate([CELL_SIZE*i - thick, 0, 0])
            cube([thick, FIELD_ROWS*CELL_SIZE, FIELD_LINE_DEPTH*2]);
        }
    }
}

module field_hline(i) {
    thick = FIELD_LINE_THICK/2;
    translate([FIELD_BORDER, FIELD_BORDER, FIELD_FLOOR_THICK-FIELD_LINE_DEPTH]) {
        if (i < FIELD_COLS) {
            translate([0, CELL_SIZE*i, 0])
            cube([FIELD_COLS*CELL_SIZE, thick, FIELD_LINE_DEPTH*2]);
        }
        if (i > 0) {
            translate([0, CELL_SIZE*i - thick, 0])
            cube([FIELD_COLS*CELL_SIZE, thick, FIELD_LINE_DEPTH*2]);
        }
    }
}


module make_field_cell() {
    linear_extrude(FIELD_LINE_DEPTH) 
    difference() {
        square(CELL_SIZE - FIELD_LINE_THICK);
        translate([FIELD_LINE_THICK, FIELD_LINE_THICK, 0])
        square(CELL_SIZE - FIELD_LINE_THICK*3);
    }
}


module make_field() {
    union() {
        field_base();
        translate([FIELD_BORDER + FIELD_LINE_THICK/2, FIELD_BORDER + FIELD_LINE_THICK/2, FIELD_FLOOR_THICK]) 
        for (i = [0:FIELD_COLS-1])
            for (j = [0:FIELD_ROWS-1]) {
                translate([i*CELL_SIZE, j*CELL_SIZE])
                    make_field_cell();
            }
        
//        for (i = [0:FIELD_COLS])
//            field_vline(i);
//        for (i = [0:FIELD_ROWS])
//            field_hline(i);
    }
}


module make_cells(offsets) {
    linear_extrude(CELL_THICK) {
        offset(delta=-PIECES_OFFSET)
        for (ofs = offsets) {
            translate([ofs[0]*CELL_SIZE, ofs[1]*CELL_SIZE, 0])
            square(CELL_SIZE);
        }
    }
}


module make_hexa() {
    make_cells([[0, 0], [1, 0], [2, 0], [0, 1], [0, 2], [2, 1]]);
}


module make_tetra() {
    make_cells([[0, 0], [0, 1], [0, 2], [0, 3]]);
}


module cover_text() {
    h_center = (FIELD_COLS * CELL_SIZE + 4*FIELD_BORDER)/2;
    v_line1 = (FIELD_ROWS * CELL_SIZE + 4*FIELD_BORDER)*3/4;
    v_line2 = (FIELD_ROWS * CELL_SIZE + 4*FIELD_BORDER)/2;
    v_line3 = (FIELD_ROWS * CELL_SIZE + 4*FIELD_BORDER)/4;
    thick = FIELD_LINE_DEPTH;
    font = "Liberation Sans:style=Bold";
    
    translate([h_center, v_line1, -thick])
    linear_extrude(thick*2)
    text("AntiSlide", halign="center", valign="center", font=font);

    translate([h_center, v_line2, -thick])
    linear_extrude(thick*2)
    text(str(FIELD_ROWS, "×", FIELD_COLS), halign="center", valign="center", font=font);
    
    translate([h_center, v_line3, -thick])
    linear_extrude(thick*2)
    text("by shmuma", 7, halign="center", valign="center", font=font);
}


module make_cover() {
    difference() {
        cover_base();
        translate([FIELD_COLS * CELL_SIZE + 4*FIELD_BORDER, 0, 0])
        mirror([1, 0, 0])
        cover_text();
    }
}


if (MAKE_FIELD) {
    make_field();
}

if (MAKE_HEXA_PIECES) {
    translate([100, 0, 0]) {
        make_hexa();
        translate([0, 35])
            make_hexa();
    }
}

if (MAKE_TETR_PIECES) {
    translate([100, 80, 0]) {
        make_tetra();
        translate([15, 0, 0])
            make_tetra();
        translate([30, 0, 0])
            make_tetra();
        translate([45, 0, 0])
            make_tetra();
    }
}

if (MAKE_COVER) {
    translate([0, 70, 0])
    make_cover();
}