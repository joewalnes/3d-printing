/**
 * Shower door clip.
 *
 * This is something I designed to slide on top of my class shower door
 * and the adjacent glass wall pane, to prevent it from being easily
 * opened.
 *
 * It's a safety device to prevent my kids from opening the heavy door
 * and then trapping their fingers in it.
 *
 * Joe Walnes, 2012
 * License: http://creativecommons.org/licenses/by/3.0/
 */

// Makes it easier to 3D print
upside_down = true; 

// Special OpenSCAD variable for arc segments in cylinders/spheres.
// 6 for fast renders, 24 for smooth renders
$fn = 12;

// Smooth outer edges: Looks nicer, but slows down rendering
smooth_outer_edges = true;

// Parametric dimensions
channel_thickness = 10;
channel_depth	= 10;
divider_thickness = 1;
divider_height = 2;
wall_thickness = 5;
outer_length = 100;
fillet_radius = 5;
minkowski_radius = 2;
fudge = 0.1;
additional_hollow = 3;

// Main volume of object.
module main_volume() {
	difference() {
	
		// Main volume
		translate(v=[-outer_length / 2, -channel_thickness / 2 - wall_thickness, 0]) {
			cube(center=false, size=[
			 	outer_length,
				channel_thickness + wall_thickness * 2,
				channel_depth + wall_thickness
			]);
		}
	
		// Subtract 4 fillets (large arcs at ends and in middle)
		translate(v=[-outer_length / 2 + fillet_radius, -channel_thickness / 2 - wall_thickness, fillet_radius]) {
			mirror([1, 0, 1]) fillet();
		}
		translate(v=[outer_length / 2 - fillet_radius, -channel_thickness / 2 - wall_thickness, fillet_radius]) {
			mirror([0, 0, 1]) fillet();
		}
		translate(v=[-fillet_radius, -channel_thickness / 2 - wall_thickness, fillet_radius]) {
			mirror([0, 0, 1]) fillet();
		}
		translate(v=[fillet_radius, -channel_thickness / 2 - wall_thickness, fillet_radius]) {
			mirror([1, 0, 1]) fillet();
		}
	}
}

// A little quarter of a cylinder segment that's used to round out the
// end stops and the middle divide.
module fillet() {
	difference() {
		cube(center=false, size=[
			fillet_radius + fudge,
			channel_thickness + wall_thickness * 2,
			fillet_radius + fudge
		]);
		intersection() {
			cube(center=false, size=[
				fillet_radius, 
				channel_thickness + wall_thickness * 2,
				fillet_radius]);
			rotate(a=[-90, 0, 0]) {
				cylinder(h=channel_thickness + wall_thickness * 2 + fudge, r=fillet_radius);
			}
		}
	}
}

// Space occupied by doors. This will be subtracted from main volume.
module hollow_volume() {
	difference() {
		// Top of doors
		translate(v=[-outer_length / 2 - additional_hollow, -channel_depth / 2, -additional_hollow]) {	
			cube(center=false, size=[
				outer_length + additional_hollow * 2,
				channel_thickness,
				channel_depth + additional_hollow
			]);
		}

		// Slight gap between doors
		translate(v=[-divider_thickness / 2, -channel_thickness / 2, channel_depth - divider_height]) {
			cube(center=false, size=[
				divider_thickness,
				channel_thickness,
				divider_height
			]);
		}
	}
}

module main() {
	difference() {
		// Minkowski sum of main volume and a small sphere gives the smooth bubbly edges.
		// See http://www.cgal.org/Manual/latest/doc_html/cgal_manual/Minkowski_sum_3/Chapter_main.html
		if (smooth_outer_edges) {
			minkowski() {
				main_volume();
				sphere(r=minkowski_radius);
			}
		} else {
			main_volume();
		}

		// Substract the space where the doors go.
		hollow_volume();
	}
}

// Go!
if (upside_down) {
	rotate([180, 0, 0]) main();
} else {
	main();
}
