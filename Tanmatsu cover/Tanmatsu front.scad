// Tanmatsu front cover
object_to_generate = "plain_cover"; //[plan_cover:Plain cover, ]

// Width of the border bump
bump_width_mm = 3.5; //[1:0.1:4]

// Height of the border bump
bump_height_mm = 2.0; // [2:0.1:3]

// Are badge rope holes needed?
badge_rope_holes = false;

// Cover thickness
cover_thick_mm = 3; // [1:0.5:5]

// end of customizable parameters
module outer_half_polygon() {
    polygon([
        [57.5, 11],
        [4.5, 11],
        [-2.5, 4],
        [-2.5, 1],
        [-1.5, 0],
        [0, 0],        // top-left inner corner before the bump
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
    linear_extrude(height=bump_height_mm)
    difference() {
        outer_full_polygon();
        offset(delta=-bump_width_mm)
            outer_full_polygon();
    }
}

cover_plate();
cover_bump();