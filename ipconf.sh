#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 1
fi
############################### CONFIGURANT LA INTERFÍCIE I SERVIDORS DNS#################################
if (( $# == 5 )) || (( $# == 6 ))
then
	# Adreça IP
	ip addr flush dev $1 2> /dev/null #Netejant les dades actuals de les interfícies
	ip addr add $2/$3 dev $1 2> /dev/null #Configuració d'IP i màscara per la interfície indicada
	# Adreça IP del Router
	ip route add default via $4 2> /dev/null #Configuració de l'adreça IP del router
	#Això és un extra de seguretat. Faig un backup del fitxer /etc/resolv.con abans de modificar-lo
	data=`date +20%y%m%d%H%M`
	cp /etc/resolv.conf /etc/resolv.conf.backup.$data
	#Final de l'extra de seguretat. Deixo el backup dins del directori /etc
	echo "#Fitxer creat amb el script ipconf" > /etc/resolv.conf # Això és un extra informatiu que no està a l'ennunciat
	echo "nameserver $5" >> /etc/resolv.conf
	if (( $# == 6 ))
		then echo "nameserver $6" >> /etc/resolv.conf
	fi
else
	#Aquest else no es demana a l'ennunciat. És un extr
	echo "El número de paràmetres es incorrecte"
	echo "Han de afegir-se 5 o 6 paràmetres"
	echo "El primer paràmetre és la interfície de xarxa"
	echo "El segon paràmetre és l'adreça IP"
	echo "El tercer paràmetre és la màscara en format CIDR"
	echo "El quart paràmetre és l'adreça IP del router"
	echo "El 5è i 6è paràmetres són les adreces IP dels servidors DNS"
	echo "El 6è paràmetre és opcional"
	exit 2
fi
##################### MOSTRANT LA CONFIGURACIÓ DE LA INTERFÍCIE I SERVIDORS DNS##############################
#NOTA: Tampoc ho demana l'enunciat. És un extra.
echo "Configuració de la interfície de xarxa:"
ip a | grep $1 | tail -1 | cut -d " " -f 6
echo
echo "Configuració del router"
ip route | grep "default" | cut -d " " -f 3
echo
echo "Configuració dels servidor DNS"
cat /etc/resolv.conf | grep "nameserver" | cut -d " " -f 2
########################FINALITZANT###################################
exit 0
