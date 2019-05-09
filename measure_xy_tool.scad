// Tool for sizing coordinates in 2D, which can then be measured with a caliper

module measure_xy_tool_body(
	dx= 25,
	dy= 25,
	dz= 8.1,
	slot_flare= 3,
	slot_diam= 4,
	slot_housing_diam= 6,
	$fn=100,
	o= 0.01
) {
	difference() {
		hull() {
			cube([ dx, slot_housing_diam, dz ]);
			cube([ slot_housing_diam, dy, dz ]);
		}
		
		// x-axis slot (under)
		translate([ -o, slot_housing_diam/2 - slot_diam*.5*.9, -o ])
			cube([ dx+o*2, slot_diam*.9, slot_diam/2+o ]);
		translate([ -o, slot_housing_diam/2, slot_diam/2 ])
			rotate(90, [0,1,0]) cylinder(r=slot_diam/2, h=dy+o*2);
		
		// y-axis slot (over)
		translate([ slot_housing_diam/2 - slot_diam*.5*.9, -o, dz-slot_diam/2 ])
			cube([ slot_diam*.9, dy + o*2, slot_diam/2 + o ]);
		translate([ slot_housing_diam/2, -o, dz - slot_diam/2 ])
			rotate(-90, [1,0,0]) cylinder(r=slot_diam/2, h=dx+o*2);
	}
}

module measure_xy_tool_foot(
	dx= 100,
	dy= 20,
	dz= 1,
	foot_dz= 10,
	ridge_diam= 3.8,
	ridge_y= 3,
	$fn=100,
	o= 0.01
) {
	difference() {
		union() {
			cube([ dx, dy, dz ]);
			cube([ 1, dy, foot_dz ]);
			#translate([ 0, ridge_y-ridge_diam/2*.9, 0 ]) cube([ dx, ridge_diam*.9, dz+ridge_diam/2 ]); 
			translate([ 0, ridge_y, dz + ridge_diam/2 ]) rotate(90, [0,1,0]) cylinder(r=ridge_diam/2, h=dx);
		}
		translate([ 0, dy, -o ])
			rotate(90-atan((dy-1)/dx), [0,0,1])
				translate([ 0, -dx-dy, 0 ]) cube([ dx+dy, dx+dy+1, foot_dz+o*2 ]);
	}
}

measure_xy_tool_body();
//measure_xy_tool_foot(dx=160);
//measure_xy_tool_foot(dx=50, dy=30);