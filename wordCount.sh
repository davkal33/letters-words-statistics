#!/bin/bash
#************************************$1 plik wejsciowy $2 plik wyjsciowy***************************************

declare -A tab

if [ -r $1 ] && [ -e $1 ]; then     #sprawdzanie prawa do odczytu i czy plik istnieje
	echo "Masz prawo do odczytu pliku zrodlowego"
else
	echo "Nie masz prawa do odczytu pliku zdrodlowego lub plik niestnieje"
	exit -1
fi

if [ -e $2 ]; then     #sprawdzanie czy plik docelowy istnieje
	if [ -w $2 ]; then   #sprawdzanie prawa do zapisu
		echo "Plik docelowy istnieje, masz prawo do zapisu"
	else
		echo "Plik istnieje, nie masz prawa do zapisu"
		exit -1
	fi
else
	echo "Plik docelowy nie istnieje,probuje stworzyc nowy plik o nazwie text.txt"
	touch text.txt || exit    #jesli nie da sie utworzyc pliku, konczymy dzialanie skryptu
	
fi


while read -ra line
do
	for word in "${line[@]}"
	do
		m=0 #flaga
		for x in ${!tab[@]}    #petla sprawdzajaca czy litera istnieje w tablicy jako klucz
		do
			if [[ $word == $x ]];then
				tab[$x]=$[${tab[$x]}+1]   #istnieje, wiec inkrementujemy
				m=$[$m+1]   #fala mowiaca czy slowo istnieje czy nie
			else
				continue
			fi
		done
		if [[ $m == 0 ]]; then     #litera nie istnieje, bo flaga m=0
			tab+=(["$word"]=1)    #tworzymy nowy klucz (dodajemy nowa litere do naszych statystyk)
		else
			continue
		fi
	done
done < "$1"



for x in ${!tab[@]}
do
	echo "$x ${tab[$x]}"
done |
sort -rn -k2 >> "$2"    #sortowanie malejace i zapis do pliku docelowego'


