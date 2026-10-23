/*
    Raspberry Pi Pico 2 W + I2S ADC Enclosure
    ==========================================

    All dimensions in mm.

    Orientation:
      Front = X 0
      Rear  = X case_x

    Enclosure:
      Length = 106 mm
      Width  = 80 mm
      Base   = 47 mm
      Lid    = 3 mm
      Total  = 50 mm

    PCB underside clearance:
      7 mm above inside floor

    Fasteners:
      Pico   = M2 self-cutting
      ADC    = M3 self-cutting
      Switch = M1.6 self-cutting
      Lid    = M2.5 self-cutting

    No threaded inserts.
*/


// =====================================================
// OUTPUT
// =====================================================

part = "lid";       // "base" or "lid"

$fn = 64;
eps = 0.1;


// =====================================================
// ENCLOSURE
// =====================================================

case_x = 106;
case_y = 80;

base_h = 47;
lid_t = 3;

wall = 2.4;
floor_t = 2.4;


// Interior limits

inside_x_min = wall;
inside_x_max = case_x - wall;

inside_y_min = wall;
inside_y_max = case_y - wall;


// =====================================================
// LID MOUNTING
// =====================================================

/*
    M2.5 self-cutting screws.

    Side pillars are moved toward the outer walls
    to maximize PCB clearance.

    Rear pillars are moved forward to stay away from
    the Pico and rear radio opening.
*/


// Front pillar X center

lid_front_boss_x = 5;


// Rear pillar X center

lid_rear_boss_inset_x = 12;

lid_rear_boss_x =
    case_x - lid_rear_boss_inset_x;


// Side pillar Y centers

lid_boss_inset_y = 3.5;

lid_left_boss_y =
    lid_boss_inset_y;

lid_right_boss_y =
    case_y - lid_boss_inset_y;


// Pillar geometry

lid_boss_d = 7;


// M2.5 pilot hole

lid_pilot_hole_d = 2.0;


// Lid clearance hole

lid_clearance_hole_d = 3.0;


// Screw engagement

lid_screw_depth = 8;


// Optional countersink

lid_countersink = true;

lid_countersink_d = 5.5;
lid_countersink_depth = 1.5;


// =====================================================
// PCB HEIGHT
// =====================================================

pcb_clearance = 7;

pcb_underside_z =
    floor_t + pcb_clearance;


// =====================================================
// PCB DIMENSIONS
// =====================================================

/*
    Actual measured / verified ADC dimensions.
*/

adc_len = 55;
adc_wid = 34;


// Raspberry Pi Pico 2 W

pico_len = 51;
pico_wid = 21;


// PCB-to-PCB gap

board_gap = 8;


// =====================================================
// PCB Y POSITIONS
// =====================================================

assembly_wid =
    adc_wid +
    board_gap +
    pico_wid;


// Center complete PCB assembly across enclosure

assembly_side_clearance =
    (
        case_y -
        2 * wall -
        assembly_wid
    ) / 2;


adc_y =
    wall +
    assembly_side_clearance;


pico_y =
    adc_y +
    adc_wid +
    board_gap;


// PCB Y limits

adc_y_min = adc_y;
adc_y_max = adc_y + adc_wid;

pico_y_min = pico_y;
pico_y_max = pico_y + pico_wid;


// PCB center positions

adc_center_y =
    adc_y +
    adc_wid / 2;


pico_center_y =
    pico_y +
    pico_wid / 2;


// =====================================================
// ADC X POSITION
// =====================================================

/*
    ADC sits directly behind the inside front wall.

    Front wall thickness:
      2.4 mm

    PCB-to-wall clearance:
      0.5 mm

    Therefore:
      ADC front edge = X 2.9 mm
*/


adc_front_clearance = 0.5;


adc_x =
    wall +
    adc_front_clearance;


adc_x_max =
    adc_x +
    adc_len;


// =====================================================
// PICO X POSITION
// =====================================================

/*
    Pico sits close to the inside rear wall.

    Rear inside wall:
      X = 103.6 mm

    PCB-to-wall clearance:
      0.5 mm

    Result:
      Pico rear edge  = X 103.1 mm
      Pico front edge = X 52.1 mm
*/


pico_rear_clearance = 0.5;


pico_x =
    inside_x_max -
    pico_rear_clearance -
    pico_len;


pico_x_max =
    pico_x +
    pico_len;


actual_pico_rear_clearance =
    inside_x_max -
    pico_x_max;


// =====================================================
// ADC MOUNTING
// =====================================================

/*
    ADC PCB:
      57.5 x 34.2 mm

    Measured mounting-hole center positions
    relative to PCB origin:

      X:
        3.1 mm
        15.1 mm

      Y:
        3.1 mm from each side

    Therefore:

      X positions:
        3.1
        15.1

      Y positions:
        3.1
        31.1

    Resulting center spacing:

      X = 12.0 mm
      Y = 28.0 mm

    PCB mounting holes:
      Ø4 mm

    Fastener:
      M3 self-cutting

    Printed post:
      Ø6 mm

    Pilot:
      Ø2.4 mm
*/


adc_hole_front_x = 15.1;
adc_hole_rear_x  = adc_len - 3.1;

adc_hole_side_y = 3.1;


adc_post_d = 6.0;

adc_screw_hole_d = 2.4;

adc_screw_depth = 5;


// =====================================================
// PICO MOUNTING
// =====================================================

/*
    Pico mounting-hole spacing:

      X = 47 mm
      Y = 12 mm

    Screw:
      M2 self-cutting

    Pilot:
      Ø1.6 mm

    Stepped post:

      Lower:
        Ø6.0 mm

      Upper:
        Ø3.5 mm x 3 mm high

    Total height:
      7 mm
*/


pico_hole_spacing_x = 47;
pico_hole_spacing_y = 12;


pico_hole_x =
    (pico_len - pico_hole_spacing_x) / 2;


pico_hole_y =
    (pico_wid - pico_hole_spacing_y) / 2;


pico_screw_hole_d = 1.6;

pico_screw_depth = 5;


pico_post_lower_d = 6.0;

pico_post_upper_d = 3.5;

pico_post_upper_h = 3.0;


pico_post_lower_h =
    pcb_clearance -
    pico_post_upper_h;


// =====================================================
// FRONT ADC OPENING
// =====================================================

opening_bottom_z =
    pcb_underside_z;


adc_opening_w = 30;
adc_opening_h = 15;


adc_opening_y =
    adc_center_y;


// =====================================================
// USB CABLE NOTCH
// =====================================================

usb_notch_w = 3.3;
usb_notch_depth = 3.5;


// =====================================================
// FRONT SWITCH
// =====================================================

/*
    Switch opening:
      16 x 8 mm

    Mounting-hole spacing:
      20 mm

    Fastener:
      M1.6 self-cutting

    Pilot:
      Ø1.3 mm
*/


switch_opening_w = 16;
switch_opening_h = 8;

switch_screw_spacing = 20;

switch_screw_hole_d = 1.3;


switch_opening_y =
    pico_center_y;


switch_opening_z =
    opening_bottom_z +
    switch_opening_h +
    10;


// =====================================================
// REAR RADIO OPENING
// =====================================================

/*
    Pico PCB width:
      21 mm

    Extra clearance:
      2 mm each side

    Final opening:
      25 x 12 mm
*/


rear_radio_side_clearance = 2;


rear_radio_opening_w =
    pico_wid +
    2 * rear_radio_side_clearance;


rear_radio_opening_h = 12;


rear_radio_opening_y =
    pico_y -
    rear_radio_side_clearance;


rear_radio_opening_y_max =
    rear_radio_opening_y +
    rear_radio_opening_w;


rear_radio_opening_z =
    floor_t + 3;


rear_radio_opening_z_max =
    rear_radio_opening_z +
    rear_radio_opening_h;


// =====================================================
// DERIVED CLEARANCES
// =====================================================


// PCB-to-interior-wall clearance

adc_side_clearance =
    adc_y_min -
    inside_y_min;


pico_side_clearance =
    inside_y_max -
    pico_y_max;


// ADC front clearance

actual_adc_front_clearance =
    adc_x -
    inside_x_min;


// Lid pillar inner edges

left_pillar_inner_edge_y =
    lid_left_boss_y +
    lid_boss_d / 2;


right_pillar_inner_edge_y =
    lid_right_boss_y -
    lid_boss_d / 2;


// PCB-to-pillar clearance

adc_to_left_pillar_clearance =
    adc_y_min -
    left_pillar_inner_edge_y;


pico_to_right_pillar_clearance =
    right_pillar_inner_edge_y -
    pico_y_max;


// Rear boss position

rear_boss_rear_edge_x =
    lid_rear_boss_x +
    lid_boss_d / 2;


rear_wall_inside_x =
    case_x -
    wall;


// =====================================================
// SANITY CHECKS
// =====================================================


// Output

assert(
    part == "base" || part == "lid",
    "part must be \"base\" or \"lid\""
);


// Basic enclosure

assert(
    wall > 0 &&
    floor_t > 0 &&
    base_h > floor_t,
    "Invalid enclosure geometry"
);


assert(
    lid_t > 0,
    "Lid thickness must be greater than zero"
);


// PCB assembly

assert(
    assembly_wid <
    case_y - 2 * wall,
    "PCB assembly is wider than enclosure interior"
);


assert(
    board_gap > 0,
    "Board gap must be greater than zero"
);


assert(
    adc_y_min >= inside_y_min,
    "ADC extends through left interior wall"
);


assert(
    pico_y_max <= inside_y_max,
    "Pico extends through right interior wall"
);


// ADC front placement

assert(
    adc_x >= inside_x_min,
    "ADC extends into front wall"
);


assert(
    actual_adc_front_clearance >=
    adc_front_clearance -
    eps,
    "ADC front clearance is smaller than requested"
);


assert(
    adc_x_max < inside_x_max,
    "ADC extends through rear interior wall"
);


// Pico rear placement

assert(
    pico_x >= inside_x_min,
    "Pico extends through front interior wall"
);


assert(
    pico_x_max <=
    inside_x_max -
    pico_rear_clearance +
    eps,
    "Pico extends too far toward rear wall"
);


assert(
    actual_pico_rear_clearance >=
    pico_rear_clearance -
    eps,
    "Pico rear clearance is too small"
);


// ADC hole measurements

assert(
    adc_hole_front_x > 0 &&
    adc_hole_front_x < adc_len,
    "Invalid ADC front mounting-hole position"
);

assert(
    adc_hole_rear_x > 0 &&
    adc_hole_rear_x < adc_len,
    "Invalid ADC rear mounting-hole position"
);

assert(
    adc_hole_rear_x > adc_hole_front_x,
    "ADC rear mounting holes must be behind front mounting holes"
);

assert(
    adc_hole_side_y > 0 &&
    adc_hole_side_y < adc_wid / 2,
    "Invalid ADC side mounting-hole position"
);

// ADC posts

assert(
    adc_screw_hole_d < adc_post_d,
    "ADC pilot hole must be smaller than post"
);


assert(
    adc_screw_depth <= pcb_clearance,
    "ADC screw depth exceeds post height"
);


// Pico posts

assert(
    pico_screw_hole_d < pico_post_upper_d,
    "Pico pilot hole must be smaller than upper post"
);


assert(
    pico_post_upper_h > 0 &&
    pico_post_upper_h < pcb_clearance,
    "Invalid Pico upper-post height"
);


assert(
    pico_post_lower_h > 0,
    "Pico lower-post height must be greater than zero"
);


assert(
    pico_screw_depth <= pcb_clearance,
    "Pico screw depth exceeds post height"
);


// PCB to lid-pillar clearance

assert(
    adc_to_left_pillar_clearance > 0,
    "ADC overlaps left lid pillars"
);


assert(
    pico_to_right_pillar_clearance > 0,
    "Pico overlaps right lid pillars"
);


// Rear radio opening

assert(
    rear_radio_opening_y >= 0,
    "Rear radio opening extends beyond case"
);


assert(
    rear_radio_opening_y_max <= case_y,
    "Rear radio opening extends beyond case"
);


assert(
    rear_radio_opening_z > floor_t,
    "Rear radio opening is too low"
);


assert(
    rear_radio_opening_z_max < base_h,
    "Rear radio opening is too high"
);


// Lid pillars

assert(
    lid_front_boss_x -
    lid_boss_d / 2 >= 0,
    "Front lid pillars extend beyond case"
);


assert(
    rear_boss_rear_edge_x <= case_x,
    "Rear lid pillars extend beyond case"
);


assert(
    lid_left_boss_y -
    lid_boss_d / 2 >= 0,
    "Left lid pillars extend beyond case"
);


assert(
    lid_right_boss_y +
    lid_boss_d / 2 <= case_y,
    "Right lid pillars extend beyond case"
);


// Countersink

assert(
    lid_countersink_depth <= lid_t,
    "Countersink is deeper than lid"
);


// =====================================================
// CONSOLE INFORMATION
// =====================================================

echo(
    "ADC size:",
    adc_len,
    "x",
    adc_wid
);


echo(
    "ADC front-wall clearance:",
    actual_adc_front_clearance
);


echo(
    "ADC hole X positions from PCB front:",
    adc_hole_front_x,
    adc_hole_rear_x
);

echo(
    "ADC hole Y positions from PCB side:",
    adc_hole_side_y,
    adc_wid - adc_hole_side_y
);

echo(
    "ADC hole spacing:",
    adc_hole_rear_x - adc_hole_front_x,
    "x",
    adc_wid - 2 * adc_hole_side_y
);


echo(
    "Board gap:",
    board_gap
);


echo(
    "ADC-to-left-pillar clearance:",
    adc_to_left_pillar_clearance
);


echo(
    "Pico-to-right-pillar clearance:",
    pico_to_right_pillar_clearance
);


echo(
    "Pico rear-wall clearance:",
    actual_pico_rear_clearance
);


// =====================================================
// ADC POST POSITIONS
// =====================================================

/*
    ADC mounting pattern is intentionally NOT generated
    using the generic symmetric PCB routine because the
    measured X positions are asymmetric.
*/

module adc_post_positions() {

    for (
        px = [
            adc_x + adc_hole_front_x,
            adc_x + adc_hole_rear_x
        ]
    )

        for (
            py = [
                adc_y + adc_hole_side_y,
                adc_y + adc_wid - adc_hole_side_y
            ]
        )

            translate([
                px,
                py,
                floor_t
            ])

                children();
}

// =====================================================
// PICO POST POSITION GENERATOR
// =====================================================

module pico_post_positions() {

    for (
        px = [
            pico_x + pico_hole_x,
            pico_x + pico_len - pico_hole_x
        ]
    )

        for (
            py = [
                pico_y + pico_hole_y,
                pico_y + pico_wid - pico_hole_y
            ]
        )

            translate([
                px,
                py,
                floor_t
            ])

                children();
}


// =====================================================
// LID SCREW POSITION GENERATOR
// =====================================================

module lid_screw_positions() {

    for (
        x = [
            lid_front_boss_x,
            lid_rear_boss_x
        ]
    )

        for (
            y = [
                lid_left_boss_y,
                lid_right_boss_y
            ]
        )

            translate([
                x,
                y,
                0
            ])

                children();
}


// =====================================================
// LID PILLARS
// =====================================================

module lid_bosses() {

    lid_screw_positions()

        cylinder(
            h = base_h,
            d = lid_boss_d
        );
}


// =====================================================
// LID PILOT HOLES
// =====================================================

module lid_pilot_holes() {

    lid_screw_positions()

        translate([
            0,
            0,
            base_h - lid_screw_depth
        ])

            cylinder(
                h = lid_screw_depth + eps,
                d = lid_pilot_hole_d
            );
}


// =====================================================
// PCB POSTS
// =====================================================

module pcb_posts() {


    // -------------------------------------------------
    // ADC POSTS
    // -------------------------------------------------

    adc_post_positions()

        cylinder(
            h = pcb_clearance,
            d = adc_post_d
        );


    // -------------------------------------------------
    // PICO STEPPED POSTS
    // -------------------------------------------------

    pico_post_positions() {

        // Lower strong section

        cylinder(
            h = pico_post_lower_h,
            d = pico_post_lower_d
        );


        // Narrow upper section

        translate([
            0,
            0,
            pico_post_lower_h
        ])

            cylinder(
                h = pico_post_upper_h,
                d = pico_post_upper_d
            );
    }
}


// =====================================================
// PCB SCREW PILOT HOLES
// =====================================================

module pcb_screw_holes() {


    // -------------------------------------------------
    // ADC - M3 SELF-CUTTING
    // -------------------------------------------------

    adc_post_positions()

        translate([
            0,
            0,
            pcb_clearance - adc_screw_depth
        ])

            cylinder(
                h = adc_screw_depth + eps,
                d = adc_screw_hole_d
            );


    // -------------------------------------------------
    // PICO - M2 SELF-CUTTING
    // -------------------------------------------------

    pico_post_positions()

        translate([
            0,
            0,
            pcb_clearance - pico_screw_depth
        ])

            cylinder(
                h = pico_screw_depth + eps,
                d = pico_screw_hole_d
            );
}


// =====================================================
// FRONT WALL CUTOUTS
// =====================================================

module front_cutouts() {


    // -------------------------------------------------
    // ADC CABLE / CONNECTOR OPENING
    // -------------------------------------------------

    translate([
        -eps,

        adc_opening_y -
        adc_opening_w / 2,

        opening_bottom_z
    ])

        cube([
            wall + 2 * eps,
            adc_opening_w,
            adc_opening_h
        ]);


    // -------------------------------------------------
    // USB CABLE NOTCH - STRAIGHT SECTION
    // -------------------------------------------------

    translate([
        -eps,

        case_y / 2 -
        usb_notch_w / 2,

        base_h -
        usb_notch_depth +
        usb_notch_w / 2
    ])

        cube([
            wall + 2 * eps,
            usb_notch_w,
            usb_notch_depth
        ]);


    // -------------------------------------------------
    // USB CABLE NOTCH - ROUNDED BOTTOM
    // -------------------------------------------------

    translate([
        -eps,

        case_y / 2,

        base_h -
        usb_notch_depth +
        usb_notch_w / 2
    ])

        rotate([0, 90, 0])

            cylinder(
                h = wall + 2 * eps,
                d = usb_notch_w
            );


    // -------------------------------------------------
    // SWITCH BODY OPENING
    // -------------------------------------------------

    translate([
        -eps,

        switch_opening_y -
        switch_opening_w / 2,

        switch_opening_z
    ])

        cube([
            wall + 2 * eps,
            switch_opening_w,
            switch_opening_h
        ]);


    // -------------------------------------------------
    // SWITCH MOUNTING PILOT HOLES
    // -------------------------------------------------

    for (
        sy = [
            switch_opening_y -
            switch_screw_spacing / 2,

            switch_opening_y +
            switch_screw_spacing / 2
        ]
    )

        translate([
            -eps,

            sy,

            switch_opening_z +
            switch_opening_h / 2
        ])

            rotate([0, 90, 0])

                cylinder(
                    h = wall + 2 * eps,
                    d = switch_screw_hole_d
                );
}


// =====================================================
// REAR WALL CUTOUT
// =====================================================

module rear_cutout() {

    translate([
        case_x - wall - eps,

        rear_radio_opening_y,

        rear_radio_opening_z
    ])

        cube([
            wall + 2 * eps,

            rear_radio_opening_w,

            rear_radio_opening_h
        ]);
}


// =====================================================
// ENCLOSURE SHELL
// =====================================================

module enclosure_shell() {

    difference() {

        // Outer enclosure

        cube([
            case_x,
            case_y,
            base_h
        ]);


        // Hollow interior

        translate([
            wall,
            wall,
            floor_t
        ])

            cube([
                case_x - 2 * wall,
                case_y - 2 * wall,
                base_h - floor_t + eps
            ]);


        // Front-wall openings

        front_cutouts();


        // Rear radio opening

        rear_cutout();
    }
}


// =====================================================
// BASE
// =====================================================

module base_model() {

    difference() {

        union() {

            enclosure_shell();

            lid_bosses();

            pcb_posts();
        }


        // Lid self-cutting pilot holes

        lid_pilot_holes();


        // PCB self-cutting pilot holes

        pcb_screw_holes();
    }
}


// =====================================================
// LID
// =====================================================

module lid_model() {

    difference() {

        // Lid plate

        cube([
            case_x,
            case_y,
            lid_t
        ]);


        // -------------------------------------------------
        // M2.5 CLEARANCE HOLES
        // -------------------------------------------------

        lid_screw_positions()

            translate([
                0,
                0,
                -eps
            ])

                cylinder(
                    h = lid_t + 2 * eps,
                    d = lid_clearance_hole_d
                );


        // -------------------------------------------------
        // OPTIONAL COUNTERSINKS
        // -------------------------------------------------

        if (lid_countersink)

            lid_screw_positions()

                translate([
                    0,
                    0,
                    lid_t -
                    lid_countersink_depth
                ])

                    cylinder(
                        h =
                            lid_countersink_depth +
                            eps,

                        d1 =
                            lid_clearance_hole_d,

                        d2 =
                            lid_countersink_d
                    );
    }
}


// =====================================================
// OUTPUT
// =====================================================

if (part == "base")
    base_model();


if (part == "lid")
    lid_model();