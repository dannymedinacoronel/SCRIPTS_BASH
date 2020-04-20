#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
#
opc="n"
until [[ $opc == "s" ]] || [[ $opc == "S" ]] #Una manera de solucionar el problema de les majúscules i minúscules
do
	clear
	############################### RECOLLINT DADES DE CONFIGURACIÓ#################################
	LLISTA_IF=$(ip link show | grep mtu | cut -d ":" -f 2 | tr -d ' ') # Això és un extra informatiu que no està a l'ennunciat
	echo -n "Dóna el nom de la interfície que vols configurar ("$LLISTA_IF"): "
	read IF
	echo -n "Dóna el valor de l'adreça IP: "
	read DIR_IP
	echo -n "Dóna el valor de la màscara de subxarxa (format CIDR): "
	read MASC
	echo -n "Dóna el valor de l'adreça IP del router: "
	read ROUTER
	echo -n "Dóna el valor del servidor DNS primari: "
	read DNS1
	echo -n "Dóna el valor del servidor DNS secundari: "
	read DNS2
	echo "****************************************************"
	############################### CONFIGURANT LA INTERFÍCIE I SERVIDORS DNS#################################
	ip addr flush dev $IF 2> /dev/null #Netejant les dades actuals de les interfícies
	#
	ip addr add $DIR_IP/$MASC dev $IF 2> /dev/null #Configuració d'IP i màscara per la interfície indicada 
	#
	ip route add default via $ROUTER 2> /dev/null #Configuració de l'adreça IP del router
	#
	#Això és un extra de seguretat. Faig un backup del fitxer /etc/resolv.con abans de modificar-lo
	data=`date +20%y%m%d%H%M`
	cp /etc/resolv.conf /etc/resolv.conf.backup.$data 
	#Final de l'extra de seguretat. Deixo el backup dins del directori /etc
	echo "#Fitxer creat amb el script ifconf" > /etc/resolv.conf # Això és un extra informatiu que no està a l'ennunciat
	echo "nameserver $DNS1" >> /etc/resolv.conf
	echo "nameserver $DNS2" >> /etc/resolv.conf
	#
	##################### MOSTRANT LA CONFIGURACIÓ DE LA INTERFÍCIE I SERVIDORS DNS##############################
	echo "Configuració de la interfície de xarxa:"
	ip a | grep $1 | tail -1 | cut -d " " -f 6
	echo
	echo "Configuració del router"
	ip route | grep "default" | cut -d " " -f 3
	echo
	echo "Configuració dels servidor DNS"
	cat /etc/resolv.conf | grep "nameserver" | cut -d " " -f 2
	echo "***************************************************"
	echo -n "La interfície ha estat configurada correctament [s/n]?: "
	read opc
done
########################FINALITZANT###################################
exit 0
