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

for i in $(find $Ordner -iname '*.mov' -size +50k ) ; do
	EXIF=$(exiftool -Model -d '%Y%m%d_%H%M%S' -CreateDate $i)
	RC=$?
	MODEL=$(echo "$EXIF" | grep Model | cut -d\: -f2- | tr -d [:punct:] | tr -s ' ' '_' )
	DATUM=$(echo "$EXIF" | grep Create | cut -d\: -f2 | tr -d ' ')
	if [ $RC -eq 0 ] && [ "$DATUM" != "" ] ; then
		mv $i $(dirname $i)/${DATUM}$MODEL.mov
	fi
done
