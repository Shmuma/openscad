include <BOSL2/std.scad>

sx = 10;  // x step
sy = sqrt(3) * sx;  // y step, according to the drawing, figure P5 has to have right angle
echo(sy);
thick = 2;

P1 = [
      [0, 0],
      [3*sx, sy],
      [sx, sy],
      [0, 2*sy],
      [-sx, sy],
      [-3*sx, sy]
];

P2 = [[0, 0], [3*sx, sy], [-sx, sy]];
P3 = [[0, 0], [4*sx, 0], [3*sx, sy]];
P4 = [[0, 0], [6*sx, 0], [3*sx, sy], [sx, sy]];
P5 = [[0, 0], [sx, sy], [0, 2*sy], [-sx, sy], [-3*sx, sy]];


linear_extrude(thick) {
  move([10*sx, 0])
    polygon(P1);

  move([3*sx, 0])
    polygon(P2);
  
  move([3*sx, 2*sy])
    polygon(P3);

  move([-4*sx, 0])
    polygon(P4);
  
  move([0, sy])
    polygon(P5);
}
