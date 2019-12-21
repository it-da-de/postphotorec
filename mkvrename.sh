#!/bin/bash
# Benennt movies im Ordner $1 zu dem in den EXIF enthaltenen Datum um

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

for i in $(find $Ordner -iname '*.mkv' -size +1M ) ; do
	EXIF=$(exiftool -writingapp -d '%Y%m%d_%H%M%S' -datetimeoriginal $i)
	RC=$?
	TITLE=$(echo "$EXIF" | grep 'Writing App' | cut -d\: -f2- | sed -e's/.*(\(.*\)).*/\1/' | tr -d [:punct:] | tr -s ' ' '_' ) 
	DATUM=$(echo "$EXIF" | grep 'Date/Time Original' | cut -d\: -f2- | sed -e's/^ //' -e's/ /_/' -e's/:/-/g' -e's/Z$//')
	if [ $RC -eq 0 ] && [ "$DATUM" != "" ] ; then
		mv $i $(dirname $i)/${DATUM}_$(basename ${i})_$TITLE.mkv
	fi
done
