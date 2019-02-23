o=.001;
outer_diam_top  = 11.5;
outer_diam_base = 13;
inner_diam_top  = 8;
inner_diam_base = 9.5;
hole_diam       = 5;
outer_h         = 20.5;
inner_h         = 18.5;
shell_thick     = (outer_diam_base - inner_diam_base) / 2;

module roundrect(w=1,h=1,r=.1,center=true) {
    translate([ (center? -w/2 : 0), (center? -h/2 : 0) ])
    hull() {
        translate([r,r]) circle(r=r);
        translate([w-r,r]) circle(r=r);
        translate([r,h-r]) circle(r=r);
        translate([w-r,h-r]) circle(r=r);
    }
}
module game_piece() {
	$fn=90;
	rotate_extrude() {
		hull() {
			translate([ -outer_diam_base/2, 0 ]) roundrect(w=shell_thick, h=.001, center=false);
			translate([ -outer_diam_top/2 + shell_thick/2, outer_h - shell_thick/2 ]) circle(r=shell_thick/2);
		}
        hull() {
			translate([ -outer_diam_top/2 + shell_thick/2, outer_h - shell_thick/2 ]) circle(r=shell_thick/2);
			translate([ -hole_diam/2 - shell_thick/2, outer_h - shell_thick/2 ]) roundrect(w=shell_thick, h=shell_thick, r=shell_thick/6);
        }
	}
}

game_piece();