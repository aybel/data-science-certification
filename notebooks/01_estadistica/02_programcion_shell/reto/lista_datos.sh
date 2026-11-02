#!/bin/bash

#Este escript genera una salida a pantalla con 3 columnas separadas por coma
#la primera linea son los titulos de las columnas Variable_1,Variable_2,Variable_3

########################################################################################Definimos los parametros de entrada
minimo=$1 #Valor entero limite inferior para los numeros aleatorios
maximo=$2 #Valor entero limite superio para los numeros aleatoris
numLineas=$3 #Valor entero, cantidad de filas de datos a generar
#########################################################################################Definición de  funciones
function validaEntradas(){
    if [ -z "$numLineas" ]; then
        echo "Error: la cantidad de lineas no puede ser vacio"
        exit 1
    fi
    if [ $minimo -ge $maximo ]; then
        echo "Error: el valor minimo debe ser menor que el valor maximo"
        exit 1
    fi
    if [ $numLineas -le 0 ]; then
        echo "Error: la cantidad de lineas debe ser mayor que cero"
        exit 1
    fi
}
#Esta funcion regresa una fila en este formato var1,var2,var3,
function generaFila(){
    local var1=NA
    local var2=NA
    local var3=NA

    local rango=$((maximo - minimo + 1))

    # Condiciones para crear la variable 1
    var1=$(verificaMultiplo $((RANDOM % rango + minimo)))
    var2=$(verificaMultiplo $((RANDOM % rango + minimo)))
    var3=$(verificaPar $(verificaMultiplo $((RANDOM % rango + minimo))))
    
    echo "$var1,$var2,$var3,"
}
#Funcion que verifica si un valor es multiplo de 10 
#recibe el valor y regresa  NA si es multiplo de 10 y el valor en Cualquier otro caso
function verificaMultiplo(){
    local valor=$1
    local resp="NA"
    
    if [ $((valor % 10)) -eq 0 ]; then
        echo "$resp" 
    else 
        echo "$valor"
    fi
}
#Funcion que verifica si un valor es par 
#recibe el valor y regresa el valor si es par y el NA en Cualquier otro caso
function verificaPar(){
    local valor=$1
    local resp="NA"

    if [ $((valor % 2)) -eq 0 ]; then
        echo "$valor"
    else 
        echo "$resp"
    fi
}
######################################################################################Ejecución de funciones

#Validamos las entradas
validaEntradas

#Definimos un contador en cero con este vamos aumentarlos hasta que sea igual a la cantidad de numLineas
contador=0

# Encabezado (ESTA LÍNEA FALTA)
echo "Variable_1,Variable_2,Variable_3,"

until [ $contador -eq $numLineas ]; do
    resp=$(generaFila)
    echo "$resp"
    contador=$((contador + 1))
done



