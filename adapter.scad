$fn=200;

/* ############################# */
green_outer_radius=30;
green_inner_radius=27.20;
green_height=2;

blue_plate_height=1;

red_height=4;
red_outer_radius=20;
red_inner_radius=16.5;

holder_width=4;
holder_height=2;
number_of_holders=3;
holder_angular_length=50;

screw_head_radius=3/2 + 1/4;
screw_radius=1.7/2;
screw_distance=red_outer_radius;

screw_distance_from_center = red_outer_radius + 5.5;
screw_centerdistance1 = 0.5 + screw_distance_from_center;
screw_centerdistance2 = screw_distance_from_center;
screw_centerdistance3 = 0.5 + screw_distance_from_center;

screw_1_angle = 34;
screw_2_angle = -66;
screw_3_angle = 148;

screw_hole_height = blue_plate_height+blue_plate_height/6 + 2;

screw_start_h = green_height/2+blue_plate_height/2 + 0.5;
/* ############################# */

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

module EFmount() {
	$fa = 1;
	translate([0, 0, -13.5])
	union() {
		difference() {
			union(){
				translate([0, 0, 18])
					cylinder(h = 4, r = 50.5/2);
				translate([0, 0, 15.5])
					cylinder(h = 2.5, r = 54/2);
				translate([0, 0, 18])
					threads();
			}
			cylinder(h = 100, r = 16.6);
		}
	}
}

module threads() {
	difference() {
		cylinder(h = 4, r = 53.2/2);  //thread outer
		cylinder(h = 4, r = 50.4/2);  //thread cylinder
		cylinder(h = 2.6, r = 54/2);  //gap lip to thread
		for(i = [ [0, 0, 0], [180, 0, -70], [0, 0, -120], [180, 0, -180], [0, 0, -230], [180, 0, -300] ])
		{
			rotate(i)	
				translate([-35, 0, -5])
					cube(size=[40, 18, 10]);
		}
	}
	intersection() {
		difference() {
			cylinder(h = 4, r = 54/2);
			cylinder(h = 4, r = 50.4/2);
		}
		translate([-54/2+.4, 0, 0])
			cube(size=[4, 1.9, 4], center = false);  //thread stopper
	}	
}

difference(){
	union(){
		// Red cylinder
		color("red")
		translate([0, 0, -0])
		rotate([0, 0, -25])
		difference() {
			EFmount();

			translate([0, 0, 1.4]){
				cylinder(h = 11, r = 41.5/2);
			}
		}
	
		// Blue plate
		color("blue")
		translate([0,0,green_height/2+blue_plate_height/2]) 
		hollow_cylinder(outer_r=green_outer_radius,
						inner_r=red_inner_radius - 0.2,
						hc_height=blue_plate_height,
						center=true);
		
		//inner cylinder
		color("yellow")
		translate([0,0,green_height+blue_plate_height + 1.1]) 
		hollow_cylinder(outer_r=red_inner_radius + 4.5,
						inner_r=red_inner_radius - 0.25,
						hc_height=6,
						center=true);
		
		//inner cylinder
		color("pink")
		translate([0,0,green_height]) 
		hollow_cylinder(outer_r=red_inner_radius + 1,
						inner_r=red_inner_radius - 0.25,
						hc_height=6,
						center=true);
		
		// Green cylinder
		color("green")
		hollow_cylinder(outer_r=green_outer_radius,
						inner_r=green_inner_radius,
						hc_height=green_height,
						center=true);
	}
	
	// Screw 1
	rotate([0,0,screw_1_angle])
	translate([0,screw_centerdistance1,screw_start_h])
	screw_hole(screw_head_radius=screw_head_radius, screw_radius=screw_radius, h_height=screw_hole_height);
	
	// Screw 2
	rotate([0,0,screw_2_angle])
	translate([0,screw_centerdistance2,screw_start_h])
	screw_hole(screw_head_radius=screw_head_radius, screw_radius=screw_radius, h_height=screw_hole_height);
	
	// Screw 3
	rotate([0,0,screw_3_angle])
	translate([0,screw_centerdistance3,screw_start_h])
	screw_hole(screw_head_radius=screw_head_radius, screw_radius=screw_radius, h_height=screw_hole_height);
}