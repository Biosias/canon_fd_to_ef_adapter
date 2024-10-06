$fn=200;

module hollow_cylinder(outer_r=10, inner_r=8, hc_height=20, center=false){
	difference(){
		cylinder(r=outer_r, h=hc_height, center=center);
		cylinder(r=inner_r, h=hc_height+1, center=center);
	}
}

module angular_portion(outer_r=20, inner_r=18, h_height=1, portion_angle=30, center=false){
	difference(){
		hollow_cylinder(outer_r=outer_r,
						inner_r=inner_r,
						hc_height=h_height,
						center=center);
		rotate([0,0,portion_angle/2]) union(){
			rotate([0,0,180-portion_angle])
			difference(){
				cube([outer_r*2, outer_r*2,h_height+1], center=center);
				translate([-outer_r,0,0]) cube([outer_r*2, outer_r*2+1,h_height+2], center=center);
			}
			rotate([0,0,0])
			difference(){
				cube([outer_r*2, outer_r*2,h_height+1], center=center);
				translate([-outer_r,0,0]) cube([outer_r*2, outer_r*2+1,h_height+2], center=center);
			}
		}
	}
}

module holder(outer_r, inner_r, h_height, portion_angle=50, number_of_holders=3, center=true){
	angle_of_holders=360/number_of_holders;
	for(r=[0:angle_of_holders:360]){
		rotate([0,0,r])
		angular_portion(outer_r=outer_r, 
						inner_r=inner_r,
						h_height=h_height,
						portion_angle=portion_angle,
						center=center);
	}
}

module screw_hole(screw_head_radius=10, screw_radius=5, h_height=18){
	translate([0,0,-(h_height)]){
		translate([0,0,h_height+h_height/2])
		cylinder(r=screw_head_radius, h=h_height, center=true);

		cylinder(r=screw_radius, h=h_height*2+1, center=true);
	}
}

green_outer_radius=28.5;
green_inner_radius=24.5;
green_height=10;

blue_plate_height=1;

red_height=5;
red_outer_radius=20;
red_inner_radius=12;

holder_width=4;
holder_height=2;
number_of_holders=3;
holder_angular_length=50;

screw_head_radius=3/2;
screw_radius=1.7/2;
screw_distance=red_outer_radius;

difference(){
	union(){
		// Red cylinder
		color("red")
		translate([0,0,green_height/2+red_height/2+blue_plate_height]){
			hollow_cylinder(outer_r=red_outer_radius, 
							inner_r=red_inner_radius, 
							hc_height=red_height, 
							center=true);
							
			// Holders
			translate([0,0,red_height/2-holder_height/2])
			rotate([0,0,180])
			holder(outer_r=red_outer_radius+holder_width,
				   inner_r=red_outer_radius,
				   h_height=holder_height,
				   portion_angle=holder_angular_length,
				   number_of_holders=number_of_holders,
				   center=true);
		}
	
		// Blue plate
		color("blue")
		translate([0,0,green_height/2+blue_plate_height/2]) 
		hollow_cylinder(outer_r=green_outer_radius,
						inner_r=red_inner_radius,
						hc_height=blue_plate_height,
						center=true);
		// Green cylinder
		color("green")
		hollow_cylinder(outer_r=green_outer_radius,
						inner_r=green_inner_radius,
						hc_height=green_height,
						center=true);
  	}
	
	// Screw 1
	rotate([0,0,34])
	translate([0,red_outer_radius,green_height/2+blue_plate_height/2])
	screw_hole(screw_head_radius=screw_head_radius, screw_radius=screw_radius, h_height=blue_plate_height+blue_plate_height/6+red_height);
	
	// Screw 2
	rotate([0,0,-65])
	translate([0,red_outer_radius,green_height/2+blue_plate_height/2])
	screw_hole(screw_head_radius=screw_head_radius, screw_radius=screw_radius, h_height=blue_plate_height+blue_plate_height/6+red_height);
	
	// Screw 3
	rotate([0,0,-175])
	translate([0,red_outer_radius,green_height/2+blue_plate_height/2])
	screw_hole(screw_head_radius=screw_head_radius, screw_radius=screw_radius, h_height=blue_plate_height+blue_plate_height/6+red_height);
}