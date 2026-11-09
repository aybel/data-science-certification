#!/bin/bash

#Este escript generacion decsv recibe 3 parametros diferentes

########################################################################################Definimos los parametros de entrada
param1=$1 
param2=$2 
param3=$3
#########################################################################################Definición de  funciones
function validaEntradas(){
    #Valida que los paramtros existan
     if [ -z "$param1" ] || [ -z "$param2" ] || [ -z "$param3" ]; then
        echo "Error: Debes proporcionar 3 parámetros"
        echo "Uso: $0 param1 param2 param3"
        exit 1
    fi
     # Validar que sean distintos
    if [ "$param1" -eq "$param2" ] || [ "$param1" -eq "$param3" ] || [ "$param2" -eq "$param3" ]; then
        echo "Error: Los parámetros deben ser distintos entre sí."
        exit 1
    fi
    if [ $param1 -lt 10 -o  $param1 -gt 20 ]; then
        echo "Error: el valor parametro 1 = $param1 debe estar entre 10 y 20 inclusive"
        exit 1
    fi
    if [ $param2 -lt 10 -o  $param2 -gt 20 ]; then
        echo "Error: el valor parametro 2  = $param2 debe estar entre 10 y 20 inclusive"
        exit 1
    fi
    if [ $param3 -lt 10 -o  $param3 -gt 20 ]; then
        echo "Error: el valor parametro 3  = $param3 debe estar entre 10 y 20 inclusive"
        exit 1
    fi
   
    echo "Parámetros correctos."
}
function validarDirectorio(){
    local directorio="DATOS"

    if [ -d $directorio ]; then
        echo "Directorio datos ya existe"
    else 
        echo "Directorio datos no existe, se procede a crearlo"
        mkdir $directorio
        echo "Directorio datos creado exitosamente"
    fi
}
# ===================================================================
# Genera csv como parametrso recibe el númeor de csv a generar
# ==================================================================== 
function generarCSV(){

    local n=1
    
    for param in "$@"; do
        local num_lineas=$((param * 100))
        
        echo "Llamando al script lista_datos, llamada $n:"
        ./lista_datos.sh 51 99 $num_lineas > DATOS/base$n.csv
        echo "Archivo base$n.csv con $num_lineas registros generados"
        
        n=$((n + 1))
    done
}
######################################################################################Ejecución de funciones

#Validamos las entradas
echo "Validando parámetros de entrada..."
validaEntradas
echo "Validando si existe el directorio datos..."
validarDirectorio

echo "Generando archivos CSV..."
generarCSV "$@"


