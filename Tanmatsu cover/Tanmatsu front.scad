// Tanmatsu front cover
object_to_generate = "clip"; //[plain_cover:Plain cover, clip:Clip]

// Width of the border bump
bump_width_mm = 3.5; //[1:0.1:4]

// Height of the border bump
bump_thick_mm = 2.0; // [2:0.1:3]

// Are badge rope holes needed?
badge_rope_holes = false;

// Cover thickness
cover_thick_mm = 2; // [1:0.5:5]

// Clip thickness
clip_thick_mm = 1;

// Fitting extra offset for the clip (hole tolerance)
hole_fitting_ofs = 0.2;

// Fitting clip thick (overhang tolerance)
clip_fitting_ofs = 0.2;

clip_ear_width = 5;

// end of customizable parameters
module outer_half_polygon() {
    polygon([
        [57.5, 10],
        [4.5, 10],
        [-2.5, 3],
        [-2.5, 0],
        [-1.5, -1],
        [0, -1],        // top-left inner corner before the bump
        [0, -97],
        [-1.5, -97],
        [-2.5, -98],
        [-2.5, -115],
        [6.5, -124], // TODO: Badge rope hole (if needed)
        [23.5, -124],
        [24.5, -123],
        [24.5, -121.5],
        [33.5, -121.5],
        [38.0, -117],
        [44.5, -117],
        [49.0, -121.5],
        [57.5, -121.5], // middle
    ]);
}


module outer_full_polygon() {
    outer_half_polygon();
    translate([115.0, 0, 0])
    mirror([1, 0, 0])
    outer_half_polygon();
}

module cover_plate() {
    translate([0, 0, -cover_thick_mm])
    linear_extrude(height=cover_thick_mm)
    outer_full_polygon();
}


module cover_bump() {
    linear_extrude(height=bump_thick_mm)
    difference() {
        outer_full_polygon();
        offset(delta=-bump_width_mm)
            outer_full_polygon();
    }
}

module cover() {
    union() {
        cover_plate();
        cover_bump();
    }
}


module clip_ear(fit=0.0) {
    linear_extrude(height=16 + cover_thick_mm + bump_thick_mm)
        polygon([
            [0, 0+fit],
            [clip_ear_width, clip_ear_width+fit],
            [clip_ear_width, clip_ear_width-20-fit],
            [0, clip_ear_width*2-20-fit]
        ]);
}

module clip(hole_fit=0.0, clip_fit=0.0) {
    translate([0, -97+16+13, -cover_thick_mm]) {
        clip_ear(hole_fit);
        translate([115.0, 0, 0])
            mirror([1, 0, 0])
                clip_ear(hole_fit);
        translate([clip_ear_width, clip_ear_width-20-hole_fit, 0])
        cube([115.0-clip_ear_width*2, 20+hole_fit*2, clip_thick_mm+clip_fit], center=false);
    }
}


if (object_to_generate == "plain_cover") {
    difference() {
        cover();
        clip(hole_fitting_ofs, clip_fitting_ofs);
    }
} 
else if (object_to_generate == "clip") {
    // print on the side
    rotate([-90, 0, 0])    
    translate([-clip_ear_width, 68-clip_ear_width, cover_thick_mm])
    clip();
}
