#!/bin/sh

if test $# -lt 2
then 
    echo "Usage: $0 collection dir1 dir2 ... dirN" 1>&2
    exit 1
fi

collection=$1
shift

if ! test -d $collection
then     
    mkdir $collection
else
    if test $(ls $collection | wc -l) -ne 0
    then
        rm -r $collection/*
    fi
fi

for d in "$@"
do
    if ! test -d "$d"
    then 
        echo "no dir $d" 1>&2
        exit 1
    fi

    find "$d" -type f | grep -iE '\.(jpg|jpeg|png|tiff)$' | sort | while read filepath
    do
        filename=$(basename "$filepath" | tr A-Z a-z | tr ' ' '-')

        name=$(echo $filename | sed -E 's/(.*)\.[a-z]+$/\1/')

        extension=$(echo $filename | sed -E 's/^.*\.([a-z]+$)/\1/')

        dirname=$(basename "$d" | tr A-Z a-z | tr ' ' '-')
        
        if test $extension = "jpeg"
        then
            new_name="${dirname}_${name}.jpg"
        else
            new_name="${dirname}_${name}.${extension}"
        fi
        
        echo "Copiando '$filepath' -> '$new_name'"
        
        cp "$filepath" "$collection/$new_name"
    done
done

cd $collection
ls -l | grep -iE '\.(jpg|png|tiff)$' | awk '{print $9 " " $5}' | sort -n -k2 > metadata.txt
cat metadata.txt | awk '{size=size+$2} END{print "TOTAL: " size " bytes"}' >> metadata.txt
