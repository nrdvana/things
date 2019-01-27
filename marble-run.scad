block_side=45;
block_height=22.5;
chute_rad= 10;
chute_depth= 12.5;
chute_z= block_height-chute_depth+chute_rad;
o= .001;
curve_step= 4;

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
						translate([ -chute_rad, 0, 0 ]) cube([ chute_rad*2, o, block_height*2 ]);
						rotate(90, [1,0,0]) cylinder(r=chute_rad, h=o);
					}
					rotate(r2, [0,0,1]) translate([ block_side/2, 0, block_height*.6+(r2-180)/90*block_height*.4 ]) {
						translate([ -chute_rad, 0, 0 ]) cube([ chute_rad*2, o, block_height*2 ]);
						rotate(90, [1,0,0]) cylinder(r=chute_rad, h=o);
					}
				}
			}
			for (r1= [0 : curve_step : 180]) {
				r2=r1+curve_step;
				hull() {
					rotate(r1, [0,0,1]) translate([ block_side/2, 0, r1/180*block_height*.6 ])
						rotate(90, [1,0,0]) cylinder(r=chute_rad, h=o);
					rotate(r2, [0,0,1]) translate([ block_side/2, 0, r2/180*block_height*.6 ])
						rotate(90, [1,0,0]) cylinder(r=chute_rad, h=o);
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

shim();