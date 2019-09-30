// Select keyboard or mouse
device = "Keyboard"; // ["Keyboard","Mouse"]

module battcover(
	x0= 0,
	dx= 60,
	dy= 15.8,
	dz= 2.25,
	corner_rad= 1.8,
	tab1_x= 13.5,
	tab2_x= 38.1,
	tab_dx= 5,
	tab_dy= 1.5,
	tab_dz= 1.2,
	tab_z= 2.25,
	clip_slot_x0= 6,
	clip_slot_x1= 45.2,
	clip_slot_y0= -3.5,
	clip_slot_y1= -1.5,
	clip_dx= 4,
	clip_dy= .6,
	keyboard= true,
	o=0.01
) {
	difference() {
		translate([ x0, 0, 0 ]) extrude() {
			hull() {
				translate([ corner_rad, corner_rad, 0 ]) circle(r=corner_rad);
				translate([ dx - corner_rad, corner_rad, 0 ]) circle(r=corner_rad);
				translate([ dx - corner_rad, dy - corner_rad, 0 ]) circle(r=corner_rad);
				translate([ corner_rad, dy - corner_rad, 0 ]) circle(r=corner_rad);
			}
			translate([.25,0,dz]) scale([(dx-.5)/dx, (dy-.5)/dy, 1]) hull() {
				translate([ corner_rad, corner_rad, 0 ]) circle(r=corner_rad);
				translate([ dx - corner_rad, corner_rad, 0 ]) circle(r=corner_rad);
				translate([ dx - corner_rad, dy - corner_rad, 0 ]) circle(r=corner_rad);
				translate([ corner_rad, dy - corner_rad, 0 ]) circle(r=corner_rad);
			}
		}
		translate([ clip_slot_x0, dy + clip_slot_y0, -o ])
			cube([ clip_slot_x1 - clip_slot_x0, clip_slot_y1 - clip_slot_y0, 10 ]);
	}
	for (x=[tab1_x, tab2_x]) {
		translate([ 0, 0, tab_z ]) rotate(-10, [1,0,0])
			translate([ x - tab_dx/2, -tab_dy, 0 ])
				cube([ tab_dx, tab_dy+2, tab_dz ]);
	}
	translate([ (clip_slot_x0+clip_slot_x1)/2 - clip_dx/2, dy, tab_z ])
		rotate(10, [1,0,0]) translate([0, clip_slot_y1, 0])
			cube([ clip_dx, clip_dy + (clip_slot_y1-clip_slot_y0), tab_dz ]);
}

// Keyboard
if (device == "Keyboard") {
    battcover($fn=90, dx=60, x0= -2.06);
} else if (device == "Mouse") {
    battcover($fn=90, dx=51.2);
}
