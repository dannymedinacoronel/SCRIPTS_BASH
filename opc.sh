#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
#
## NOTA: No ho demana l'enunciat però, és molt convenient que aquest arxiu només pugui excutar-lo l'usuari root
#
###########MOSTRANT EL MENU I EXECUTANT L'OPCIÓ DEMANADA##############################
echo "MENU DE SELECCIÓ D'ARXIUS DE GUIÓ"
echo "Nota: Els arxius a executar han d'instal·lar-se al mateix directori que opc.sh"
echo "a) Executa crtusr.sh"
echo "b) Executa esbrrusr.sh"
echo "c) Executa crtgrp.sh"
echo "d) Executa esbrrgrp.sh"
echo -n "Escull una opció: "
read opc
case $opc in
	a) ./crtusr.sh;;
	b) ./esbrrusr.sh;;
	c) ./crtgrp.sh;;
	d) ./esbrrgrp.sh;;
	*) echo "Opció escollida incorrecta";;
esac
########################FINALITZANT###################################
exit 0
