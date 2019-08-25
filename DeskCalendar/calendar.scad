render_day_ring = true;
render_day_text = false;


module day_ring() {
    difference() {
        cylinder(10, d=110, $fn = 50);
        cylinder(8, d=83, $fn = 50);
        
        translate([0, 0, 2]) {
            difference() {
                cylinder(8, d=103, $fn = 50);
                cylinder(8, d=89, $fn = 50);
            }
        }
        
        cylinder(10, d=15);
    }
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

module days_text() {
    linear_extrude(0.2)
    mirror([0, 1, 0])
    circletext("1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31", textsize=6, radius=46, top=true);
}

if (render_day_ring) {
    difference() {
        day_ring();
        days_text();
    }
}    

if (render_day_text) {
    days_text();
}