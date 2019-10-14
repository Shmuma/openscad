da = 3;
db = 2;
dc = 1;

side = 5;
gap = 0.2;


module l(size, col="cyan") {
    color(col)
    for (x = [1:size[0]]) {
        for (y = [1:size[1]]) {
            for (z = [1:size[2]]) {
                translate([side*(x-1), side*(y-1), side*(z-1)])
                cube(side-gap);
            }
        }
    }
}



module l0(a, b, c, col="cyan") {
    color(col)
    for (x = [1:a]) {
        for (y = [1:b]) {
            for (z = [1:c]) {
                translate([side*(x-1), side*(y-1), side*(z-1)])
                cube(side-gap);
            }
        }
    }
}

module l1(a, b, c) {
    col = "blue";
    translate([0, 0, side*c])
    l0(a, b, 1, col);
    translate([0, 0, -side])
    l0(a, b, 1, col);
    
    translate([0, side*b, 0])
    l0(a, 1, c, col);
    translate([0, -side, 0])
    l0(a, 1, c, col);
    
    translate([side*a, 0, 0])
    l0(1, b, c, col);
    translate([-side, 0, 0])
    l0(1, b, c, col);
}


module l2(a, b, c) {
    col = "red";
 
    translate([0, 0, side*(c+1)])
    l0(a, b, 1, col);
    translate([0, 0, -side*2])
    l0(a, b, 1, col);
    
    translate([0, side*(b+1), 0])
    l0(a, 1, c, col);
    translate([0, -side*2, 0])
    l0(a, 1, c, col);
    
    translate([side*(a+1), 0, 0])
    l0(1, b, c, col);
    translate([-side*2, 0, 0])
    l0(1, b, c, col); 
    //==================================
    translate([a*side, 0, c*side])
    l0(1, b, 1, col);
    translate([-side, 0, c*side])
    l0(1, b, 1, col);

    translate([0, b*side, c*side])
    l0(a, 1, 1, col);
    translate([0, -side, c*side])
    l0(a, 1, 1, col);

    translate([a*side, 0, -side])
    l0(1, b, 1, col);
    translate([-side, 0, -side])
    l0(1, b, 1, col);

    translate([0, b*side, -side])
    l0(a, 1, 1, col);
    translate([0, -side, -side])
    l0(a, 1, 1, col);

    translate([a*side, b*side, 0])
    l0(1, 1, c, col);
    translate([-side, b*side, 0])
    l0(1, 1, c, col);

    translate([a*side, -side, 0])
    l0(1, 1, c, col);
    translate([-side, -side, 0])
    l0(1, 1, c, col);
}

module l3(a, b, c) {
    col = "green";
 
    translate([0, 0, side*(c+2)])
    l0(a, b, 1, col);
    translate([0, 0, -side*3])
    l0(a, b, 1, col);
    
    translate([0, side*(b+2), 0])
    l0(a, 1, c, col);
    translate([0, -side*3, 0])
    l0(a, 1, c, col);
    
    translate([side*(a+2), 0, 0])
    l0(1, b, c, col);
    translate([-side*3, 0, 0])
    l0(1, b, c, col); 
    //==================================
    translate([(a+1)*side, 0, c*side])
    l0(1, b, 1, col);
    translate([a*side, 0, (c+1)*side])
    l0(1, b, 1, col);
    translate([-side*2, 0, c*side])
    l0(1, b, 1, col);
    translate([-side, 0, (c+1)*side])
    l0(1, b, 1, col);

    translate([0, (b+1)*side, c*side])
    l0(a, 1, 1, col);
    translate([0, -side*2, c*side])
    l0(a, 1, 1, col);
    translate([0, b*side, (c+1)*side])
    l0(a, 1, 1, col);
    translate([0, -side, (c+1)*side])
    l0(a, 1, 1, col);

    translate([a*side, 0, -side*2])
    l0(1, b, 1, col);
    translate([-side, 0, -side*2])
    l0(1, b, 1, col);
    translate([(a+1)*side, 0, -side])
    l0(1, b, 1, col);
    translate([-side*2, 0, -side])
    l0(1, b, 1, col);

    translate([0, b*side, -side*2])
    l0(a, 1, 1, col);
    translate([0, -side, -side*2])
    l0(a, 1, 1, col);
    translate([0, (b+1)*side, -side])
    l0(a, 1, 1, col);
    translate([0, -side*2, -side])
    l0(a, 1, 1, col);

    translate([(a+1)*side, b*side, 0])
    l0(1, 1, c, col);
    translate([-side*2, b*side, 0])
    l0(1, 1, c, col);
    translate([a*side, (b+1)*side, 0])
    l0(1, 1, c, col);
    translate([-side, (b+1)*side, 0])
    l0(1, 1, c, col);

    translate([(a+1)*side, -side, 0])
    l0(1, 1, c, col);
    translate([-side*2, -side, 0])
    l0(1, 1, c, col);
    translate([a*side, -side*2, 0])
    l0(1, 1, c, col);
    translate([-side, -side*2, 0])
    l0(1, 1, c, col);
    
    // corners
    translate([-side, -side, side])
    l0(1, 1, 1, col);
    translate([-side, -side, -side])
    l0(1, 1, 1, col);

    translate([a*side, -side, side])
    l0(1, 1, 1, col);
    translate([a*side, -side, -side])
    l0(1, 1, 1, col);

    translate([a*side, b*side, side])
    l0(1, 1, 1, col);
    translate([a*side, b*side, -side])
    l0(1, 1, 1, col);

    translate([-side, b*side, side])
    l0(1, 1, 1, col);
    translate([-side, b*side, -side])
    l0(1, 1, 1, col);
}

l0(da, db, dc);
l1(da, db, dc);
l2(da, db, dc);
l3(da, db, dc);

