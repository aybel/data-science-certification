#!/bin/bash

# Script para limpiar y respaldar los archivos csv

# 1. Validar que el reporte.txt exista
reporte="DATOS/reporte.txt"
directorio_limpio="DATOS_LIMPIOS"
function validarDirectorioReporte(){
    if [ -f "$reporte" ]; then
        echo "El archivo reporte.txt si existe, continua el proceso"
    else
        echo "El archivo reporte.txt no existe"
        exit 1
    fi
}
#limpa todos los csv de la carpeta DATOS_LIMPIOS reemplazando NA POR 0
function limpiar(){

    for archivo in DATOS_LIMPIOS/*.csv; do
        sed -i 's/NA/0/g' "$archivo"
        echo "Limpiado: $archivo"
    done
}

# 1.-Ejecutamos las funciones
validarDirectorioReporte
#2.- Creamos el directorio DATOS_LIMPIOS primero borramos si existe junto con lo que tenga dentro 
# Luego creamos 
rm -rf DATOS_LIMPIOS && mkdir DATOS_LIMPIOS

#3.- Generamos copias de los archivos de DATOS a la nueva carpeta 
echo "Copiando archivos desde DATOS a DATOS_LIMPIOS..."
cp DATOS/*.csv DATOS_LIMPIOS/
echo "Archivos copíados exitosamente."

#4 Reemplazamos NA por 0 en cada csv
echo "Inicia proceso de limpia de archivos..."
limpiar
echo "Termina proceso de limpia de archivos..."