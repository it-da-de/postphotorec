#!/bin/bash
# Daten suchen in dem Verzeichniss $1 und zum Verzeichniss $2 nach Dateiendungen sortiert rsyncen

# Liste der Dateiendungen erstellen
declare -a endungen
# um ein Element zu dem index array hinzuzufügen kann man einfach endungen[${#endungen[*]}]=neues schreiben. Es wird aufsteigend hinzugefügt

for x in $(find $1/*/  | grep '\.[^/]*$' | sed -e's/.*\///' -e 's/.*\.//' -e 's/^[^.]*_\([^.]*\)$/\1/' | sort -u | grep -v -e '^$' ) ; do
	endungen[${#endungen[*]}]="$x"
done
echo "${#endungen[*]} Endungen gefunden"
#for (( i=0 ; $i < ${#endungen[*]} ; i++ )) ; do 
#	echo ${endungen[i]}
#done
#exit
for (( i=0 ; $i < ${#endungen[*]} ; i++ )) ; do 
	# prüfen ob Verzeichnis existiert
	if ! [ -d $2/${endungen[$i]} ] ; then
		mkdir -p $2/${endungen[$i]}
	fi
	echo ${endungen[$i]}
	for r in $1/recup_dir.* ; do
		rsync -Hharx $r/*.${endungen[$i]} $2/${endungen[$i]}  >/dev/null 2>&1
	done
done

