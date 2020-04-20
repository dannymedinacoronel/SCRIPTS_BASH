#!/bin/bash
#
######FUNCIONS#############
function most_serv {
	clear
	echo "SERVEIS A POSAR EN MARXA:"
	echo "a) cups"
	echo "b) ssh"
	echo "c) apache2"
	echo -n "Selecciona una opció: "
	read opc	
	return 0
}

function ctl_serv {
	case $opc in
		a) systemctl status cups > /dev/null # > /dev/null evita que surtin per pantalla els missatges de l'ordre systemclt
		   if [[ $? -ne 0 ]] # L'opció status retorna un 0 dins de $? si el servei esta actiu i un valor diferent de 0 si està aturat
		   then				 # En el cas que el servei estigui aturat entrarà dins del "if" i posarà en marxa el servei
				systemctl start cups  
		   fi
		   ;;
		b) systemctl status ssh > /dev/null
		   if [[ $? -ne 0 ]]
		   then
				systemctl start ssh 
		   fi
		   ;;
		c) systemctl status apache2 > /dev/null
		   if [[ $? -ne 0 ]]
		   then
				systemctl start apache2 
		   fi
		   ;; 
		*) echo "Opció incorrecta";;
	esac
}
####PROGRAMA PRINCIPAL#########
#
#COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 1 # Finalització del script si l'usuari que l'executa no té privilegis de root. L'enunciat no diu res i he escollit sortir amb un codi de retorn igual a 1
fi
#CRIDA A FUNCIONS
most_serv
ctl_serv
# FINALITZANT SCRIPT AMB CODI DE SORTIDA IGUAL A 10
exit 10
