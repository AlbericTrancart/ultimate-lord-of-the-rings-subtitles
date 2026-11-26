#!/usr/bin/env bash
#NOTE: Just run the script from the root of the repo and commit changes `sh ./update_catppuccin.sh`
set -eu

if [ "$#" -gt 1 ]; then
    printf 'Usage: %s [repository-directory]\n' "$0" >&2
    exit 2
fi
cd -- "${1:-.}"

# Validate both source directories before generating anything.
for directory in foreign-only full-with-english; do
    if [ ! -d "$directory" ]; then
        printf 'Missing source directory: %s\nRun from the repository root or pass its path.\n' "$directory" >&2
        exit 1
    fi
done

# Quenya:       #0080C0 -> #89B4FA (blue)
# Sindarin:     #008000 -> #A6E3A1 (green)
# Adunaic:      #778899 -> #6C7086 (overlay0, listed in the PR description)
# Black Speech: #FF0000 -> #F38BA8 (red)
# Khuzdul:      #FF8000 -> #FAB387 (peach)
# Rohirric:     #800080 -> #CBA6F7 (mauve, used in the PR's files)
# Translation:  #FFFF00 -> #F9E2AF (yellow, used in the PR's files)
for directory in foreign-only full-with-english; do
    find "$directory" \
        -type d -iname '*catppuccin*' -prune -o \
        -type f -iname '*.srt' -exec sh -eu -c '
            base=$1
            shift
            for source do
                destination="${base}-catppuccin/${source#"$base"/}"
                mkdir -p -- "${destination%/*}"
                sed \
                    -e "s/#0080C0\b/#89B4FA/gI" \
                    -e "s/#008000\b/#A6E3A1/gI" \
                    -e "s/#778899\b/#6C7086/gI" \
                    -e "s/#FF0000\b/#F38BA8/gI" \
                    -e "s/#FF8000\b/#FAB387/gI" \
                    -e "s/#800080\b/#CBA6F7/gI" \
                    -e "s/#FFFF00\b/#F9E2AF/gI" \
                    "$source" > "$destination"
                printf "%s\n" "$destination"
            done
        ' sh "$directory" {} +
done
