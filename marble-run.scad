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
wallchute_base_thick= 2;
wallchute_cyl_x= wallchute_face_dx+chute_rad;
wallchute_cyl2_x= wallchute_face_dx+chute_rad*3;
wallchute_cyl_z= wallchute_base_thick+chute_rad;
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
wallchute_e3_r= .5;
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

module corner_anchor(r=10) {
    translate([ -r/2, -r/2, 0 ]) cube([ r, r, .2 ]);
    translate([ -1.02*r/2, -1.02*r/2, .2 ]) cube([ 1.02*r, 1.02*r, .2 ]);
    translate([ -.4*r/2, -.4*r/2, .4 ]) cube([ .4*r, .4*r, .2 ]);
}

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
    $fn= 100;
	difference() {
		union() {
			// back wall
			translate([ 0, wallchute_e3_z ])
				square([ wallchute_face_dx, wallchute_face_dz - wallchute_e3_z - wallchute_e4_r ]);
			// top
			hull() {
				translate([ wallchute_e4_x, wallchute_e4_z ])
					circle(r=wallchute_e4_r);
				translate([ wallchute_e5_x, wallchute_e5_z ])
					circle(r=wallchute_e5_r);
			}
			// fill corner up to cylinder cutout
			translate([ 0, wallchute_e3_z ])
				square([ wallchute_cyl_x, wallchute_cyl_z - wallchute_e3_z ]);
			// fill base
			translate([ 0, wallchute_e3_z ])
				square([ wallchute_e1_x, wallchute_e1_z - wallchute_e3_z - sin(wallchute_e1_angle)*wallchute_e1_r ]);
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
		translate([ wallchute_cyl_x, wallchute_cyl_z ])
			circle(r=chute_rad, $fn=360);
	}
}

module wallchute_base_outline(chute_center_x=wallchute_cyl_x, support_x= 0, chute_outer_arc=-wallchute_e1_angle, chute_inner_arc=-wallchute_e1_angle, corner_rad=.5) {
	chute_outer_dx= sin(chute_outer_arc) * chute_rad;
	chute_outer_dz= wallchute_cyl_z - cos(chute_outer_arc) * chute_rad;
	chute_inner_dx= -sin(chute_inner_arc) * chute_rad;
	chute_inner_dz= wallchute_cyl_z - cos(chute_inner_arc) * chute_rad;
	wall_outer_dx= chute_outer_dx + sin(chute_outer_arc) * corner_rad;
	wall_outer_dz= chute_outer_dz - cos(chute_outer_arc) * corner_rad;
	wall_inner_dx= chute_inner_dx - sin(chute_inner_arc) * corner_rad;
	wall_inner_dz= chute_inner_dz - cos(chute_inner_arc) * corner_rad;
	$fn= 100;
	translate([ chute_center_x, 0 ]) {
		// outer wall
		hull() {
			translate([ wall_outer_dx, wall_outer_dz ]) circle(r=corner_rad);
			translate([ wall_outer_dx, corner_rad ]) circle(r=corner_rad);
		}
		// inner
		hull() {
			translate([ wall_inner_dx, corner_rad ]) circle(r=corner_rad);
			translate([ wall_inner_dx, wall_inner_dz ]) circle(r=corner_rad);
			if (support_x) {
				translate([ wall_inner_dx-support_x, corner_rad ]) circle(r=corner_rad);
				translate([ wall_inner_dx-support_x, wall_inner_dz ]) circle(r=corner_rad);
			}
		}
		difference() {
			polygon([
				[ chute_outer_dx, chute_outer_dz ], [ wall_outer_dx, 0 ],
				[ wall_inner_dx, 0 ], [ chute_inner_dx, chute_inner_dz ]
			]);
			translate([ 0, wallchute_cyl_z ])
				circle(r=chute_rad, $fn=360);
		}
	}
}

module wallchute_backing_outline() {
	$fn=100;
	hull() {
		translate([ wallchute_e4_x, wallchute_e4_z ])
			circle(r=wallchute_e4_r);
		translate([ wallchute_e5_x, wallchute_e5_z ])
			circle(r=wallchute_e5_r);
		translate([ wallchute_e3_x, wallchute_e3_z ])
			circle(r=wallchute_e3_r);
		translate([ wallchute_e5_x, wallchute_e3_z ])
			circle(r=wallchute_e5_r);
	}
}

module wallchute_straight(len=40, anchor_at_0=true) {
	rotate(-90, [0,1,0]) difference() {
		extrude(convexity=4) {
			translate([0,len,0]) rotate(90, [1,0,0]) wallchute_outline();
			rotate(90, [1,0,0]) wallchute_outline();
		}
		// cutouts for magnets
		translate([ 0, len*.25, 0 ]) wallchute_magslot();
		translate([ 0, len*.75, 0 ]) wallchute_magslot();
	}
    // hold down corners
    if (anchor_at_0) {
        corner_anchor();
        translate([ -wallchute_base_dx, 0, 0 ]) corner_anchor();
    }
    translate([ 0, len, 0 ]) corner_anchor();
    translate([ -wallchute_base_dx, len, 0 ]) corner_anchor();
}

module wallchute_curve(rad=40, arc=30, anchor_at_0=true) {
	rotate(-90, [0,1,0]) difference() {
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
    // hold down corners
    if (anchor_at_0)
        corner_anchor();
	translate([0,rad]) rotate(-arc, [0,0,1]) translate([0,-rad]) corner_anchor();
    //translate([ -amplitude, -len, 0 ]) corner_anchor();
	//translate([0,rad]) rotate(90-arc/2, [1,0,0]) //translate([0,-rad])
    //translate([ -wallchute_base_dx-amplitude, -len, 0 ]) corner_anchor();
}

module wallchute_wave(len=160, step=3, dz=0, amplitude=7) {
    rotate(-90, [0,1,0]) difference() {
        extrude(convexity=6) {
            for (t=[0:step:len+o], union=false) {
                translate([0,-t,t/len*dz + amplitude*cos(t/len*360*2)])
                    rotate(90, [1,0,0]) wallchute_outline();
            }
        }
        translate([ 0, -len*.25, .25*dz + amplitude*cos(.25*360*2) ]) wallchute_magslot();
        translate([ 0, -len*.75, .75*dz + amplitude*cos(.75*360*2) ]) wallchute_magslot();
    }
    // hold down corners
    translate([ -amplitude, 0, 0 ]) corner_anchor();
    translate([ -wallchute_base_dx-amplitude, 0, 0 ]) corner_anchor();
    translate([ -amplitude, -len, 0 ]) corner_anchor();
    translate([ -wallchute_base_dx-amplitude, -len, 0 ]) corner_anchor();
}

module wallchute_straight_curve(arc=30, len=80) {
    rotate(-90, [0,0,1]) wallchute_straight(len=len, anchor_at_0=false);
    wallchute_curve(arc=arc, anchor_at_0=false);
}

module wallchute_extend(radius=60) {
	arc= acos(1-(wallchute_cyl2_x - wallchute_cyl_x)/radius/2);
	step= arc/30;
	base_len= 50;
	rotate(-90, [0,1,0]) {
		difference() {
			rotate(90, [1,0,0]) translate([wallchute_cyl_x,0,0]) {
				extrude(convexity=6) for(a=[0:step:arc+o], union=false) {
					translate([radius,0,0]) rotate(a, [0,1,0]) translate([-radius,0,0])
						wallchute_base_outline(chute_center_x=0, chute_inner_arc=90, support_x=wallchute_cyl2_x);
				}
				extrude(convexity=6) for(a=[-o:step:arc+o], union=false) {
					translate([radius,0,0]) rotate(arc, [0,1,0]) translate([-radius*2,0,0]) rotate(-a, [0,1,0]) translate([radius,0,0])
						wallchute_base_outline(chute_center_x=0, chute_inner_arc=90, chute_outer_arc=60, support_x=19.2-19.1*a/arc);
				}
			}
			translate([ -100, -100, -o ]) cube([ 100, 100+o, 100 ]);
		}
		difference() {
			scale([ 1,1,1.5]) rotate(90, [1,0,0]) linear_extrude(height=base_len)
				wallchute_backing_outline();
			// cutouts for magnets
			translate([ 0, -base_len+8, wallchute_face_dz/2 ]) wallchute_magslot();
			translate([ 0, -base_len*.2, wallchute_face_dz/2 ]) wallchute_magslot();
		}
	}
    // hold down corners
	corner_anchor();
	translate([ -wallchute_base_dx*1.5, 0 ]) corner_anchor();
	translate([ 0, -base_len, 0 ]) corner_anchor();
	translate([ -wallchute_base_dx*1.5, -base_len, 0 ]) scale([ 1,.8, 1]) corner_anchor();
}

module far_spiral_quarter(dz= (wallchute_cyl_z+chute_rad)/4, arc=90, radius=chute_rad) {
	steps=ceil($fn/4);
	extrude(convexity=6) for(a=[0:arc/steps:arc+o], union=false) {
		translate([ 0, 0, a/90 * dz ]) rotate(90+a, [0,0,1]) translate([ -radius, 0 ]) 
			rotate(90, [1,0,0]) {
				translate([ 0, wallchute_cyl_z ]) rotate(-(1-a/arc)*20, [0,0,1]) translate([ 0, -wallchute_cyl_z ])
				wallchute_base_outline(chute_center_x=0, chute_inner_arc=60, chute_outer_arc=60, support_x=o);
			}
	}
}

module near_spiral_quarter(dz= (wallchute_cyl_z+chute_rad)/4, arc=90, radius=chute_rad) {
	steps=ceil($fn/4);
	extrude(convexity=6) for(a=[0:(arc+o)/steps:arc+o+o], union=false) {
		translate([ 0, 0, a/90 * dz ]) rotate(a, [0,0,1]) translate([ -radius, 0 ]) 
			rotate(90, [1,0,0]) {
				translate([ 0, wallchute_cyl_z ]) rotate(-a/arc*20, [0,0,1]) translate([ 0, -wallchute_cyl_z ])
				wallchute_base_outline(chute_center_x=0, chute_inner_arc=60, chute_outer_arc=60,
					support_x=o+(a < 20? radius : (sqrt(1 + sin(90-a)*sin(90-a))-1) * (radius+chute_rad+.6) ));
			}
	}
}

module wallchute_loopback(dz= (wallchute_cyl_z+chute_rad), with_support=true) {
	entry_exit_len= 10;
	back_y0= -chute_rad*2;
	back_y1= entry_exit_len;
	steps=1+ceil($fn/6);
	difference() {
		translate([ (wallchute_cyl2_x+wallchute_cyl_x)/2, 0 ]) {
			// outer ramp into spiral
			extrude(convexity=6) for(t=[0:1/steps:1+o], union=false) {
				translate([ 0, (1-t) * entry_exit_len, dz*.9 + dz*.1 * cos(t*90) ]) rotate(90, [1,0,0])
					wallchute_base_outline(chute_center_x=chute_rad, chute_inner_arc=60, chute_outer_arc=60,
						support_x=(with_support? o+(1.1-t)*(1.1-t)*30 : 0));
			}
			// outer quarter spiral
			translate([ 0, 0, dz*.5 ]) far_spiral_quarter(dz=dz*.4);
			// inner quarter spiral
			translate([ 0, 0, dz*.1 ]) near_spiral_quarter(dz=dz*.4);
			// inner ramp out of spiral
			extrude(convexity=6) for(t=[0:1/steps:1+o], union=false) {
				translate([ 0, (1-t) * entry_exit_len, dz*.1 * (1-cos(t*90)) ]) rotate(90, [1,0,0])
					wallchute_base_outline(chute_center_x=-chute_rad, chute_inner_arc=60, chute_outer_arc=60, support_x=2);
			}
		}
		translate([ -100, -100, o ]) cube([100,200,100]);
	}		
	difference() {
		translate([ 0, back_y1 ]) scale([ 1,1,1.5]) rotate(90, [1,0,0]) linear_extrude(height=back_y1-back_y0)
			wallchute_backing_outline();
		// cutouts for magnets
		translate([ 0, (back_y0+back_y1)/2, wallchute_face_dz/2 ]) wallchute_magslot();
		//translate([ 0, back_y1 - 5, wallchute_face_dz/2 ]) wallchute_magslot();
	}
}

module wallchute_spiral(arc=360, radius=chute_rad) {
	dz= wallchute_cyl_z+chute_rad;
	step=30;
	extrude(convexity=6) for(a=[0:step:arc+o], union=false) {
		translate([ 0, 0, a/360 * dz ]) rotate(a, [0,0,1]) translate([ -radius, 0 ]) 
			rotate(90, [1,0,0]) wallchute_base_outline(chute_center_x=0, chute_inner_arc=65, chute_outer_arc=60, support_x=2);
	}
}

//wallchute_curve();
//rotate(-90,[0,0,1]) wallchute_straight(len=10);
//wallchute_wave(step=1);
//wallchute_straight_curve();
//mirror([1,0,0]) wallchute_extend();
wallchute_loopback($fn=20, with_support=false);
//translate([ -70, 0, 0 ]) wallchute_loopback();
