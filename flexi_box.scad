//should be multiples of nozzle diameter
wallsize = 1.8; 

//overall x.y.z dimensions of the box
boxy = [100, 70, 80];
//diameter of the column the box attaches to
cyl_size = 241;

//initial positions
mainxpos = wallsize;
//initial start point away from the cylinder cutout
mainypos = 4;
//bottom thickness
mainzpos = 2; //[1:20]
//small pen holder dimensions
cutout = [((boxy.x-wallsize)/3)-wallsize, 37, boxy.z];

drainage_hole = [2, 2, mainzpos+6];

longx = boxy.x - (wallsize*2);
longy = boxy.y - (cutout.y + (wallsize*2) + (mainypos));

module lbox(lx, ly, lz) {
    translate([lx, ly, lz])
    //main slot    
        cube([cutout.x, cutout.y, cutout.z+2], center=false);
    //drainage 'oles    
    translate([lx+(cutout.x/2)-(drainage_hole.x/2), ly, -1])
        cube(drainage_hole, center=false);
};

difference() {
//main box (-40 so that cylinder chops it out
    translate([0,-40,0])
        cube([boxy.x, boxy.y+40, boxy.z], center=false);
//cylinder part (subtracted)
    translate([boxy.x/2, -cyl_size/2, -1])
        cylinder(boxy.z+wallsize+5, d=cyl_size, $fn=1000);
//small slot for pens x3    
    for (i=[0:2]) {
        lbox((wallsize*(i+1))+(cutout.x * i), mainypos, mainzpos);
    };

//big slot
    translate([wallsize,boxy.y-(wallsize+longy),mainzpos])
        cube([longx, longy, boxy.z], center=false);    

//drainage in either side of big slot
    translate([wallsize,boxy.y-(wallsize+longy),(-1)])
        cube(drainage_hole, center=false);    
    translate([wallsize+longx-(drainage_hole.x),boxy.y-(wallsize+longy),(-1)])
        cube(drainage_hole, center=false);  

};
