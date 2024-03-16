#!/bin/bash

# Fonction pour récupérer la date
get_date() {
    date +"%Y/%m/%d %H:%M:%S"
}

# Fonction pour récupérer le nom d'utilisateur
get_user() {
    if [ -n "$USER42" ]; then
        echo "$USER42"
    else
        USER=$(whoami)
        if [ -z "$USER" ]; then
            echo "marvin"
        else
            echo "$USER"
        fi
    fi
}

# Fonction pour écrire le header avec le contenu spécifié dans un fichier
write_header() {
    local file_name="$1"
    local author="$2"
    local creation_date="$3"
    local updated_date="$4"
    local output_file="$5"

    header_width=74
    header_lines=11

    # Écrire le header dans un fichier temporaire
    {
        for ((i=1; i<=header_lines; i++)); do
            if [ $i -eq 1 ]; then
                printf "%s\n" "/* $(printf '*%.0s' $(seq 1 $header_width)) */"
            elif [ $i -eq 4 ]; then
                printf "/*   %-67s      */\n" "$file_name"
            elif [ $i -eq 6 ]; then
                printf "/*   %-63s    a      */\n" "By: $author <$author@student.42.fr>"
            elif [ $i -eq 8 ]; then
                printf "%s\n" "/*   Created: $(date "+%Y/%m/%d %H:%M:%S" -d "$creation_date") by $author           #+#    #+#             */"
            elif [ $i -eq 9 ]; then
                printf "%s\n" "/*   Updated: $(date "+%Y/%m/%d %H:%M:%S" -d "$updated_date") by $author          ###   ########.fr       */"
            elif [ $i -eq $header_lines ]; then
                printf "%s\n" "/* $(printf '*%.0s' $(seq 1 $header_width)) */"
            else
                printf "%s\n" "/*$(printf ' %.0s' $(seq 1 $(($header_width - 2))))    */"
            fi
        done

        # Ajouter un saut de ligne après le header
        echo
    } > "$output_file.tmp"

    # Lire le contenu actuel du fichier et le rajouter après le header dans le fichier temporaire
    if [ -f "$output_file" ]; then
        cat "$output_file" >> "$output_file.tmp"
    fi

    # Renommer le fichier temporaire en tant que fichier final
    mv "$output_file.tmp" "$output_file"
}

# Vérifier si le nombre d'arguments est incorrect
if [ $# -ne 1 ]; then
    echo "Usage: $0 fichier.c"
    exit 1
fi

# Définir les informations du header
file_name="$1"
author=$(get_user)
creation_date=$(get_date)
updated_date=$(get_date)
output_file="$1"

# Appeler la fonction pour écrire le header avec les informations spécifiées dans le fichier
write_header "$file_name" "$author" "$creation_date" "$updated_date" "$output_file"