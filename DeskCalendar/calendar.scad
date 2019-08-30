render_outer_ring = false;
render_day_ring = false;
render_day_text = false;
render_month_ring = false;
render_month_text = false;
render_week_ring = false;
render_week_text = false;
render_center_ring = true;

//week_ring_text = "MON TUE WED THU FRI SAT SUN";
week_ring_text = "ПНД ВТР СРД ЧТВ ПТ СБТ ВСК";

ring_wall = 2;
base_thick = 2;
rings_gap = 1;

outer_ring_diam = 110;
outer_ring_thick = 10;
outer_hole_diam = 15;
ring_thick = outer_ring_thick - base_thick;
ring_base_thick = 2;
day_ring_inner_diam = 85;
month_ring_inner_diam = 58;
week_ring_inner_diam = 30;
center_ring_extra_thick = 5;
center_ring_extra_diam = 13;
center_hole_diam = 3;
center_hole2_diam = 5;
center_hole2_depth = 5;

fn = 250;


module center_ring() {
    full_thick = ring_thick + base_thick + center_ring_extra_thick;
    difference() {
        union() {
            cylinder(ring_thick, d=week_ring_inner_diam - rings_gap, $fn=fn);
            cylinder(full_thick, d=center_ring_extra_diam, $fn=fn);
        }
        cylinder(full_thick + 0.1, d=center_hole_diam, $fn=fn);
        translate([0, 0, -0.1])
        cylinder(center_hole2_depth, d=center_hole2_diam, $fn=fn);
    }
}


module outer_ring() {
    inner_t = outer_ring_thick - base_thick;
    inner_d = outer_ring_diam - ring_wall;
    difference() {
        cylinder(outer_ring_thick, d=outer_ring_diam, $fn=fn);
        translate([0, 0, -0.1])
        cylinder(inner_t + 0.1, d=inner_d, $fn=fn);
        translate([0, 0, -0.1])
        cylinder(outer_ring_thick+0.2, d=outer_hole_diam, $fn=fn);
    }
}

module ring(outer_diam, inner_diam) {
    difference() {
        cylinder(ring_thick, d=outer_diam, $fn=fn);
        translate([0, 0, -0.1])
        cylinder(ring_thick + .2, d=inner_diam, $fn=fn);
        
        translate([0, 0, base_thick])
        difference() {
            cylinder(ring_thick - base_thick + 0.1, d=outer_diam - ring_wall, $fn=fn);
            cylinder(ring_thick - base_thick + 0.1, d=inner_diam + ring_wall, $fn=fn);
        }
    }
}

module day_ring() {
    ring(outer_ring_diam - ring_wall - rings_gap, day_ring_inner_diam);
}

module month_ring() {
    ring(day_ring_inner_diam - rings_gap, month_ring_inner_diam);
}


module week_ring() {
    ring(month_ring_inner_diam - rings_gap, week_ring_inner_diam);
}

module 
circletext(mytext,textsize=20,myfont="Arial",radius=100,thickness=1,degrees=360,top=true){ 
        
        chars=len(mytext)+1; 
        
        for (i = [1:chars]) { 
                        rotate([0,0,(top?1:-1)*(degrees/2-i*(degrees/chars))]) 
                        translate([0,(top?1:-1)*radius-(top?0:textsize/2),0]) 
                        //linear_extrude(thickness) 
                        text(mytext[i-1],halign="center",font=myfont,size=textsize); 
        } 
} 

module days_text(extra_thick=0) {
    linear_extrude(0.2+extra_thick)
    mirror([0, 1, 0])
    circletext("1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31", textsize=6, radius=49, top=false);
}

module month_text(extra_thick=0) {
    linear_extrude(0.2+extra_thick)
    mirror([0, 1, 0])
    circletext("1  2  3  4  5  6  7  8  9  10 11 12", textsize=7, radius=36, top=false);
}


module week_text(extra_thick=0) {
    linear_extrude(0.2+extra_thick)
    mirror([0, 1, 0])
    circletext(week_ring_text, textsize=6, radius=22, top=false);
}


if (render_outer_ring) {
    outer_ring();
}

if (render_day_ring) {
    difference() {
        day_ring();
        translate([0, 0, -0.1])
        color("blue")
        days_text(extra_thick=0.1);
    }
}    

if (render_day_text) {
    days_text();
}

if (render_month_ring) {
    difference() {
        month_ring();
        translate([0, 0, -0.1])
        color("blue")
        month_text(extra_thick=0.1);        
    }
}

if (render_month_text) {
    month_text();
}

if (render_week_ring) {
    difference() {
        week_ring();
        translate([0, 0, -0.1])
        color("blue")
        week_text(extra_thick=0.1);                
    }
}

if (render_week_text) {
    week_text();
}


if (render_center_ring) {
    center_ring();
}