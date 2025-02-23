module shell(out_r, thick, prec=100) {
    difference() {
        sphere(out_r, $fn=prec);
        sphere(out_r - thick, $fn=prec);
    }
}

