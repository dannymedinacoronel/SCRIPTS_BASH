#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
###########DECLARACIÓ DE CONSTANTS##############
declare -r UID_INIC=2001   	# Ho diu l'ennunciat
declare -r GROUP=users		# Ho diu l'ennunciat  
declare -r SHELL=/bin/bash	#Al meu criteri
#######DESCARREGA I CONVERSIÓ DEL FITXER AMB DADES D'USUARIS###########
wget http://www.collados.org/asix2/m06/uf2/pr1/usuaris.ods
#
# La següent ordre, converteix un fitxer .ods en un fitxer .csv
# El format csv és un format d'arxiu de texte pla com si fos un .txt de Windows
# Si sembla que la conversió no funciona, fes un ps aux i comprova que el procés libreoffice no s'estigui executant encara que no ho sembli
libreoffice --headless --convert-to csv usuaris.ods 
##############CREACIÓ D'USUARIS#################################
uid=$UID_INIC
for nom in $(cut -d ',' -f 2 usuaris.csv)
do
    dir=/home/$nom
    # Directori personal de l'usuari
    #
    ctrsnya=$(mkpasswd " ")
    # Utilitzo mkpasswd per generar una contrasenya aleatòria per l'usuari
    # Aquesta serà la contrasenya que donarem a l'usuari
    # Aquesta contrasenya s'haurà d'encriptar
    #
    useradd $nom -u $uid -g $GROUP -d $dir -m -s $SHELL -p $(mkpasswd $ctrsnya)
    # Torno ha executar mkpasswd per generar la versió encriptada del password real de l'usuari que s'ha generat abans.
    #
    echo $nom $ctrsnya >> passwords.csv    
    # No ho demana l'ennunciat però és important generar un fitxer amb les contrasenyes per cada usuari
    # Genero un fitxer de full de càlcul amb aquestes cotrasenyes.
    # El format csv es pot visualitzar amb geany o el full de càlcul
    #
    uid=$(( uid + 1 ))
    #Actualitzo el valor d'uid per generar el nou UID pel següent usuari
done
#############ESBORRANT FITXERS QUE JA NO EM CALEN#######################
rm usuaris.csv usuaris.ods
########################FINALITZANT###################################
exit 0
