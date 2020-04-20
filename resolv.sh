#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
##################CREANT LES CÒPIES DE SEGURETAT###################################
if (( $# != 1 )) # Això és un extra.
then
	echo "AVÍS!!!!"
	echo "El programa no es pot executar. S'ha de passar com a mínim un paràmetre"
	echo "El paràmetre ha de ser el subdirectori a on es desaran les còpies de seguretat"
	exit 2
fi
echo "CREANT LA CÒPIA DE SEGURETAT DE  resolv.conf"
echo
if [[ ! -d /root/$1 ]]
then
	echo -n "El subdirectori no existeix. Vols crear-lo (s/n)?: "
	read opc
	if [[ $opc != "s" ]] && [[ $opc != "S" ]]
	then
		echo "No s'ha creat el subdirectori"
		exit 1
	else
		mkdir /root/$1
	fi
fi
nom_backup=/root/$1/resolv.conf.backup.$(date +"%Y%m%d%H%M")
cp /etc/resolv.conf $nom_backup 
gzip $nom_backup
if [[ -e $nom_backup ]]; then rm $nom_backup; fi
########################FINALITZANT###################################
exit 0
