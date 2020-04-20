#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
#########################DEMANANT DADES################3#############
echo "PROGRAMA PER ESBORRAR AUTOMÀTICAMENT ELS USUARIS CREATS AMB mltpusr.sh"
echo
echo -n "Dóna el nom base pels usuaris: "
read nom_base
################ESBORRANT USUARIS I FITXERS DE PASSWORDS################
for nom in $(cat /etc/passwd | grep ".clot" | cut -d ":" -f 1)
do
	userdel -r $nom 2> /dev/null
	if (( $? != 0 ))
	then
		echo "Problema esborrant els usuaris"
		exit 1
	fi
done 
rm /root/$nom_base 2> /dev/null
########################FINALITZANT###################################
exit 0
