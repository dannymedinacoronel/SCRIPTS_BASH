#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
#
####################<---DECLARACIÓ DE CONSTANTS--->###########################
declare -r GID_MIN=1000
declare -r GID_MAX=65533
#Per moltes distribucions GID_MIN=1000 és un valor convenient per on començar
# El group nogroup té el valor 65534
#Algunes distribucions tenen el grup nobody amb valor 65533 
#####################CÀLCUL D'UNA PROPOSTA DE GID PEL NOU GRUP##################################
# Això no ho demana l'enunciat. És un extra.
nou_gid=$GID_MIN
for opc_gid in $(cat /etc/group | cut -d ":" -f 3 | sort -n)  
do
	if (( opc_gid >= GID_MIN )) && (( opc_gid < GID_MAX ))
	then
		if (( opc_gid > nou_gid ))
		then
			break
		else
			nou_gid=$(( opc_gid + 1 ))
		fi
	fi
done
###############RECOLLINT DADES###############################
echo "PROGRAMA DE CREACIO DE GRUPS D'USUARIS"
echo
echo -n "Dona el nom del nou grup d'usuaris: "
read nom_grup
echo -n "Dona el GID del nou grup d'usuaris (primer valor lliure: $nou_gid): "
read gid 
###############CREACIÓ DEL GRUP. MOSTRANT L'ENTRADA PEL NOU GRUP####################################
groupadd -g $gid $nom_grup 2> /dev/null
if (( $? != 0 ))
then
	echo "No s'ha pogut crear el nou grup d'usuaris"
	exit 1
else
	echo "El grup ha estat creat amb exit"
	cat /etc/group | grep $nom_grup	
fi
########################FINALITZANT###################################
exit 0
