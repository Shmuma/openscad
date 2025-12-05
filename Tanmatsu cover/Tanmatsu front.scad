include <BOSL2/std.scad>

// Tanmatsu front cover
object_to_generate = "cover_logo"; //[cover:Plain cover, clip:Clip, cover_logo:Cover with logo removed, logo:Logo text]

// Width of the border bump
bump_width_mm = 3; //[1:0.1:4]

// Height of the border bump
bump_thick_mm = 2.0; // [2:0.1:3]

// Cover thickness
cover_thick_mm = 3; // [1:0.5:5]

// Clip thickness
clip_thick_mm = 1.5;

// Fitting extra offset for the clip (hole tolerance)
hole_fitting_ofs = 0.1;

// Fitting clip thick (overhang tolerance)
clip_fitting_ofs = 0.2;

clip_ear_width = 4.5;
clip_ear_height = 18.0;

// small cut on sides to simplify printing vertically
clip_side_cut = 0.5;

// Chamfer size for top size
chamfer_top = 1.0;

// for bottom bumps
chamfer_bot = 0.5;

// printing layer height (for text)
text_layer_thick = 0.3;

// offset of the logo center
logo_y_ofs = 20;

// for thinner version:
// cover_thick_mm = 2
// clip_thick_mm = 1

// End of user-tunable parameters
device_width = 115.0;

// half of the case path
half_poly_path = [
//        [57.5, 10],
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
//        [57.5, -121.5], // middle
];

full_poly_path = round_corners(
    concat(
        half_poly_path, 
        [ for (p = reverse(half_poly_path)) [device_width - p[0], p[1]]]
    ), r=1.0, $fn=20);


module cover_plate() {
    translate([0, 0, -cover_thick_mm])
    offset_sweep(full_poly_path, height=cover_thick_mm, bottom=os_chamfer(width=chamfer_top));
}


module cover_bump() {
    r = difference(
        full_poly_path,
        offset(full_poly_path, delta=-bump_width_mm)
    );

    offset_sweep(r, height=bump_thick_mm, top=os_chamfer(width=chamfer_bot));
}


module bolt_bump(cut_corner=true, h=7) {
    r = difference(move([-5, 0], square([10, h])), circle(2.5, $fn=100));

    difference() {
        offset_sweep(r, height=cover_thick_mm, top=os_chamfer(width=chamfer_bot));

        if (cut_corner) {
            translate([-5.5, 5.5, 0])
                rotate([0, 90, -45])
                    cube([5, 10, 3], center=true);
        }
    }
}


module four_bolt_bumps() {
    translate([9.5, -9, 0])
    // align center to the start of our case coordinates
    translate([-2.5, 10, 0])
    bolt_bump();

    translate([-9.5, -9, 0])
    translate([device_width+2.5, 10, 0])
    mirror([1, 0, 0])
    bolt_bump();

    translate([16, 6.5, 0])
    translate([-2.5, -124])
    mirror([0, 1, 0])
    bolt_bump(cut_corner=false, h=6);


    translate([-16, 6.5, 0])
    translate([device_width+2.5, 0, 0])
    translate([0, -124])
    mirror([0, 1, 0])
    bolt_bump(cut_corner=false, h=6);    
}


module cover() {
    union() {
        cover_plate();
        cover_bump();
        four_bolt_bumps();
    }
}


module clip_ear_bump() {
    left(5)
    difference() {
        cylinder(h=4, r1=5, r2=7, $fn=100);
        left(5)
        cube([20, 20, 10], center=true);
    }
}


module clip_ear_bump_proj(fit=0.0) {
    ymove(-10)
    cube([2+fit, 20, cover_thick_mm-clip_thick_mm]);
/*    
    left(5)
    difference() {
        cylinder(
            h=cover_thick_mm-clip_thick_mm, 
            r1=7+fit, r2=7+fit, $fn=100);
        left(5)
        cube([20, 20, 10], center=true);
    }
*/
}


module clip_ear(fit=0.0) {
    difference() {
        linear_extrude(height=clip_ear_height + cover_thick_mm + bump_thick_mm)
            polygon([
                [0, 0+fit],
                [clip_ear_width, clip_ear_width+fit],
                [clip_ear_width, clip_ear_width-20-fit],
                [0, clip_ear_width*2-20-fit]
            ]);
        rotate([0, 45, 0])
            cube([chamfer_top*sqrt(2)-fit, 40, chamfer_top*sqrt(2)-fit], center=true);
    }
    
    translate([clip_ear_width, -5, clip_ear_height])
    clip_ear_bump();
    
    translate([clip_ear_width-0.1, -5, clip_thick_mm])
    clip_ear_bump_proj(fit);
}




module clip(hole_fit=0.0, clip_fit=0.0) {
    translate([0, -97+16+13, -cover_thick_mm]) 
    {
        difference() {
            union() {
                clip_ear(hole_fit);
                right(device_width)
                    mirror([1, 0, 0])
                        clip_ear(hole_fit);
                translate([clip_ear_width-hole_fit, clip_ear_width-20-hole_fit, 0])
                cube([
                    device_width-clip_ear_width*2+hole_fit*2, 
                    20+hole_fit*2, 
                    clip_thick_mm+clip_fit], center=false);
            }
            union() {
                translate([0, clip_ear_width-clip_side_cut, -0.5])
                cube([
                    device_width, 
                    clip_side_cut*2, 
                    clip_ear_height + cover_thick_mm + bump_thick_mm + 1
                ]);
                translate([0, clip_ear_width-20-clip_side_cut, -0.5])
                cube([
                    device_width, 
                    clip_side_cut*2, 
                    clip_ear_height + cover_thick_mm + bump_thick_mm + 1
                ]);                
            }
        }
    }
}

module logo() {
    move([device_width/2, -logo_y_ofs, -cover_thick_mm])
    linear_extrude(text_layer_thick)
    mirror([1, 0, 0])
    text("Tanmatsu", size=14, font="Arial:style=Bold", 
        halign="center", valign="center");    
}


if (object_to_generate == "cover") {
    difference() {
        cover();
        clip(hole_fitting_ofs, clip_fitting_ofs);
    }
} 
else if (object_to_generate == "clip") {
    // print on the side
    rotate([-90, 0, 0])    
    translate([-clip_ear_width, 68-clip_ear_width+clip_side_cut, cover_thick_mm])
    clip();
}
else if (object_to_generate == "cover_logo") {
    move([-device_width/2, logo_y_ofs, cover_thick_mm])
    difference() {
        cover();
        clip(hole_fitting_ofs, clip_fitting_ofs);
        logo();
    }    
}
else if (object_to_generate == "logo") {
    move([-device_width/2, logo_y_ofs, cover_thick_mm])
    logo();
}
