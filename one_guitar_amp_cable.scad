
//tc electronic box: 74x130x38, rozstaw śrub 100

box_wall=3;
box_width=85-box_wall*2;
box_depth=130;
box_height=38;
box_radius=5;

module power_socket() {
    cylinder(h=box_wall, d=8.5);
}

module jack_socket() {
    cylinder(h=box_wall*2, d=9.5);
}

module switch_socket() {
    cylinder(h=box_wall*2, d=6);
}

module led_socket() {
    cylinder(h=box_wall*2, d=8);
}

module pcb_mount(pcb_width, pcb_depth, pcb_height, wall=2) {
    difference() {
        cube([wall*4,wall+pcb_height,pcb_depth]);
        translate([wall,0,0]) {
            cube([wall*3,pcb_height,pcb_depth]);
        }
    }

    translate([pcb_width-wall*2,0,0]) {
        difference() {
            cube([wall*4,wall+pcb_height,pcb_depth]);
            cube([wall*3,pcb_height,pcb_depth]);
            }
        }
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
                    cylinder(h=box_wall, d=3.1);
                }
                translate([box_depth-6,box_height-6,0]) {
                    cylinder(h=box_wall, d=3.1);
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

    //pillars
    translate([box_wall,box_depth/3,box_wall]) {
        cube([box_wall,box_wall,box_height-box_wall*2]);
    }

    translate([box_wall,box_depth/3*2,box_wall]) {
        cube([box_wall,box_wall,box_height-box_wall*2]);
    }

    translate([box_width-box_wall*2,box_depth/3,box_wall]) {
        cube([box_wall,box_wall,box_height-box_wall*2]);
    }

    translate([box_width-box_wall*2,box_depth/3*2,box_wall]) {
        cube([box_wall,box_wall,box_height-box_wall*2]);
    }
}

module top_mount() {
    difference() {
        cylinder(h=box_width-box_wall*2, d=7);
        cylinder(h=box_width-box_wall*2, d=3.1);
    }
}

module lipo_hole() {
    cube([23.5+4,28.5+4,box_wall*2], center=true);
}

module lipo_cap() {
    difference() {
        cube([23.5+4,28.5+4,4], center=true);
        cube([23.5,28.5,4], center=true);
    }

    translate([0,0,2]) {
        cube([23.5+6,28.5+6,1], center=true);
    }
}

module top_part() {
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

        /* bottom sockets
        translate([box_width/2,box_wall,box_height/3]) {
            rotate([90,0,0]) {
                power_socket();
            }
        }
        */

        //top sockets
    }
}

module top_part_fs_rf_relay() {
    difference() {
        top_part();

        rotate([90,0,0]) {
            translate([box_width-15, box_height/2, -box_depth]) {
                power_socket();
            }

            translate([15, box_height/2, -box_depth]) {
                jack_socket();
            }
        }

        translate([box_width/2,box_depth-40, box_height-box_wall*2]) {
            switch_socket();
        }

        translate([box_width/2,box_depth-52, box_height-box_wall*2]) {
            led_socket();
        }

        translate([25,box_depth-32,box_height-1]) {
            linear_extrude(1) {
                text("On/Off", size=4);
            }
        }

        translate([12,box_depth-10,box_height-1]) {
            linear_extrude(1) {
                text("FS", size=3);
            }
        }

        translate([box_width-23,box_depth-10,box_height-1]) {
            linear_extrude(1) {
                text("DC (9V)", size=3);
            }
        }
    }
}


module top_part_fxloop_rf_relay() {
    difference() {
        top_part();

        //top sockets
        rotate([90,0,0]) {
            translate([box_width-15, box_height/2, -box_depth]) {
                jack_socket();
            }

            translate([box_width/2, box_height/2, -box_depth]) {
                power_socket();
            }

            translate([15, box_height/2, -box_depth]) {
                jack_socket();
            }
        }

        translate([27,box_depth-10,box_height-1]) {
            linear_extrude(1) {
                text("DC (9V)", size=3);
            }
        }

        translate([11,box_depth-10,box_height-1]) {
            linear_extrude(1) {
                text("S-IN", size=3);
            }
        }

        translate([box_width-18,box_depth-10,box_height-1]) {
            linear_extrude(1) {
                text("R-IN", size=3);
            }
        }

        //plate sockets
        translate([box_width/2,box_depth-40, box_height-box_wall*2]) {
            switch_socket();
        }

        translate([box_width/2,box_depth-52, box_height-box_wall*2]) {
            led_socket();
        }

        translate([25,box_depth-32,box_height-1]) {
            linear_extrude(1) {
                text("On/Off", size=4);
            }
        }

        //bottom sockets
        rotate([90,0,0]) {
            translate([box_width-15, box_height/2, 0]) {
                jack_socket();
            }

            translate([15, box_height/2, 0]) {
                jack_socket();
            }
        }

        translate([8,10,box_height-1]) {
            linear_extrude(1) {
                text("S-OUT", size=3);
            }
        }

        translate([box_width-21,10,box_height-1]) {
            linear_extrude(1) {
                text("R-OUT", size=3);
            }
        }
    }
}

module top_part_power() {
    /*
    translate([box_width-box_wall,10,box_height- box_wall]) {
        rotate([270,0,90]) {
            pcb_mount(17.5,box_width-box_wall*2,3);
        }
    }*/

    difference() {
        top_part();

        rotate([90,0,0]) {
            translate([box_width/2, box_height/2, -box_depth]) {
                power_socket();
            }
        }

        translate([box_width/2,box_depth-30, box_height-box_wall*2]) {
            switch_socket();
        }

        translate([14,box_depth-10,box_height-1]) {
            linear_extrude(1) {
                text("DC OUT (9V, - inside)", size=4);
            }
        }

        rotate([90,0,0]) {
            translate([box_width/2, box_height/2, -box_wall]) {
                power_socket();
            }
        }

        translate([11,10,box_height-1]) {
            linear_extrude(1) {
                text("CHARGE (5V, + inside)", size=4);
            }
        }

        translate([box_width/2,box_depth-60,box_height-box_wall]) {
            lipo_hole();
        }
    }
}


//top_part_fs_rf_relay();

//top_part_fxloop_rf_relay();

//top_part_power();

module bottom_power() {
    bottom_part();

    translate([box_wall,17.5+4+10,0]) {
        rotate([0,0,270]) {
            pcb_mount(17.5,25,4);
        }
    }

    translate([box_width-box_wall,10,0]) {
        rotate([0,0,90]) {
            pcb_mount(17.5,25,4);
        }
    }
    
    translate([box_width-box_wall,box_depth-17.5-box_wall*2-10,0]) {
        rotate([0,0,90]) {
            pcb_mount(17.5,25,4);
        }
    }
}

//lipo_cap();

//top_part_power();

bottom_power();