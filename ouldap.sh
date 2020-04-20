#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
##################RECOLLINT DADES###############################################
echo -n "Indica el nom de la unitat organitzativa: "
read UnitOrg
echo -n "Indica el nom del domini de nivell superior: "
read DomNivSup
echo -n "Indica el nom del domini de segon nivell: "
read DomSegNiv
################CREANT EL FITXER LDIF###################################
echo "dn: ou=$UnitOrg,dc=$DomSegNiv,dc=$DomNivSup" > ou.ldif
echo "ou: $UnitOrg" >> ou.ldif
echo "objectClass: organizationalUnit" >> ou.ldif
##################CREANT LA UNITAT ORGANITZATIVA#################################
ldapadd -h localhost -x -D "cn=admin,dc=$DomSegNiv,dc=$DomNivSup" -W -f ou.ldif
if (( $? != 0 ))
then
	echo "LA UNITAT ORGANITZATIVA NO HA ESTAT CREADA"
	exit 1
fi
################MOSTRANT LA BASE DE DADES LDAP#########################
slapcat
########################FINALITZANT###################################
exit 0
