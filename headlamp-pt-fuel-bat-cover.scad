o=0.001;
cap_rad_outer=25.15/2;
cap_rad_tip=19.5/2;
cap_rad_inner=22.7/2;
cap_outerrad_z=1.95;
cap_dz=2.68;
cap_slope=cap_outerrad_z/(cap_rad_outer-cap_rad_tip);
cap_bevel_slope=(cap_dz-cap_outerrad_z)/(cap_rad_outer-cap_rad_inner);
hinge_angle=-15+180;
hinge_cut_dx=13.15;
hinge_cut_y=sqrt(cap_rad_outer*cap_rad_outer - (hinge_cut_dx/2)*(hinge_cut_dx/2));
hinge_dx=6.3 - .2; // subtract a little for clearance
hinge_pin_rad=1.02/2 + .1; // add a litle for printer overshoot
hinge_pin_y=1.7 + hinge_cut_y;
hinge_pin_z=1.3;
hinge_outer_y=3.3 + hinge_cut_y;
clip_latch_z2=5.2;
clip_latch_z1=3;
clip_latch_outer_rad= cap_rad_tip + (clip_latch_z1 / cap_slope);
clip_inner_y=11.6;
clip_catch_dx=9.7;
clip_dx=14;
clip_base_y=6;
clip_angle=90-atan(cap_slope);
clip_reach_dy=9;
clip_outer_y=11;
clip_thick=.5;
clip_wire_rad=1.5/2;
clip_edge_angle=acos(cap_rad_outer/40);//30;
spring_edge_x=-1;
spring_edge_y=10;
spring_edge_z=4.25;
spring_edge_r=1.8;
spring_bat_x=0;
spring_bat_y=6.2;
spring_bat_z=4.25;
spring_bat_neg_r=6.27/2;
spring_bat_pos_r=2;

module spring_base(r=1.8, wall_thick=1.1, base_dz=3, wall_dz=1, wall_arc1=0, wall_arc2=180) {
	// base for spring
	cylinder(r=r+wall_thick, h=base_dz);
	// walled curve around spring
	rotate(wall_arc1, [0,0,1])
		rotate_extrude(angle=wall_arc2-wall_arc1)
			translate([r,base_dz-o]) square([wall_thick,wall_dz]);
}

module battery_cover() {
	difference() {
		// main body of cap
		union() {
			//hull() {
				cylinder(r1=cap_rad_tip, r2=cap_rad_outer, h=cap_outerrad_z);
			//	translate([ 0, 7, 0]) scale([ .8, .6, 1 ])
			//		cylinder(r1=cap_rad_tip, r2=cap_rad_outer, h=cap_outerrad_z);
			//}
			translate([0,0,cap_outerrad_z-o])
				cylinder(r1=cap_rad_outer,r2=cap_rad_inner, h=cap_dz-cap_outerrad_z);
			intersection() {
				difference() {
					cylinder(r1=cap_rad_tip, r2=(cap_rad_tip+(clip_latch_z2 / cap_slope)), h=clip_latch_z2);
					translate([0,0,(clip_latch_z2-clip_latch_z1)])
						cylinder(r1=cap_rad_tip, r2=(cap_rad_tip+(clip_latch_z2 / cap_slope)), h=clip_latch_z2);
				}
				hull() {
					rotate(90-clip_edge_angle) cube([100,o,100]);
					rotate(90+clip_edge_angle) cube([100,o,100]);
				}
				cylinder(r=clip_latch_outer_rad, h=10);
			}
		}
		// minus left and right edge of clip
		translate([0, 0, cap_dz+cap_bevel_slope*cap_rad_inner]) {
			for (a=[90-clip_edge_angle,90+clip_edge_angle]) {
				rotate(a, [0,0,1]) rotate(90+atan(cap_bevel_slope), [0,1,0]) translate([ -20, 0, 0 ]) cylinder(r=20, h=100);
			}
		}
		//rotate(clip_edge_angle, [0,0,1]) translate([cap_rad_outer, -50, -o]) #cube([10, 100, 50]);
		//mirror([1,0,0]) rotate(clip_edge_angle, [0,0,1]) translate([cap_rad_outer, -50, -o]) #cube([10, 100, 50]);
		
		// minus hinge cutout
		rotate(hinge_angle, [0,0,1])
			translate([-hinge_cut_dx/2-o,hinge_cut_y,0])
				cube([hinge_cut_dx+o*2,10,10]);
		// minus holes for clip
		translate([0,clip_base_y,0]) {
			for (x=[-clip_catch_dx/2 - clip_wire_rad, clip_catch_dx/2 + clip_wire_rad])
				translate([x,0,0]) {
					rotate(-clip_angle, [1,0,0]) translate([ 0,0,-5 ]) cylinder(r=clip_wire_rad, h=50);
					rotate(90, [1,0,0]) cylinder(r=clip_wire_rad, h=clip_base_y*1.5);
					translate([0,-clip_base_y*1.5,-o]) cylinder(r=clip_wire_rad, h=10);
				}
		}
	}
	// hinge arch
	rotate(hinge_angle, [0,0,1]) {
		difference() {
			translate([-hinge_dx/2,0,0])
				cube([hinge_dx,hinge_outer_y,cap_dz]);
			translate([-hinge_dx/2 - o, hinge_pin_y - hinge_pin_rad, -o])
				cube([hinge_dx+o*2, hinge_pin_rad*2, hinge_pin_z+hinge_pin_rad+o]);
		}
	}
	// edge contact
	translate([spring_edge_x, spring_edge_y, cap_dz-o])
		spring_base(r=spring_edge_r, base_dz=spring_edge_z-cap_dz, wall_arc2=230);
	// battery contacts.  First two are negative, last is positive.
	for (a=[0:120:359]) {
		r=(a < 240? spring_bat_neg_r : spring_bat_pos_r);
		wall_dz=(a < 240? 1.8:1);
		wall_opening_a=(a < 240? 0 : 100);
		rotate(-60+a, [0,0,1]) translate([spring_bat_x, spring_bat_y, cap_dz-o])
			spring_base(r=r, base_dz=spring_bat_z-cap_dz, wall_dz=wall_dz, wall_arc1=wall_opening_a-120, wall_arc2=wall_opening_a+120);
	}
}

battery_cover($fn=180);
