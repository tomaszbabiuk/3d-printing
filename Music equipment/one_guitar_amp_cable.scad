
//tc electronic box: 74x130x38, rozstaw śrub 100

box_wall=3;
box_width=126-box_wall*2;
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
    cylinder(h=box_wall*2, d=6.5);
}

module led_socket() {
    cylinder(h=box_wall*2, d=8);
}

module trs_socket() {
    cylinder(h=box_wall*2, d=8);
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

//lipo_cap();

//top_part_power();

//bottom_power();

module screw_socket() {
    difference() {
        cylinder(h=box_wall*2, d=6);
        cylinder(h=box_wall*2, d=3);
    }
}

module pca10040_mount() {
    
    %cube([64,101,1]);
   
    
    translate([6+2,14+2,0]) {
        screw_socket();
    }
    
    translate([55+2,14+2,0]) {
        screw_socket();
    }
    
    translate([11+2,64+2,0]) {
        screw_socket();
    }
    
    translate([40+2,64+2,0]) {
        screw_socket();
    }
    
    translate([55+2,95+2,0]) {
        screw_socket();
    }
}

module battery_holder() {
    cube([20,75,16]);
}

module bottom_midi() {
    bottom_part();
    translate([7+20+1+20+1,8,box_wall]) {
        pca10040_mount();
    }

    %translate([7,30,box_wall]) {
        battery_holder();
    }

    %translate([7+20+1,30,box_wall]) {
        battery_holder();
    }
}


//bottom_midi();

module top_midi() {
    difference() {
        top_part();
        
        rotate([90,0,0]) {
            translate([box_width/2-22.5, box_height/2, -box_depth]) {
                power_socket();
            }
        }
        
        rotate([90,0,0]) {
            translate([box_width/2+22.5, box_height/2, -box_depth]) {
                trs_socket();
            }
        }

        translate([box_width/2,box_depth-20, box_height-box_wall*2]) {
            switch_socket();
        }
        
        translate([box_width/2-45,box_depth-20, box_height-box_wall*2]) {
            switch_socket();
        }
        
        translate([box_width/2+45,box_depth-20, box_height-box_wall*2]) {
            switch_socket();
        }
        
        
        translate([box_width/2, 20, box_height-box_wall*2]) {
            switch_socket();
        }
        
        translate([box_width/2-45, 20, box_height-box_wall*2]) {
            switch_socket();
        }
        
        translate([box_width/2+45, 20, box_height-box_wall*2]) {
            switch_socket();
        }

        /*
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
        */
    }
}


bottom_midi();

%top_midi();
