#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
##################RECOLLINT DADES###############################################
echo -n "Indica el nom del nou usuari del domini: "
read nom_uid
echo -n "Indica el nom del domini de nivell superior: "
read dnsup
echo -n "Indica el nom del domini de segon nivell: "
read dsn
echo -n "Indica el nom de l'unitat organitzativa: "
read ou
##################MODIFICANT LA CONTRASENYA D'USUARI#################################
ldappasswd -h localhost -x -D "cn=admin,dc=$dsn,dc=$dnsup" -W -S "uid=$nom_uid,ou=$ou,dc=$dsn,dc=$dnsup"
if (( $? -ne 0 ))
then
	echo "NO S'HA MODIFICAT O CREAT LA CONTRASENYA DE L'USUARI $nom_uid"
	exit 1
fi	
################MOSTRANT LA BASE DE DADES LDAP#########################
slapcat
########################FINALITZANT###################################
exit 0
