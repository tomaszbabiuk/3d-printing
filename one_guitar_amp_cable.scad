
//tc electronic box: 74x130x38, rozstaw śrub 100

box_width=38;
box_depth=130;
box_height=38;
box_radius=5;
box_wall=3;



module din8_socket(depth=10) {
    translate([-11,7.5,0]) {
        cylinder(h=depth, d=3);
    }
    
    translate([0,7.5,0]) {
        cylinder(h=depth, d=16);
    }
    
    translate([11,7.5,0]) {
        cylinder(h=depth, d=3);
    }
}

module power_socket() {
    cylinder(h=box_wall, d=8.5);
}

module jack_socket() {
    cylinder(h=box_wall*2, d=9.5);
}

module rounded_square(width, height, radius) {
    hull() {
        translate([radius, radius, 0]) {
            circle(r=radius);
        }
        translate([width-radius, radius, 0]) {
            circle(r=radius);
        }
        translate([radius, height-radius, 0]) {
            circle(r=radius);
        }
        translate([width-radius, height-radius, 0]) {
            circle(r=radius);
        }
    }
}

module bottom_side(width, height, radius, wall, with_holes=false) {
    rotate([90,0,90]) {
        difference() {
            linear_extrude(wall) {
                hull() {
                    translate([radius, height - radius]) {
                        circle(radius);
                    }
                    translate([width-radius, height-radius]) {
                        circle(radius);
                    }
                    translate([width-radius, 0]) {
                        square(radius, radius);
                    }
                    square(radius, radius);
                }
            }
            
            if (with_holes) {
                translate([6,box_height-6,0]) {
                    cylinder(h=box_wall, d=3);
                }
                translate([box_depth-6,box_height-6,0]) {
                    cylinder(h=box_wall, d=3);
                }
            }
        }
    }
}



module bottom_part() {    
    bottom_side(box_depth,box_height,box_radius,box_wall, with_holes=true);

    translate([box_width-box_wall,0,0]) {    
        bottom_side(box_depth,box_height,box_radius,box_wall, with_holes=true);
    }

    linear_extrude(box_wall) {
        difference() {
            square([box_width, box_depth]);
            translate([box_width/2, box_depth/2-50,0]) {
                circle(d=4);
            }
            translate([box_width/2, box_depth/2+50,0]) {
                circle(d=4);
            }
        }
    }
}
        
module top_mount() {
    difference() {
        cylinder(h=box_width-box_wall*2, d=7);
        cylinder(h=box_width-box_wall*2, d=3);
    }
}

module top_part(inverted = false) {
    translate([box_wall, 6, box_height-6]) {
        rotate([0,90,0]) {
            difference() {
                top_mount();
            }
        }
    }
    
    translate([box_wall, box_depth-6, box_height-6]) {
        rotate([0,90,0]) {
            difference() {
                top_mount();
            }
        }
    }
    
    difference() {
        translate([box_wall,0,box_wall]) {
            bottom_side(box_depth, box_height-box_wall, box_radius, box_width-box_wall*2);
        }
        
        translate([box_wall,box_wall,box_wall]) {
            bottom_side(box_depth-box_wall*2, box_height-box_wall*2, box_radius, box_width-box_wall*2);
        }
        translate([box_width/2,box_wall,box_height/4]) {
            rotate([90,0,0]) {
                din8_socket(box_wall);
            }
        }
        rotate([90,0,0]) {
            translate([box_width/2, box_height/3, -box_depth]) {
                power_socket();
            }
        }
        
        //jack 1
        translate([inverted ? 24 : box_width-24,40, box_height-box_wall*2]) {
            jack_socket();
        }
        
        translate([inverted ? 5 : box_width-5,40,box_height-1]) {
            rotate([0,0,inverted ? 0 : 180]) {
                linear_extrude(1) {
                    text(inverted ? "Ret" : "Amp", size=3);
                }
            }
        }
        
        //jack 2
        translate([inverted ? 24 : box_width-24,62, box_height-box_wall*2]) {
            jack_socket();
        }
        
        translate([inverted ? 5 : box_width-5,62,box_height-1]) {
            rotate([0,0,inverted ? 0 : 180]) {
                linear_extrude(1) {
                    text(inverted ? "Send" : "FS", size=3);
                }
            }
        }
        
        //jack 3
        translate([inverted ? 24 : box_width-24,84, box_height-box_wall*2]) {
            jack_socket();
        }
        
        translate([inverted ? 5 : box_width-5,84,box_height-1]) {
            rotate([0,0,inverted ? 0 : 180]) {
                linear_extrude(1) {
                    text(inverted ? "FS" : "Send", size=3);
                }
            }
        }
        
        //jack 4
        translate([inverted ? 24 : box_width-24,106, box_height-box_wall*2]) {
            jack_socket();
        }
        
        translate([inverted ? 5 : box_width-5,106,box_height-1]) {
            rotate([0,0,inverted ? 0 : 180]) {
                linear_extrude(1) {
                    text(inverted ? "Amp" : "Ret", size=3);
                }
            }
        }
    }
}


//bottom_part();

//translate([50,0,0]) {
//    top_part(inverted = true);
//}

//translate([100,0,0]) {
    top_part(inverted = false);
//}