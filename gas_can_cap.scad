o=0.1;

module cap() {
	inner_diameter=21;
	outer_diameter=inner_diameter*1.2;
	inner_dz= 15;
	outer_dz= inner_dz*1.2;
	thread_depth= 1.5;
	thread_height= 2;
	thread_pitch= 3.2;
	thread_granularity= 0.05;
	difference() {
		cylinder(r=outer_diameter/2, h=outer_dz, $fn=100);
		translate([0,0,-0.001])
		union() {
			cylinder(r=inner_diameter/2, h=inner_dz, $fn=100);
			intersection() {
				union() {
					for (z= [-thread_height/2 : thread_granularity : inner_dz+thread_height/2]) {
						hull() {
							for (zz= [ z, z+thread_granularity+0.001 ])
								rotate(zz*360/thread_pitch, [0,0,1])
									translate([ inner_diameter/2, 0, zz ])
										rotate(90, [1,0,0])
											cylinder(r=thread_height/2, h=0.01, $fn=10);
						}
					}
				}
				translate([-100,-100,0]) cube([200,200,inner_dz]);
			}
		}
	}
}

cap();