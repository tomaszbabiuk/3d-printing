FULL_BLOCK_WIDTH = 360;
MEDIUM_BLOCK_WIDTH = 180;
SMALL_BLOCK_WIDTH = 120;
BLOCK_HEIGHT = 240;
HORIZONTAL_JOINT_SIZE = 20;
HORIZONTAL_JOINT_PADDING = 22;
VERTICAL_JOINT_STEP = 18;
FITTING = 2;

module vertical_joint_outer(block_height, vertical_joint_step, fitting) {
    linear_extrude(block_height) {
        polygon(points = [[0,vertical_joint_step + fitting],[vertical_joint_step*2 - fitting,fitting],[vertical_joint_step*2 - fitting,vertical_joint_step*4 - fitting],[0,vertical_joint_step*3 - fitting]]);
    }
}

module vertical_joint_inner(block_height, vertical_joint_step) {
    linear_extrude(block_height) {
        polygon(points = [[0,vertical_joint_step],[vertical_joint_step*2,0],[vertical_joint_step*2,vertical_joint_step*4],[0,vertical_joint_step*3]]);
    }
}

module horizontal_joint_inner(block_width, horizontal_joint_size) {
    cube([block_width,horizontal_joint_size,horizontal_joint_size],false);
}

module horizontal_joint_outer(block_width, horizontal_joint_size, fitting) {
    cube([block_width,horizontal_joint_size - fitting,horizontal_joint_size - fitting],false);
}


module brick(block_width, block_height, block_depth, horizontal_joint_size, horizontal_joint_padding, vertical_joint_step, fitting, start_joint, end_joint, side_joint) {

    difference() {
        cube([block_width,block_depth,block_height],false);
            translate([0,horizontal_joint_padding,block_height - horizontal_joint_size]) {
                horizontal_joint_inner(block_width, horizontal_joint_size);
            }
           
            translate([0,block_depth - horizontal_joint_padding- horizontal_joint_size,block_height-horizontal_joint_size]) {
                horizontal_joint_inner(block_width, horizontal_joint_size);
            }
            
            
            if (start_joint) {
                translate([0,(block_depth - vertical_joint_step*4)/2,0]) {
                    vertical_joint_inner(block_height, vertical_joint_step);
                }
            }
    }

    translate([0,horizontal_joint_padding, fitting - horizontal_joint_size]) {
        horizontal_joint_outer(block_width,horizontal_joint_size, fitting);
    }

    translate([0,block_depth - horizontal_joint_padding- horizontal_joint_size,fitting -horizontal_joint_size]) {
        horizontal_joint_outer(block_width,horizontal_joint_size, fitting);
    }

    if (end_joint) {
        translate([block_width,(block_depth - vertical_joint_step*4)/2,0]) {
            vertical_joint_outer(block_height, vertical_joint_step, fitting);
        }
    }
    
    if (side_joint) {
        translate([block_width-(block_depth/2)-vertical_joint_step*2,0,0]) {
            rotate([0,0,-90]) {
                vertical_joint_outer(block_height, vertical_joint_step, fitting);
            }
        }
    }
}

//supporting bricks
module fullSupportingBrick(start_joint, end_joint, side_joint) { 
    brick(FULL_BLOCK_WIDTH, BLOCK_HEIGHT, MEDIUM_BLOCK_WIDTH, HORIZONTAL_JOINT_SIZE,HORIZONTAL_JOINT_PADDING, VERTICAL_JOINT_STEP, FITTING, start_joint, end_joint, side_joint);
}

module mediumSupportingBrick(start_joint, end_joint, side_joint) { 
    brick(MEDIUM_BLOCK_WIDTH, BLOCK_HEIGHT, MEDIUM_BLOCK_WIDTH, HORIZONTAL_JOINT_SIZE,HORIZONTAL_JOINT_PADDING, VERTICAL_JOINT_STEP, FITTING, start_joint, end_joint, side_joint);
}

module smallSupportingBrick(start_joint, end_joint, side_joint) { 
    brick(SMALL_BLOCK_WIDTH, BLOCK_HEIGHT, MEDIUM_BLOCK_WIDTH, HORIZONTAL_JOINT_SIZE,HORIZONTAL_JOINT_PADDING, VERTICAL_JOINT_STEP, FITTING, start_joint, end_joint, side_joint);
}

//partition bricks
module fullPartitionBrick(start_joint, end_joint, side_joint) { 
    brick(FULL_BLOCK_WIDTH, BLOCK_HEIGHT, SMALL_BLOCK_WIDTH, HORIZONTAL_JOINT_SIZE,HORIZONTAL_JOINT_PADDING, VERTICAL_JOINT_STEP, FITTING, start_joint, end_joint, side_joint);
}

module mediumPartitionBrick(start_joint, end_joint, side_joint) { 
    brick(MEDIUM_BLOCK_WIDTH, BLOCK_HEIGHT, SMALL_BLOCK_WIDTH, HORIZONTAL_JOINT_SIZE,HORIZONTAL_JOINT_PADDING, VERTICAL_JOINT_STEP, FITTING, start_joint, end_joint, side_joint);
}

module smallPartitionBrick(start_joint, end_joint, side_joint) { 
    brick(SMALL_BLOCK_WIDTH, BLOCK_HEIGHT, SMALL_BLOCK_WIDTH, HORIZONTAL_JOINT_SIZE,HORIZONTAL_JOINT_PADDING, VERTICAL_JOINT_STEP, FITTING, start_joint, end_joint, side_joint);
}


module halfOpenBrick() { 
    brick(HALF_BLOCK_WIDTH/2, BLOCK_HEIGHT, MEDIUM_BLOCK_DEPTH, HORIZONTAL_JOINT_SIZE,HORIZONTAL_JOINT_PADDING, VERTICAL_JOINT_STEP, FITTING, true, false, false);
    
    translate([HALF_BLOCK_WIDTH,HALF_BLOCK_WIDTH ,0]) {
        rotate([0,0,180]) {
                brick(HALF_BLOCK_WIDTH/2, BLOCK_HEIGHT, MEDIUM_BLOCK_DEPTH, HORIZONTAL_JOINT_SIZE,HORIZONTAL_JOINT_PADDING, VERTICAL_JOINT_STEP, FITTING, true, false, false);     
        }
    }
}

module fullTurnBrick() {
    brick(FULL_BLOCK_WIDTH, BLOCK_HEIGHT, MEDIUM_BLOCK_DEPTH, HORIZONTAL_JOINT_SIZE,HORIZONTAL_JOINT_PADDING, VERTICAL_JOINT_STEP, FITTING, true, false, true);
}

module halfTurnBrick() {
    brick(HALF_BLOCK_WIDTH, BLOCK_HEIGHT, MEDIUM_BLOCK_DEPTH, HORIZONTAL_JOINT_SIZE,HORIZONTAL_JOINT_PADDING, VERTICAL_JOINT_STEP, FITTING, true, false, true);
}

module joinBrick() { 
    brick(FULL_BLOCK_WIDTH, BLOCK_HEIGHT, MEDIUM_BLOCK_DEPTH, HORIZONTAL_JOINT_SIZE,HORIZONTAL_JOINT_PADDING, VERTICAL_JOINT_STEP, FITTING, true, true, false);
}


//supporting
//fullSupportingBrick(true, true, false);
//mediumSupportingBrick(true, true, false);
//smallSupportingBrick(true, true, false);

//partition
//fullPartitionBrick(true, true, false);
//mediumPartitionBrick(true, true, false);
//smallPartitionBrick(true, true, false);

//supporting + turn
//fullSupportingBrick(true, false, true);
//mediumSupportingBrick(true, false, true);
//smallSupportingBrick(true, false, true);

//supporting + join
//fullSupportingBrick(true, true, true);
//mediumSupportingBrick(true, true, true);
//smallSupportingBrick(true, true, true);


/*
difference() {
    fullSupportingBrick(true, false, false);

    translate([0,FULL_BLOCK_WIDTH,0]) {
        rotate([90,0,0]) {
            linear_extrude(FULL_BLOCK_WIDTH) {
                polygon(points = [[FULL_BLOCK_WIDTH,0],[FULL_BLOCK_WIDTH,BLOCK_HEIGHT],[0,BLOCK_HEIGHT]]);
            }
        }
    }
}


color("red") {
    translate([0,0,BLOCK_HEIGHT]) {
        rotate([0,atan2(BLOCK_HEIGHT,FULL_BLOCK_WIDTH),0]) {
            cube([1000,10,10],false);
        }
    }
}
*/