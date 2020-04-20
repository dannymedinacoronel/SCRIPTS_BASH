#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
#
###########RECOLLINT DADES DE CONFIGURACIÓ######################################
LLISTA_IF=$(ip link show | grep mtu | cut -d ":" -f 2 | tr -d ' ') # Això és un extra que no està a l'ennunciat
echo -n "Indica la interfície de treball("$LLISTA_IF"): " # Això és un extra que no està a l'ennunciat
read iface # Això és un extra que no està a l'ennunciat
echo -n "Indica el nom del domini: "
read DOM
DOM=\"$DOM\" 
# Les contrabarres són necessàries perquè les " no siguin caràcters especials
# Una altra opció seria '"$DOM"'
echo -n "Indica l'adreça IP del servidor DNS: "
read DNS
echo -n "Indica l'adreça IP del Router: "
read GW
echo -n "Indica el valor per defecte del temps de leasing: "
read TEMP_LEAS_DEF
echo -n "Indica el valor màxim del temps de leasing: "
read TEMP_LEAS_MAX
echo -n "Indica l'adreça IP de la subxarxa: "
read IPSUBX
echo -n "Indica la màscara de subxarxa: "
read MASC
echo -n "Indica la primera adreça IP del marge: "
read IP1
echo -n "Indica la darrera adreça IP del marge: "
read IP2
#########REALITZANT LA CONFIGURACIÓ I REINICIANT EL SERVIDOR##################
##----------Configuració del fitxer /etc/default/isc-dhcp-server----------##
#Nota: Això és un extra que no està a l'enunciat.
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.$(date +20%y%m%d%H%M)
echo  "INTERFACESv4=\"$iface\"" > /etc/default/isc-dhcp-server #Les \ davant de les " fan que les " no siguin caràcters especials
echo  "INTERFACESv6=\"\"" >> /etc/default/isc-dhcp-server #Les \ davant de les " fan que les " no siguin caràcters especials
##----------Configuració del fitxer /etc/dhcp/dhcpd.conf----------##
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.$(date +20%y%m%d%H%M)
echo "authoritative;" > /etc/dhcp/dhcpd.conf
echo "ddns-update-style none;" >> /etc/dhcp/dhcpd.conf
echo "option domain-name $DOM;" >> /etc/dhcp/dhcpd.conf
echo "option domain-name-servers $DNS;" >> /etc/dhcp/dhcpd.conf
echo "option routers $GW;" >> /etc/dhcp/dhcpd.conf
echo "default-lease-time $TEMP_LEAS_DEF;" >> /etc/dhcp/dhcpd.conf
echo "max-lease-time $TEMP_LEAS_MAX;" >> /etc/dhcp/dhcpd.conf
echo "subnet $IPSUBX netmask $MASC {" >> /etc/dhcp/dhcpd.conf
echo "  range $IP1 $IP2;" >> /etc/dhcp/dhcpd.conf
echo "}" >> /etc/dhcp/dhcpd.conf
systemctl restart isc-dhcp-server 2> /dev/null
systemctl status isc-dhcp-server | grep "Active" # Això és un extra
########################FINALITZANT###################################
exit 0
