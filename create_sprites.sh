#!/usr/bin/env bash

# Default parameters
output_dir="./icons"
png_dir="${output_dir}/png"
svg_dir="${output_dir}/svg"
meta_dir="./meta"
puml_dir="./puml"
graylevel=16
width=48
height=48
prefix="ID1"
background_color="transparent"
report_file="sprite_report.log"
icon_md_file="Icons.md"

# Color themes to be showcased in the PlantUML diagram
declare -a color_themes=("black" "red" "blue" "green" "yellow")

# Help usage message
usage="Batch creates sprite files for PlantUML.

$(basename "$0") [options] prefix

options:
    -p  directory path to process (default: ./)
    -g  sprite graylevel (default: 16)
    -w  image width (default: 48)
    -h  image height (default: 48)
    -o  output directory (default: ./icons)
    -b  background color (default: transparent)
    prefix: a prefix added to the sprite name."

# Function to log progress
log_progress() {
    echo "$1" | tee -a "$report_file"
}

# Main function
main () {
    log_progress "Initializing icon processing..."

    # Get arguments
    while getopts p:w:h:g:o:b: option
    do
        case "$option" in
            p) dir="$OPTARG";;
            w) width="$OPTARG";;
            h) height="$OPTARG";;
            g) graylevel="$OPTARG";;
            o) output_dir="$OPTARG"; png_dir="${output_dir}/png"; svg_dir="${output_dir}/svg"; meta_dir="./meta";;
            b) background_color="$OPTARG";;
            :) echo "$usage"; exit 1;;
           \?) echo "$usage"; exit 1;;
        esac
    done

    log_progress "Using the following configuration:"
    log_progress "Directory: $dir"
    log_progress "Output Directory: $output_dir"
    log_progress "Image Width: $width, Height: $height"
    log_progress "Graylevel: $graylevel"
    log_progress "Background Color: $background_color"
    log_progress "Prefix: $prefix"

    # Ensure output directories exist
    mkdir -p "$png_dir"
    mkdir -p "$svg_dir"
    mkdir -p "$meta_dir"
    mkdir -p "$puml_dir"
    log_progress "Created output directories."

    # Initialize Icons.md file in root directory
    echo "# Icon Set" > "$icon_md_file"
    echo "### Overview of Generated Icons" >> "$icon_md_file"
    echo "| Name  | Macro  | Icon |" >> "$icon_md_file"
    echo "|-------|--------|-------|" >> "$icon_md_file"
    log_progress "Initialized Icons.md generation."

    # Initialize the theming demo PlantUML file
    puml_theming_demo="$puml_dir/theming_demo.puml"
    echo "@startuml" > "$puml_theming_demo"
    echo "title Icon Theming Demonstration" >> "$puml_theming_demo"
    echo "skinparam backgroundcolor transparent" >> "$puml_theming_demo"

    process_png
    process_svg

    # Finalize the theming demo PlantUML file
    echo "@enduml" >> "$puml_theming_demo"
    log_progress "Finalized theming demonstration PUML."

    # Generate the theming demonstration PNG from the PUML
    plantuml -tpng "$puml_theming_demo" -o "$meta_dir"
    log_progress "Generated the theming demonstration PNG."

    echo "Done."
}

# Process PNG files and update the Markdown table
process_png () {
    log_progress "Processing PNG files..."
    
    for i in "$png_dir"/*.png; do
        [ -f "$i" ] || continue
        filename=$(basename "$i" .png)
        filenameupper=$(echo "$filename" | tr '[:lower:]' '[:upper:]')
        spritename="${prefix}_${filenameupper}"

        # Add the icon to the Markdown table
        echo "| $filename | ${spritename} | ![icon](./icons/png/$filename.png) |" >> "$icon_md_file"
        
        # Add the sprite definition to the theming demo PUML file
        echo "!define ${spritename} SPRITE" >> "$puml_theming_demo"
        
        # Showcase each icon with different color themes
        echo "folder \"${filenameupper}\" {" >> "$puml_theming_demo"
        for color in "${color_themes[@]}"; do
            echo "  entity \"${filenameupper} in $color\" as ${spritename}_${color} <<${color}>>" >> "$puml_theming_demo"
        done
        echo "}" >> "$puml_theming_demo"

        log_progress "Processed $filename (PNG)."
    done
}

# Process SVG files and update the Markdown table
process_svg () {
    log_progress "Processing SVG files..."
    
    for i in "$svg_dir"/*.svg; do
        [ -f "$i" ] || continue
        filename=$(basename "$i" .svg)
        filenameupper=$(echo "$filename" | tr '[:lower:]' '[:upper:]')
        spritename="${prefix}_${filenameupper}"

        # Add the icon to the Markdown table
        echo "| $filename | ${spritename} | ![icon](./icons/svg/$filename.svg) |" >> "$icon_md_file"
        
        # Add the sprite definition to the theming demo PUML file
        echo "!define ${spritename} SPRITE" >> "$puml_theming_demo"
        
        # Showcase each icon with different color themes
        echo "folder \"${filenameupper}\" {" >> "$puml_theming_demo"
        for color in "${color_themes[@]}"; do
            echo "  entity \"${filenameupper} in $color\" as ${spritename}_${color} <<${color}>>" >> "$puml_theming_demo"
        done
        echo "}" >> "$puml_theming_demo"

        log_progress "Processed $filename (SVG)."
    done
}

main "$@"
