#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
#######DESCARREGA I CONVERSIÓ DEL FITXER AMB DADES D'USUARIS###########
echo "PROGRAMA PER ESBORRAR AUTOMÀTICAMENT ELS USUARIS CREATS AMB mltusr.sh"
echo
wget http://www.collados.org/asix2/m06/uf2/pr1/usuaris.ods
libreoffice --headless --convert-to csv usuaris.ods 
##############ESBORRANT ELS USUARIS#################################
for nom in $(cut -d ',' -f 2 usuaris.csv)
do
    userdel -r $nom    
done
#############ESBORRANT FITXERS QUE JA NO EM CALEN#######################
rm usuaris.csv usuaris.ods passwords.csv
########################FINALITZANT###################################
exit 0
