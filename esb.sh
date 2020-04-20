#!/bin/bash
clear
case $1 in 
	-e) if (( $# != 3 )) 
		then
			echo "Nombre de paràmetres incorrecte"
			echo "L'opció -e necessita 3 paràmetres"
			echo "La primera opció és -e"
			echo "La segona opció és l'extensió dels fitxers a enviar a la paperera"
			echo "La tercera opció és el directori a on es troben els fitxers a enviar a la paperera"
			exit 2
		fi
		if [[ ! -d ~/paperera ]]
		then
			mkdir ~/paperera
		fi
		if [[ ! -d $3 ]]
		then
			echo "La carpeta no existeix"
		else
			if (( $(ls -A $3/*.$2 2> /dev/null | wc -l) != 0 ))
			# Comprova si hi ha fitxers amb l'extensió demanada dins del directori. 
			# 2> /dev/null és per redireccionar avisos extres del bash.
			# 
			then
				mv $3/*.$2 ~/paperera
				echo "Els fitxers amb extensió $2 de la carpeta $3 s'han enviat a la paperera"
			else
				echo "Els fitxers amb l'extensió indicada no existeixen"
			fi
		 fi		 
		 ;;	 
	-r) if (( $# != 1 )) 
		then
			echo "Nombre de paràmetres incorrecte"
			echo "L'opció -r no necessita altres paràmetres"
			exit 1
		fi
		if [[ ! -d ~/paperera ]]
		then
			echo "La paperera encara no existeix"
		else
			if (( $(ls -A ~/paperera | wc -l) != 0 ))
			# Compte el número de fitxers d'una carpeta. Si la paperera està buida no cal intentar buidar-la 
			then
				rm ~/paperera/* #Això buida la paperera però no esborra el directori paperera
				echo "Paperera buida"
			else
				echo "La paperera ja està buida" # Això estrictament no ho demana l'enunciat 
			fi
		fi
		;;	
	*)  # Això és un extra que no està a l'enunciat
		echo "Primer paràmetre incorrecte"
	    echo "Utilització: "
	    echo "-r per buidar la paperera"
	    echo "-e per enviar fitxers a la paperera"
	    exit 3
	    ;;
esac
########################FINALITZANT###################################
exit 0
