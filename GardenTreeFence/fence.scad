include <BOSL2/std.scad>

generate = "assembly";

$fn = 100;

// outer diameter
circle_d = 120;
// circle width
circle_w = 10;
// circle height
circle_h = 10;

plane_w = 5;
plane_l1 = 10;
plane_l2 = 6;
plane_len = 200;

tol = 0.1;
chamfer = .5;
planes_count = 15;

plane_skew = (plane_l1 - plane_l2)/2;


module fence_circle() {
  difference () {
    up (circle_h/2)
    difference() {
        cyl(l=circle_h, r=circle_d/2, chamfer=chamfer);
        cyl(l=circle_h+0.1, r=(circle_d/2 - circle_w), chamfer=-chamfer);
    }
    
    zrot_copies(n=planes_count)
        move([-plane_l1/2, -plane_w/2 - circle_d/2 + circle_w/2, 0])
        plane_diff();
    }   
}


plane_points = [
    [0, 0],
    [plane_l1, 0],
    [plane_l1 - plane_skew, plane_w],
    [plane_skew, plane_w],
];


module plane_diff() {
  down(tol)
    offset_sweep(offset(plane_points, delta=tol, closed=true), 
        height=circle_h+tol*2);
}


module plane() {
    rotate([90, 0, 0])
    offset_sweep(plane_points, 
        height=plane_len, ends=os_chamfer(chamfer));   
}


if (generate == "circle") {
    fence_circle();
}
else if (generate == "plane_diff") {
    plane_diff();
}
else if (generate == "plane") {
    plane();
}
else if (generate == "assembly") {
    fence_circle();

    up(plane_len/2)
    fence_circle();

    up(plane_len - circle_h)
    fence_circle();

    
    zrot_copies(n=planes_count)
    move([-plane_l1/2, -plane_w/2 - circle_d/2 + circle_w/2, 0])
    rotate([-90, 0, 0])
    plane();
}