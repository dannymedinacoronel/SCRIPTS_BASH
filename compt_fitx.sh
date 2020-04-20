#!/bin/bash
comptador()
{
	local compte
	local fitxer
	
	compte=0
	for fitxer in $1/*  # En $1 s'ha desat el nom del directori que s'ha passat com a paràmetre en el moment de cridar a la funció des del programa principal
	do
		if [[ -s $fitxer ]] &&  [[ -x $fitxer ]]  # -s és veritat si el fitxer és més gran de 0 bytes. -x veritat si el fitxer és executable per l'usuari propietari
		then                                      # Més informació aquí --> https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html
			(( compte++ ))	# Incrementa en el valor de compte		
		fi
	done
	echo "Número de fitxers: $compte"
}
#######PROGRAMA PRINCIPAL#############################################
clear
echo -n "Indica el camí complet del directori de treball: "
read dir
comptador $dir
#SORTINT AMB UN CODI DE RETORN IGUAL A 20
exit 20
