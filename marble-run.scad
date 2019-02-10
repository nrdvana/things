block_side=45;
block_height=22.5;
chute_rad= 10;
chute_depth= 12.5;
chute_z= block_height-chute_depth+chute_rad;
o= .001;
oo= .000000000000001;
curve_step= 4;
flat_mag_rad= 6.4/2;
flat_mag_thick= 1.62;
magchute_rad= 10;
magchute_w= 28;
magchute_h= 14;
magchute_upper_rad= magchute_w/5 - sqrt(-(magchute_w*magchute_w) / 20 + magchute_rad*magchute_rad/5 + magchute_w*magchute_w/25);

//(w/2 - 2*ur)^2 + ur^2 = r^2
//(w/2)^2 + 2 * (-w*ur) + 4*ur^2 + ur^2 = r^2
//w^2/4 - 2*w*ur + 5*ur^2 = r^2
//w^2/20 - 2/5*w*ur + ur^2 = r^2 / 5
//ur^2 - 2*w/5*ur + w^2/25 = r^2 / 5 - w^2/20 + w^2/25
//(ur - w/5)^2 = r^2 / 5 - w^2/20 + w^2/25
//ur - w/5 = sqrt(r^2 / 5 - w^2/20 + w^2/25)
//ur = w/5 + sqrt(r^2 / 5 - w^2/20 + w^2/25);

magchute_mag_veneer= 0.2;

module curl_270() {
	$fn=50;
	difference() {
		union() {
			cube([ block_side, block_side*2, block_height*2 ]);
			translate([ 0, block_side, 0 ])
				cube([ block_side*2, block_side, block_height ]);
		}
		translate([ block_side, block_side, chute_z ]) {
			for (r1= [180 : curve_step : 270]) {
				r2= r1+curve_step;
				hull() {
					rotate(r1, [0,0,1]) translate([ block_side/2, 0, block_height*.6+(r1-180)/90*block_height*.4 ]) {
						translate([ -chute_rad, 0, 0 ]) cube([ chute_rad*2, oo, block_height*2 ]);
						rotate(90, [1,0,0]) cylinder(r=chute_rad, h=oo);
					}
					rotate(r2, [0,0,1]) translate([ block_side/2, 0, block_height*.6+(r2-180)/90*block_height*.4 ]) {
						translate([ -chute_rad, 0, 0 ]) cube([ chute_rad*2, oo, block_height*2 ]);
						rotate(90, [1,0,0]) cylinder(r=chute_rad, h=oo);
					}
				}
			}
			for (r1= [0 : curve_step : 180]) {
				r2=r1+curve_step;
				hull() {
					rotate(r1, [0,0,1]) translate([ block_side/2, 0, r1/180*block_height*.6 ])
						rotate(90, [1,0,0]) cylinder(r=chute_rad, h=oo);
					rotate(r2, [0,0,1]) translate([ block_side/2, 0, r2/180*block_height*.6 ])
						rotate(90, [1,0,0]) cylinder(r=chute_rad, h=oo);
				}
			}
		}
	}
}

//mirror([0,1,0]) curl_270();

module shim() {
	$fn=300;
	a= 13;
	b= chute_rad;
	c= sqrt(a*a+b*b);
	difference() {
		cube([ block_side, block_side, block_height*.25 ]);
		translate([ -o, block_side/2, block_height*.25+a ])
			rotate(90, [0,1,0])
			cylinder(h=block_side+o*2, r=c);
		translate([ block_side/2, block_side/2, -o ])
			cylinder(h=block_height, r=chute_rad);
	}
}

//shim();

module side_entry_ramp(ramp_len=block_side*1.5) {
	$fn= 80;
	difference() {
		union() {
			intersection() {
				cube([ block_side, block_side*1, block_height*2 ]);
				translate([ block_side, block_side, -o ])
					cylinder(r=block_side, h=block_height*2+o);
			}
			translate([ 0, block_side-o, 0]) cube([ block_side, ramp_len+o*2, block_height ]);
			intersection() {
				translate([ 0, block_side*2, 0 ])
					cube([ block_side, ramp_len, block_height ]);
				translate([ block_side, block_side+ramp_len, -o ])
					cylinder(r=block_side, h=block_height*2+o);
			}
		}
		translate([ block_side, block_side, block_height+chute_z ]) rotate(90, [0,0,1]) {
			for (r1= [0 : curve_step : 90]) {
				r2= r1+curve_step+o;
				hull() {
					rotate(-r1, [0,0,1]) translate([ -block_side/2, 0, r1/90 * -16 ]) {
						translate([ -chute_rad, 0, 0 ]) cube([ chute_rad*2, o, block_height*2 ]);
						rotate(90, [1,0,0]) cylinder(r=chute_rad, h=o);
					}
					rotate(-r2, [0,0,1]) translate([ -block_side/2, 0, r2/90 * -16 ]) {
						translate([ -chute_rad, 0, 0 ]) cube([ chute_rad*2, o, block_height*2 ]);
						rotate(90, [1,0,0]) cylinder(r=chute_rad, h=o);
					}
				}
			}
		}
		hull() {
			translate([ block_side/2, block_side-o, block_height-16+chute_z ])
				rotate(90, [1,0,0]) cylinder(r=chute_rad,h=o);
			translate([ block_side/2, block_side+ramp_len+o, chute_z ])
				rotate(90, [1,0,0]) cylinder(r=chute_rad,h=o);
		}
		intersection() {
			translate([ 0, block_side + ramp_len,0]) cube([block_side+o, block_side, block_side]);
			translate([ block_side, block_side + ramp_len, chute_z ])
				rotate_extrude(angle=90+o, convexity=2)
					translate([ block_side/2, 0, 0 ]) circle(r=chute_rad);
		}
	}
}

// mirror([1,0,0]) side_entry_ramp();

module magchute_magslots(dir=1) {
	translate([0, 0, flat_mag_rad*1.1])
		rotate(dir*-90, [1,0,0]) translate([ 0, 0, magchute_mag_veneer ]) {
			$fn= 6;
			hull() {
				translate([ -magchute_w/2+flat_mag_rad*1.5, 0, 0 ]) cylinder(r=flat_mag_rad, h=flat_mag_thick);
				translate([ -magchute_w/2+flat_mag_rad*1.5, dir*flat_mag_rad*2, 0 ]) cylinder(r=flat_mag_rad, h=flat_mag_thick);
			}
			hull() {
				translate([  magchute_w/2-flat_mag_rad*1.5, 0, 0 ]) cylinder(r=flat_mag_rad, h=flat_mag_thick);
				translate([  magchute_w/2-flat_mag_rad*1.5, dir*flat_mag_rad*2, 0 ]) cylinder(r=flat_mag_rad, h=flat_mag_thick);
			}
		}
}

module magchute_straight(len=magchute_w*2) {
	$fn=400;
	union() {
		intersection() {
			difference() {
				cube([ magchute_w, len, magchute_h-magchute_upper_rad ]);
				translate([ magchute_w/2, -o, magchute_h ])
					rotate(-90, [1,0,0])
						cylinder(r=magchute_rad, h=len+o*2);
				translate([ magchute_w/2, 0, 0 ]) magchute_magslots(1);
				translate([ magchute_w/2, len, 0 ]) magchute_magslots(-1);
			}
			translate([ magchute_w/2, -o, magchute_h*.55 ])
				rotate(-90, [1,0,0])
					cylinder(r=magchute_rad*1.47, h=len+o*2);
		}
		translate([ magchute_upper_rad, 0, magchute_h-magchute_upper_rad ])
			rotate(-90, [1,0,0]) cylinder(r=magchute_upper_rad, h=len);
		translate([ magchute_w - magchute_upper_rad, 0, magchute_h - magchute_upper_rad ])
			rotate(-90, [1,0,0]) cylinder(r=magchute_upper_rad, h=len);
	}
}

magchute_straight();