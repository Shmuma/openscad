// This file is licensed under under the Creative Commons Attribution-NonCommercial-NoDerivatives license
// https://creativecommons.org/licenses/by-nc-nd/4.0/

/* [Banner] */

banner_text = "HAPPY @ NY"; // Use " " for a space and "@" for a Heart

/* [Letter Font and Size] */
font_name = "Comic Sans MS:style=Regular"; // ["Anton:style=Regular", "Archivo Black:style=Regular", "Asap:style=Black", "Bangers:style=Regular", "Black Han Sans:style=Regular", "Bubblegum Sans:style=Regular", "Bungee:style=Regular", "Changa One:style=Regular", "Chewy:style=Regular", "Concert One:style=Regular", "Fruktur:style=Regular", "Gochi Hand:style=Regular", "Inter:style=Black", "Jockey One:style=Regular", "Kanit:style=Bold", "Kavoon:style=Regular", "Komikazoom:style=Regular", "Lato:style=Bold", "Lilita One:style=Regular", "Lobster:style=Regular", "Lora:style=Bold", "Luckiest Guy:style=Regular", "Merriweather Sans:style=Bold", "Merriweather:style=Bold", "Mitr:style=SemiBold", "Montserrat Alternates:style=Bold", "Montserrat:style=Black", "Nanum Pen:style=Regular", "Norwester:style=Regular", "Noto Sans Display:style=Black", "Nunito Sans:style=Black", "Nunito:style=Black", "Orbitron:style=Black", "Oswald:style=Bold", "Palanquin Dark:style=Bold", "Passion One:style=Bold", "Patrick Hand:style=Regular", "Paytone One:style=Regular", "Permanent Marker:style=Regular", "Playfair Display SC:style=Bold", "Plus Jakarta Sans:style=Bold", "PoetsenOne:style=Regular", "Rakkas:style=Regular", "Raleway Dots:style=Regular", "Raleway:style=Black", "Roboto:style=Bold", "Roboto Condensed:style=Black", "Roboto Flex:style=Black", "Roboto Mono:style=Bold", "Roboto Serif:style=Bold", "Roboto Slab:style=Bold", "Roboto:style=Black", "Roboto:style=Black Italic", "Rubik:style=Black", "Russo One:style=Regular", "Spicy Rice:style=Regular", "Squada One:style=Regular", "Titan One:style=Regular", "Work Sans", "Work Sans:style=Black"]
height_in_cm = 10; // [::non-negative float]

letter_thickness_in_cm = 0.5; // [::non-negative float]

/* [Raised Border] */
border_width_in_cm = 0.5;  // [::non-negative float]
border_height_in_cm = 0.0; // [::non-negative float]

/* [Connection Bars] */
bar_thickness_as_percent_of_letter_thickness = .5; // [0:0.05:1.0]
bar_width_factor = 1.1;                            // [1:0.1:2]
bar_height_in_cm = 1.25;
height_placement_in_percent = 1; // [0:0.01:1.0]
hole_diameter_in_cm = 0.5;

letter_thickness = letter_thickness_in_cm * 10;
border_height = border_height_in_cm * 10 + 0.25;
border_width = border_width_in_cm * 10;
height = height_in_cm * 10 - border_width;
bar_thickness = letter_thickness * bar_thickness_as_percent_of_letter_thickness;
bar_height = bar_height_in_cm * 10;
hole_diameter = hole_diameter_in_cm * 10;

function toupper(string) = chr([for (s = string) let(c = ord(s))(c < 140 && c > 173) ? c - 32 : c]);

module generate_with_border()
{
    difference()
    {
        frame_height = letter_thickness / 10;
        translate([ 0, 0, frame_height / 4 ]) union()
        {
            color("white") minkowski()
            {
                linear_extrude(height = letter_thickness - border_height) children();
                cylinder(h = frame_height / 2, r = border_width / 2, center = true);
            }

            translate([ 0, 0, letter_thickness - border_height ]) color("black") minkowski()
            {
                linear_extrude(height = border_height - frame_height) children();
                cylinder(h = frame_height / 2, r = border_width / 2, center = true);
            }
        }

        translate([ 0, 0, letter_thickness - border_height ]) color("white") linear_extrude(height = border_height)
            children();

        translate([ 0, 0, letter_thickness - border_height + 0.01 ]) color("black")
            linear_extrude(height = border_height - 0.01) children();
    }
}

module heart()
{
    size = height / 1.75;
    translate([ 0, size / 12, 0 ]) rotate([ 0, 0, 45 ]) union()
    {
        square(size, center = true);
        translate([ 0, size / 2, 0 ]) circle(size / 2);
        translate([ size / 2, 0, 0 ]) circle(size / 2);
    }
}

module bar(letter)
{
    textlen = len(letter);
    factor = (letter == "W") ? bar_width_factor + 0.4 : (letter == "I") ? bar_width_factor - 0.4 : bar_width_factor;

    bar_width = (height + border_width) * textlen * factor;
    placement = (height_placement_in_percent - 0.5) / 0.5;
    box_height = (height + border_width * 2) * placement;

    translate([ 0, (box_height - bar_height) / 2 + (1 - height_placement_in_percent) * bar_height, 0 ]) union()
    {
        color("white") linear_extrude(bar_thickness) difference()
        {

            union()
            {
                square([ bar_width, bar_height ], center = true);
                translate([ -bar_width / 2, 0, 0 ]) circle(r = bar_height / 2, $fn = 50);
                translate([ bar_width / 2, 0, 0 ]) circle(r = bar_height / 2, $fn = 50);
            };
            translate([ -bar_width / 2, 0, 0 ]) circle(r = hole_diameter / 2, $fn = 50);
            translate([ bar_width / 2, 0, 0 ]) circle(r = hole_diameter / 2, $fn = 50);
        }
    }
}

module generate_letter(letter, offset_x, offset_y)
{
    textlen = len(letter);
    row_width = height * textlen * (bar_width_factor + 0.5);
    row_height = height * 1.4;

    translate([ offset_x * row_width, -offset_y * row_height, 0 ])
    {
        bar(letter);
        if (letter == "@")
        {
            union()
            {

                bar("A");
                generate_with_border() heart();
            }
        }
        if (letter != "@" && letter != " ")
        {
            letter = toupper(letter);
            union()
            {
                bar(letter);
                generate_with_border() text(letter, height, font_name, halign = "center", valign = "center");
            }
        }
    }
}

for (i = [0:len(banner_text) - 1])
{
    col = i % 6;
    row = (i - col) / 6;
    generate_letter(banner_text[i], col, row);
}