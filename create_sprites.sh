#!/usr/bin/env bash

# Default parameters (modifiable)
output_dir="./icons"
png_dir="${output_dir}/png"
svg_dir="${output_dir}/svg"
dir="./"
graylevel=16
width=48
height=48
prefix="ID1"
color="black"  # Default color for icons
background_color="transparent"  # Background color for PNGs
report_file="sprite_report.log"

# Help usage message
usage="Batch creates sprite files for PlantUML.

$(basename "$0") [options] prefix

options:
    -p  directory path to process (default: ./)
    -g  sprite graylevel (default: 16)
    -w  image width (default: 48)
    -h  image height (default: 48)
    -o  output directory (default: ./icons)
    -c  icon color (default: black)
    -b  background color (default: transparent)
    prefix: a prefix added to the sprite name."

# Function to log progress
log_progress() {
    echo "$1" | tee -a "$report_file"
}

# Main function
main () {
    log_progress "Initializing sprite generation..."
    
    # Get arguments
    while getopts p:w:h:g:o:c:b: option
    do
        case "$option" in
            p) dir="$OPTARG";;
            w) width="$OPTARG";;
            h) height="$OPTARG";;
            g) graylevel="$OPTARG";;
            o) output_dir="$OPTARG"; png_dir="${output_dir}/png"; svg_dir="${output_dir}/svg";;
            c) color="$OPTARG";;
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
    log_progress "Color: $color"
    log_progress "Background Color: $background_color"
    log_progress "Prefix: $prefix"

    # Ensure output directories exist
    mkdir -p "$png_dir"
    mkdir -p "$svg_dir"
    log_progress "Created output directories."

    # Change dir to where images are
    if [ ! -d "$dir" ]; then
        log_progress "Error: Invalid directory specified!"
        echo "$usage"
        exit 1
    fi

    cd "$dir"

    # Setup README generation in root
    echo "# Icon Set" > ../README.md
    echo "### Overview of Generated Icons" >> ../README.md
    echo "| Name  | Macro  | PNG  | PUML  |" >> ../README.md
    echo "|-------|--------|------|-------|" >> ../README.md
    log_progress "Initialized README generation."

    process_png
}

# Process PNG and generate PlantUml sprites
process_png () {
    log_progress "Processing PNG files..."
    
    for i in *.png; do
        [ -f "$i" ] || continue
        log_progress "Processing $i..."
        convert "$i" -resize "${width}x${height}" -background "$background_color" -fill "$color" "$png_dir/$i"
        mv "$i" "${i//-/_}"
    done

    for i in *.png; do
        [ -f "$png_dir/$i" ] || continue
        log_progress "Generating PUML for $i..."

        filename=$(echo "$i" | sed -e 's/.png$//')
        filenameupper=$(echo "$filename" | tr '[:lower:]' '[:upper:]')
        spritename="${prefix}_${filenameupper}"
        spritestereo="$prefix $filenameupper"
        stereowhites=$(echo "$spritestereo" | sed -e 's/./ /g')

        # Generate .puml file
        echo "@startuml" > "$svg_dir/$filename.puml"
        echo -e "$(plantuml -encodesprite $graylevel $png_dir/$i | sed -e '1!b' -e 's/\$/$'${prefix}_'/')\n" >> "$svg_dir/$filename.puml"
        echo "!define ${spritename}(_color) SPRITE_PUT($stereowhites $spritename, _color)" >> "$svg_dir/$filename.puml"
        echo "!define ${spritename}(_alias) ENTITY(rectangle,$color,$spritename,_alias,${spritename})" >> "$svg_dir/$filename.puml"
        echo "skinparam folderBackgroundColor<<$prefixupper $filenameupper>> White" >> "$svg_dir/$filename.puml"
        echo "@enduml" >> "$svg_dir/$filename.puml"

        # Update the README with PNG and PUML links
        echo "| $filename | ${spritename} | ![image-$filename](./icons/png/$filename.png) | $filename.puml |" >> ../README.md
        log_progress "Added $filename to README."
    done
    
    log_progress "PNG and PUML processing complete."
}

main "$@"
