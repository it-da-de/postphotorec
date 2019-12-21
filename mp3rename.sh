#!/bin/bash
# Benennt mp3 im Ordner $1 um

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

for i in $(find $Ordner -iname '*.mp3' -size +100k ) ; do
	TRACK=""
	ALBUM=""
	TITEL=""
	ARTIST=""
	EXIF=$(exiftool -Track -Album -Title -Artist $i)
	RC=$?
	TRACK=$(printf "%02d" "$(echo "$EXIF" | grep Track | cut -d\: -f2- | sed -e's/^\s*[0]*//g' -e's/\/.*//g')")
	ALBUM=$(echo "$EXIF" | grep Album | cut -d\: -f2- | tr -d [:punct:] | sed -e's/^\s*//' | tr -s ' ' '_' )
	ARTIST=$(echo "$EXIF" | grep Artist | cut -d\: -f2- | tr -d [:punct:] | sed -e's/^\s*//' | tr -s ' ' '_' )
	TITEL=$(echo "$EXIF" | grep Title | cut -d\: -f2- | tr -d [:punct:] | sed -e's/^\s*//' | tr -s ' ' '_' )
	if [ "$ALBUM" = "" ] ; then ALBUM="$ARTIST" ; fi
	echo "$TRACK $ALBUM $TITEL"
	if [ $RC -eq 0 ] && [ "$ALBUM" != "" ] ; then
		if ! [ -d $Ordner/$ALBUM ] ; then  mkdir $Ordner/$ALBUM ; fi
		mv $i $Ordner/$ALBUM/${TRACK}-$TITEL.mp3
	fi
done
exit
# hier nur als Beispiel 
cat << EOF >/dev/null
ExifTool Version Number         : 10.10
File Name                       : f343374160.mp3
Directory                       : ../restore/recup_dir.63
File Size                       : 3.1 MB
File Modification Date/Time     : 2017:12:06 16:23:38+01:00
File Access Date/Time           : 2017:12:06 16:23:38+01:00
File Inode Change Date/Time     : 2017:12:06 16:23:38+01:00
File Permissions                : rw-r--r--
File Type                       : MP3
File Type Extension             : mp3
MIME Type                       : audio/mpeg
MPEG Audio Version              : 1
Audio Layer                     : 3
Audio Bitrate                   : 128 kbps
Sample Rate                     : 44100
Channel Mode                    : Stereo
MS Stereo                       : Off
Intensity Stereo                : Off
Copyright Flag                  : False
Original Media                  : False
Emphasis                        : None
Encoder                         : LAME3.92
Lame VBR Quality                : 4
Lame Quality                    : 5
Lame Method                     : CBR
Lame Low Pass Filter            : 13.8 kHz
Lame Bitrate                    : 128 kbps
Lame Stereo Mode                : Stereo
ID3 Size                        : 963
Artist                          : Taizé
Album                           : Chwala Panu
Title                           : Surrexit Christus
Year                            : 1995
Music CD Identifier             : (Binary data 804 bytes, use -b option to extract)
Track                           : 12
Genre                           : Meditative
Length                          : 201.706 s
Date/Time Original              : 1995
Duration                        : 0:03:21 (approx)
EOF
