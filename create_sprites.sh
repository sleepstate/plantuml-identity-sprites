#!/usr/bin/env bash

# Default parameters
dir="./icons/png"    # Directory path to process PNG files
graylevel=16         # Number of grayscale colors, default: 16
prefix="ID1"         # Default prefix
puml_dir="$(pwd)/puml"  # Use absolute path for puml directory
meta_dir="$(pwd)/meta"    # Use absolute path for meta directory
report_file="${meta_dir}/sprite_report.log"

# Function to log progress
log_progress() {
    mkdir -p "$meta_dir" || { echo "Error: Failed to create meta directory"; exit 1; }
    echo "$1" | tee -a "$report_file"
}

# Ensure necessary directories exist
ensure_directories() {
    mkdir -p "$puml_dir" || { echo "Error: Failed to create puml directory"; exit 1; }
    mkdir -p "$meta_dir" || { echo "Error: Failed to create meta directory"; exit 1; }
    log_progress "Directories ensured: $puml_dir and $meta_dir."
}

########################################
#
#    Main function
#
########################################
main () {
    # Get arguments
    while getopts p:g: option; do
        case "$option" in
            p) dir="$OPTARG";;
            g) graylevel="$OPTARG";;
            :) echo "$usage"
               exit 1;;
           \?) echo "$usage"
               exit 1;;
        esac
    done

    # Get mandatory argument for prefix
    shift $((OPTIND-1))
    prefix=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    prefixupper=$(echo "$1" | tr '[:lower:]' '[:upper:]')

    # Check if the prefix was provided
    if [ -z "$prefix" ]; then
        echo "Please specify a prefix!"
        exit 1
    fi

    # Ensure necessary directories exist before any file operations
    ensure_directories

    # Setup index generation
    index_file="${meta_dir}/index.md"
    echo "# Icon Set for $dir" > "$index_file"
    echo "### Overview of Generated Icons" >> "$index_file"
    echo "| Name  | Macro  | Image | PUML Path |" >> "$index_file"
    echo "|-------|--------|-------|-----------|" >> "$index_file"
    
    log_progress "Initialized index file at $index_file."

    # Change to directory with images
    cd "$dir" || { echo "Error: Failed to change directory to $dir"; exit 1; }

    process_png
}

########################################
#
#    Generate PlantUml sprite
#
########################################
process_png () {
    for i in *.png; do
        [ -f "$i" ] || continue

        # Process and standardize the PNG filenames
        filename=$(basename "$i" .png)
        filenameupper=$(echo "$filename" | tr '[:lower:]' '[:upper:]')
        spritename="${prefix}_$filename"
        spritenameupper="${prefixupper}_$filenameupper"
        spritestereo="$prefixupper $filenameupper"

        # Generate PUML for each PNG
        puml_file="${puml_dir}/${filename}.puml"

        # Debugging: Output absolute path for file
        echo "Attempting to create file at: $puml_file"

        # Create and write to the PUML file directly
        if ! echo "@startuml" > "$puml_file"; then
            echo "Error: Failed to write to $puml_file (at the '@startuml' line)"
            exit 1
        fi

        # Add encoded sprite (simplified for now)
        if ! echo "$(plantuml -encodesprite $graylevel $i)" >> "$puml_file"; then
            echo "Error: Failed to encode sprite for $filename"
            exit 1
        fi
        
        # Add PUML definitions for different sprite configurations
        {
            echo "!define $spritenameupper(_color) SPRITE_PUT($spritename, _color)"
            echo "!define $spritenameupper(_color, _scale) SPRITE_PUT($spritename, _color, _scale)"
            echo "!define $spritenameupper(_color, _scale, _alias) SPRITE_ENT(_alias, $spritestereo, $spritename, _color, _scale)"
            echo "!define $spritenameupper(_color, _scale, _alias, _shape) SPRITE_ENT(_alias, $spritestereo, $spritename, _color, _scale, _shape)"
            echo "!define $spritenameupper(_color, _scale, _alias, _shape, _label) SPRITE_ENT_L(_alias, $spritestereo, _label, $spritename, _color, _scale, _shape)"
            echo "skinparam folderBackgroundColor<<$spritenameupper>> White"
            echo "@enduml"
        } >> "$puml_file"
        
        # Log progress
        log_progress "Generated PUML for $filename -> $puml_file"

        # Update the index file
        echo "| $filename | ${prefixupper}_$filenameupper | ![image-$filename]($dir/$filename.png) | $puml_file |" >> "$index_file"
    done
}

main "$@"
