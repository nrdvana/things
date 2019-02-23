o= .001;
oo= .000000000000001;

block_side=45;
block_height=22.5;
chute_rad= 10;
chute_depth= 12.5;
chute_z= block_height-chute_depth+chute_rad;
curve_step= 4;

flat_mag_rad= 4; //6.4/2;
flat_mag_thick= 1.8; //1.62;
magchute_mag_veneer= 0.2;

magchute_w= 28;
magchute_h= 14;
magchute_upper_rad= magchute_w/5 - sqrt(-(magchute_w*magchute_w) / 20 + chute_rad*chute_rad/5 + magchute_w*magchute_w/25);

wallchute_face_z= chute_rad*.6;
wallchute_face_dz= chute_rad*2;
wallchute_face_dx= 4;
wallchute_base_dx= wallchute_face_dx + chute_rad*1.7;
wallchute_base_dz= 6;
wallchute_cyl_x= wallchute_face_dx+chute_rad;
wallchute_cyl_z= 2+chute_rad;
wallchute_e1_angle= -acos((wallchute_base_dx - chute_rad - wallchute_face_dx)/chute_rad);
//((wallchute_base_dx - (chute_rad + wallchute_face_dx)) / chute_rad);

//(wallchute_base_dx - (chute_rad + wallchute_face_dx)) / chute_rad
//(wallchute_face_dx + chute_rad*1.7 - (chute_rad + wallchute_face_dx)) / chute_rad
//(wallchute_face_dx + chute_rad + chute_rad*.7 - chute_rad - wallchute_face_dx)/chute_rad

wallchute_e1_r= .5;
wallchute_e1_x= wallchute_cyl_x + cos(wallchute_e1_angle)*chute_rad + cos(wallchute_e1_angle)*wallchute_e1_r;
wallchute_e1_z= wallchute_cyl_z + sin(wallchute_e1_angle)*chute_rad + sin(wallchute_e1_angle)*wallchute_e1_r;
wallchute_e2_r= .75;
wallchute_e2_x= wallchute_e1_x + wallchute_e1_r - wallchute_e2_r;
wallchute_e2_z= wallchute_e2_r;
wallchute_e3_r=.5;
wallchute_e3_x= wallchute_e3_r;
wallchute_e3_z= wallchute_e3_r;
wallchute_e4_r= .5;
wallchute_e4_x= wallchute_e4_r;
wallchute_e4_z= wallchute_face_dz - wallchute_e4_r;
wallchute_e5_r= .5;
wallchute_e5_x= wallchute_face_dx - wallchute_e5_r;
wallchute_e5_z= wallchute_face_dz - wallchute_e5_r;

//(w/2 - 2*ur)^2 + ur^2 = r^2
//(w/2)^2 + 2 * (-w*ur) + 4*ur^2 + ur^2 = r^2
//w^2/4 - 2*w*ur + 5*ur^2 = r^2
//w^2/20 - 2/5*w*ur + ur^2 = r^2 / 5
//ur^2 - 2*w/5*ur + w^2/25 = r^2 / 5 - w^2/20 + w^2/25
//(ur - w/5)^2 = r^2 / 5 - w^2/20 + w^2/25
//ur - w/5 = sqrt(r^2 / 5 - w^2/20 + w^2/25)
//ur = w/5 + sqrt(r^2 / 5 - w^2/20 + w^2/25);


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
						cylinder(r=chute_rad, h=len+o*2);
				translate([ magchute_w/2, 0, 0 ]) magchute_magslots(1);
				translate([ magchute_w/2, len, 0 ]) magchute_magslots(-1);
			}
			translate([ magchute_w/2, -o, magchute_h*.55 ])
				rotate(-90, [1,0,0])
					cylinder(r=chute_rad*1.47, h=len+o*2);
		}
		translate([ magchute_upper_rad, 0, magchute_h-magchute_upper_rad ])
			rotate(-90, [1,0,0]) cylinder(r=magchute_upper_rad, h=len);
		translate([ magchute_w - magchute_upper_rad, 0, magchute_h - magchute_upper_rad ])
			rotate(-90, [1,0,0]) cylinder(r=magchute_upper_rad, h=len);
	}
}

//magchute_straight();

module wallchute_magslot() {
	$fn= 6;
	hull() {
		translate([ magchute_mag_veneer, 0, wallchute_face_dz - flat_mag_rad*1.5 ])
			rotate(90, [0,1,0]) cylinder(r=flat_mag_rad, h=flat_mag_thick);
		translate([ magchute_mag_veneer, 0, wallchute_face_dz + flat_mag_rad*1.5 ])
			rotate(90, [0,1,0]) cylinder(r=flat_mag_rad, h=flat_mag_thick);
	}
}

module wallchute_outline() {
	difference() {
		union() {
			$fn= 100;
			// back wall
			translate([ 0, wallchute_e3_z ])
				square([ wallchute_face_dx, wallchute_face_dz - wallchute_e3_z - wallchute_e4_r ]);
			// fill corner up to cylinder cutout
			translate([ 0, wallchute_e3_z ])
				square([ wallchute_cyl_x, wallchute_cyl_z - wallchute_e3_z ]);
			// fill base
			translate([ 0, wallchute_e3_z ])
				square([ wallchute_e1_x, wallchute_e1_z - wallchute_e3_z - sin(wallchute_e1_angle)*wallchute_e1_r ]);
			// top
			hull() {
				translate([ wallchute_e4_x, wallchute_e4_z ])
					circle(r=wallchute_e4_r);
				translate([ wallchute_e5_x, wallchute_e5_z ])
					circle(r=wallchute_e5_r);
			}
			// front
			hull() {
				translate([ wallchute_e1_x, wallchute_e1_z ])
					circle(r=wallchute_e1_r);
				translate([ wallchute_e2_x, wallchute_e2_z ])
					circle(r=wallchute_e2_r);
			}
			// base
			hull() {
				translate([ wallchute_e2_x, wallchute_e2_z ])
					circle(r=wallchute_e2_r);
				translate([ wallchute_e3_x, wallchute_e3_z ])
					circle(r=wallchute_e3_r);
			}
		}
		$fn= 360;
		translate([ wallchute_cyl_x, wallchute_cyl_z ])
			circle(r=chute_rad);
	}
}

module wallchute_straight(len=40) {
	difference() {
		extrude(convexity=4) {
			translate([0,len,0]) rotate(90, [1,0,0]) wallchute_outline();
			rotate(90, [1,0,0]) wallchute_outline();
		}
		// cutouts for magnets
		translate([ 0, 10, 0 ]) wallchute_magslot();
		translate([ 0, len-10, 0 ]) wallchute_magslot();
	}
}

module wallchute_curve(rad=40, arc=30) {
	difference() {
		extrude(convexity=6) {
			for (r=[0:1:arc], union=false) {
				translate([0,rad]) rotate(-r, [1,0,0]) translate([0,-rad])
					wallchute_outline();
			}
		}
		// cutouts for magnets
		translate([0,rad]) rotate(90-arc/2, [1,0,0]) //translate([0,-rad])
			wallchute_magslot();
	}
}

module wallchute_wave(len=160) {
    dz=0;//len/10;
    amplitude= 7;
    difference() {
        extrude(convexity=6) {
            for (t=[1:1:len], union=false) {
                translate([0,-t,t/len*dz + amplitude*cos(t/len*360*2)])
                    rotate(90, [1,0,0]) wallchute_outline();
            }
        }
        translate([ 0, -10, 0 ]) wallchute_magslot();
        translate([ 0, -len+10, 0 ]) wallchute_magslot();
    }
}

//wallchute_curve();
//wallchute_straight(len=160);
wallchute_wave();