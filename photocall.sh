#!/bin/sh

if test $# -lt 2
then
    echo "Usage: $0 collection dir1 [dir2 ...]" 1>&2
    exit 1
fi

collection="$1"
shift

if ! test -d "$collection"
then
    mkdir "$collection"
else
    if test $(ls "$collection" 2>/dev/null | wc -l) -ne 0
    then
        rm -r "$collection"/*
    fi
fi

for d in "$@"
do
    if ! test -d "$d"
    then
        echo "Error: '$d' is not a directory" 1>&2
        exit 1
    fi
done

tmp_file_list=$(mktemp)
tmp_metadata=$(mktemp)

for d in "$@"
do
    find "$d" -type f | grep -iE '\.(jpg|jpeg|png|tiff)$' >> "$tmp_file_list"
done

cat "$tmp_file_list" | sort | while read filepath
do
    filename=$(basename "$filepath" | tr A-Z a-z | tr ' ' '-')
    
    parent_path=$(dirname "$filepath")
    parent_name=$(basename "$parent_path" | tr A-Z a-z | tr ' ' '-')

    name=$(echo "$filename" | sed -E 's/(.*)\.[a-z]+$/\1/')
    extension=$(echo "$filename" | sed -E 's/^.*\.([a-z]+)$/\1/')

    if test "$extension" = "jpeg"
    then
        extension="jpg"
    fi

    new_name="${parent_name}_${name}.${extension}"
    target_path="$collection/$new_name"

    if test -f "$target_path"
    then
        echo "Error: Name collision detected. '$new_name' already exists." 1>&2
        rm -r "$collection"/*
        rm "$tmp_file_list" "$tmp_metadata"
        exit 1
    fi

    cp "$filepath" "$target_path"

    size=$(ls -l "$filepath" | awk '{print $5}')
    echo "$new_name $size" >> "$tmp_metadata"
done

if ! test -f "$tmp_file_list"
then
    exit 1
fi

sort -n -k2 "$tmp_metadata" > "$collection/metadata.txt"
awk '{sum+=$2} END {print "TOTAL: " sum " bytes"}' "$tmp_metadata" >> "$collection/metadata.txt"

rm "$tmp_file_list" "$tmp_metadata"