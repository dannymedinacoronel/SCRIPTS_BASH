#!/bin/bash
#
# Controlador Bluetooth linux
# @author Danny Medina Coronel, dannymedinacoronel@gmail.com
# @version 2.0
# date 08_10_2020
# formato del documento UTF-8
#
# CHANGELOG
# 09.10.2020
 #- Controlador Bluetooth linux
#
# NOTAS
# ORIGEN

clear
echo "----------MENU DE OPCIONES----------"
echo ""
PS3='Ingrese su opcion a ejecutar : '
options=("Ver estado del Bluetooth" "Activar Bluetoth" "Desactivar Bluetoth" "Salir")
select opt in "${options[@]}"
do
    case $opt in
        "Ver estado del Bluetooth")
            echo "Ver estado del Bluetooth"
            /etc/init.d/bluetooth status
            ;;
        "Activar Bluetoth")
            echo "Activar Bluetoth"
             /etc/init.d/bluetooth start
            ;;
        "Desactivar Bluetoth")
            /etc/init.d/bluetooth stop
            ;;
        "Salir")
            break
            ;;
        *) echo invalid option;;
    esac
done
exit 1