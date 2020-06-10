beam_size=15;
beam_row_size=2;
beam_row_start=(beam_size-beam_row_size)/2;
beam_row_end=beam_row_start + beam_row_size;

module makerbeam() {
polygon(points=[[0,0],[0,beam_row_start],[beam_row_size,beam_row_start],[beam_row_size,beam_row_end],[0,beam_row_end],[0,beam_size],[beam_size,beam_size],[beam_size,beam_row_end],[beam_size- beam_row_size,beam_row_end],[beam_size- beam_row_size,beam_row_start],[beam_size,beam_row_start],[beam_size,0]]);
}


module cutter(size) {
    translate([-size,-size]) {
        difference() { 
            square([size*2,size*2]);
            translate([size*2,0]) {
                circle(r=size);
            }
        }
    }
}

module makerbeam_inlet(with_hole = false) {
    linear_extrude(10) {
        makerbeam();
    }
    if (with_hole) {
        rotate([90,0,0]) {
            translate([beam_size/2,10/2,0]) {
                cylinder(d=3.2, h=3);
            }
            translate([beam_size/2,10/2,3]) {
                cylinder(d=5.2, h=100);
            }
        }
    }
}

module side() {
    difference() {
        linear_extrude(15) {
            difference([0,15]) {
                    polygon(points=[
                        [0,0],
                        [0,20],
                        [190,20+190*sin(15)],
                        [190,0]
                    ]);
                translate([0,21.5]) {
                    cutter(5);
                }
            }
        }
        
        //beam 1
        translate([10,5+10*sin(15),0]) {
            rotate([0,0,15]) {
                makerbeam_inlet(with_hole=true);
            }
        }
        
        //beam 2
        translate([100,5+100*sin(15),0]) {
            rotate([0,0,15]) {
                makerbeam_inlet(with_hole=true);
            }
        }

        //beam 3
        translate([160,5+160*sin(15),0]) {
            rotate([0,0,15]) {
                makerbeam_inlet();
            }
        }
        
        //back hole 1
        translate([175,10,15/2]) {
            rotate([0,90,0]) {
                cylinder(d=4,h=15);
            }
        }
        
        //back hole 2
        translate([175,50,15/2]) {
            rotate([0,90,0]) {
                cylinder(d=4,h=15);
            }
        }

        //back hole 3
        translate([175,30,15/2]) {
            rotate([0,90,0]) {
                cylinder(d=4,h=15);
            }
        }
    }
}

module screw() {
    translate([0,0,2]) {
        cylinder(d=17, h=4, center=true);
    }
    translate([0,0,6]) {
        cube([7,7,7], center=true);
    }

    translate([0,0,13]) {
        cylinder(d=6, h=9, center=true);
    }
}
        
       
module back() {
    difference() {
        linear_extrude(15) {
            polygon(points=[
                [0,0],
                [0,20+190*sin(15)],
                [60,20+250*sin(15)],
                [60,0]
            ]);
            
        }
        

        
        translate([30,5+220*sin(15),0]) {
            rotate([0,0,15]) {
                makerbeam_inlet(with_hole=true);
            }
        }

        
        //back hole 1
        translate([0,10,15/2]) {
            rotate([0,90,0]) {
                cylinder(d=4,h=15);
                translate([0,0,15]) {
                    cylinder(d=7,h=45);
                }
            }
        }
        
        //back hole 2
        translate([0,30,15/2]) {
            rotate([0,90,0]) {
                cylinder(d=4,h=15);
                translate([0,0,15]) {
                    cylinder(d=7,h=45);
                }
            }
        }
        
        
        //back hole 3
        translate([0,50,15/2]) {
            rotate([0,90,0]) {
                cylinder(d=4,h=15);
                translate([0,0,15]) {
                    cylinder(d=7,h=45);
                }
            }
        }
        
    }
}



//side();
back();