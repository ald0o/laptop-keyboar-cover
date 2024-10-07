$fn = 50;

// total size
width = 278;
height = 118;

// regular rows
xPitch = 19;
yPitch = 19;
keyW = 16;
keyH = 16;
standardXMargin = (xPitch - keyW)/2;
standardYMargin = (yPitch - keyH)/2;

// F-keys and D-pad
smallKeyH = 10;
smallYPitch = 12;
smallYMargin = (smallYPitch - smallKeyH)/2;

module key(keyW = keyW, keyH = keyH, xMargin = standardXMargin, yMargin = standardYMargin) {
    translate([xMargin, yMargin]) square([keyW, keyH]);
}

module rowFragment(n=1, xPitch = xPitch, yPitch = yPitch, xMargin = standardXMargin, yMargin = standardYMargin) {
    keyW = xPitch - 2 * xMargin;
    keyH = yPitch - 2 * yMargin;

    for (i = [0:n-1]) {
        translate([i * xPitch, 0]) key(keyW = keyW, keyH = keyH,xMargin = xMargin, yMargin = yMargin);
    }
    translate([n * xPitch, 0]) children();
}

module rows(yPitch = yPitch) {
    for ( i= [0:1:$children-1]) {
        translate([0, ($children-i-1) * yPitch]) children(i);
    }
}

module layout() {
    translate([0, yPitch * 5]) rowFragment(yPitch = smallYPitch, yMargin = smallYMargin) rowFragment(n=13, xPitch = 18.27, yPitch = smallYPitch, yMargin = smallYMargin) rowFragment(yPitch = smallYPitch, yMargin = smallYMargin);  // Esc, F-keys, ... / R6
    rows() {
        rowFragment(n=13) rowFragment(xPitch = 1.5 * xPitch); // number row / R5
        rowFragment(xPitch = 1.5 * xPitch) rowFragment(n=13); // alpha 1 / R4
        rowFragment(xPitch = 1.7 * xPitch) rowFragment(n=12) key(keyW = 0.8 * xPitch - 2 * standardXMargin, keyH = keyH + yPitch); // alpha 2 / R3 (with ISO enter)
        rowFragment(xPitch = 1.2 * xPitch) rowFragment(n=11) rowFragment(xPitch = 2.3 * xPitch); // alpha 3 / R2
        rowFragment(xPitch = 1.2 * xPitch) rowFragment(n=3) rowFragment(xPitch = 5 * xPitch) rowFragment(n=2); // mods and space / R1
    }
    // arrow pad
    translate([xPitch * 11.2 + standardXMargin, yPitch - standardYMargin - smallKeyH -smallYPitch]) {
        translate([0, smallYPitch]) square([16,smallKeyH]); translate([20,smallYPitch]) square([19,smallKeyH]); translate([44,smallYPitch]) square([16,smallKeyH]);
        square([17.5,smallKeyH]); translate([20,0]) square([19,smallKeyH]); translate([42.5, 0]) square([17.5,smallKeyH]);
    }
    // mouse buttons
    translate([78, -25 - 4+standardYMargin]) square([99, 25]);
    // trackstick
    translate([xPitch * 6.7, yPitch * 2 + (yPitch-keyH)/2]) circle(r=4.5);
 }

module cover() {
    difference() {
        cube([width, height, 1.9]);
        linear_extrude(height = 1.6) translate([1, 10]) layout();
    }
}

intersection() {
    cover();
//    cube([width/2,height,50]); // uncomment to print left half
    translate([width/2,0,0]) cube([width/2,height,50]); // uncomment to print right half
}