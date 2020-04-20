#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
#
###########RECOLLINT DADES DE L'USUARI A ESBORRAR I DE LA MANERA D'ESBORRAR-LO####################
echo "PROGRAMA PER ESBORRAR USUARIS"
echo
echo -n "Dona el nom de usuari: "
read nom_usuari
echo -n "Vols esborrar el directori personal de l'usuari $nom_usuari i tots el seu contingut (s/n): "
read opc
############ESBORRANT L'USUARI#######################
if [[ $opc == "n" ]]
then
	userdel $nom_usuari 2> /dev/null
	if (( $? != 0 ))
	then
		echo "L'usuari $nom_usuari no existeix"
		exit 1
	else
		echo "Usuari $nom_usuari esborrat"
		exit 0
	fi 
else
	userdel -r $nom_usuari 2> /dev/null
	if (( $? != 0 ))
	then
		echo "L'usuari $nom_usuari i/o el seu directori personal  no existeixen"
		exit 1
	else
		echo "L'usuari $nom_usuari i el seu directori personal han estat esborrats"		
	fi
fi
########################FINALITZANT###################################
exit 0
