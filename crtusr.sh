#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
#
##################DECLARACIÓ DE CONSTANTS#####################
declare -r UID_MIN=1000
declare -r UID_MAX=65534
############CÀLCUL D'UNA PROPOSTA D'UID PEL NOU USUARI########
# Això no ho demana l'enunciat. És un extra.
nou_uid=$UID_MIN
for uid in $(cat /etc/passwd | cut -d ":" -f 3 | sort -n)  
do
	if (( uid >= UID_MIN )) && (( uid < UID_MAX ))
	then
		if (( uid > nou_uid ))
		then
			break
		else
			nou_uid=$(( uid + 1 ))
		fi
	fi
done
###############RECOLLINT DADES###############################
echo "PROGRAMA DE CREACIO D'USUARIS"
echo
echo -n "Dona el nom de l'usuari: "
read nom_usuari
echo -n "Dona el UID de l'usuari (primer valor lliure: $nou_uid): "
read uid_usuari
echo -n "Dona el grup per defecte al qual pertany l'usuari: "
read grup_usuari
echo -n "Dona el nom complet del directori personal de l'usuari: "
read dir_usuari
echo -n "Dona el nom complet del shell per defecte de l'usuari: "
read shell_usuari
echo -n "Dona la contrasenya de l'usuari: "
read ctsnya_usuari
##############CREACIÓ DE L'USUARI. MOSTRANT L'ENTRADA PEL NOU USUARI########
useradd $nom_usuari -u $uid_usuari -g $grup_usuari -d $dir_usuari -m -s $shell_usuari -p `mkpasswd $ctsnya_usuari` 2> /dev/null
if (( $? !=  0 ))
then
	echo "S'han passat un o mes parametres de manera incorrecta"
	exit 1
else
	echo "L'usuari ha creat amb exit"
	cat /etc/passwd | grep $nom_usuari	
fi
########################FINALITZANT###################################
exit 0
