#!/bin/bash
# Benennt Fotos im Ordner $1 zu dem in den EXIF enthaltenen Datum um

if [ "$1" == "" ] ; then
	Ordner="./"
else
	Ordner="$1"
	shift
fi

if ! which exiftool >/dev/null 2>&1 ; then
	echo "Bitte exiftool installieren. Z.B.:"
	echo "apt install exiftool"
	exit 2
fi

for i in $(find $Ordner -iname '*.3gp' -size +30k ) ; do
	EXIF=$(exiftool -d '%Y%m%d_%H%M%S' -mediacreatedate $i)
	RC=$?
        DATUM=$(echo "$EXIF" | grep 'Create Date' | cut -d\: -f2- | sed -e's/^ //' -e's/ /_/' -e's/:/-/g' -e's/Z$//')

	if [ $RC -eq 0 ] && [ "$DATUM" != "" ] ; then
		mv $i $(dirname $i)/${DATUM}_$(basename $i)
	fi
done
