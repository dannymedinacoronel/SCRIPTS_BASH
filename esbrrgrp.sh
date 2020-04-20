#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
#
###########RECOLLINT DADES DEL GRUP A ESBORRAR######################################
echo "PROGRAMA PER ESBORRAR GRUPS D'USUARIS"
echo
echo -n "Dona el nom del grups d'usuaris: "
read nom_grup
############ESBORRANT EL GRUP#######################
groupdel $nom_grup 2> /dev/null
if (( $? != 0 ))
then
	echo "El grup $nom_grup no existeix o no s'ha pogut esborrar"
	exit 1
else
	echo "El grup $nom_grup ha estat esborrat"	
fi
########################FINALITZANT###################################
exit 0
