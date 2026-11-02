#!/bin/bash
#Este script de busqueda 

# Verificar que existe el directorio DATOS
if [ ! -d "DATOS" ]; then
    echo "Error: El directorio DATOS no existe"
    exit 1
fi

# Verificar que hay archivos CSV
if ! ls DATOS/*.csv &> /dev/null; then
    echo "Error: No hay archivos CSV en DATOS"
    exit 1
fi

# Genneracion de reporte
# Crear el archivo de reporte (sobrescribir si existe)
reporte="DATOS/reporte.txt"


echo " Reporte valores NA" > "$reporte"
echo "Fecha: $(date)" >> "$reporte"
echo "" >> "$reporte"

# Iterar sobre cada archivo CSV
for archivo in DATOS/*.csv; do
    # Obtener solo el nombre del archivo
    nombre=$(basename "$archivo")
    
    # Contar el total de NA en el archivo
    total_na=$(grep -o "NA" "$archivo" | wc -l)
    lineas=$(tail -n +2 "$archivo" | wc -l)
    total_valores=$((lineas * 3))
    
    # Escribir en el reporte
    echo "----------------------------------------" >> "$reporte"
    echo "Archivo: $nombre" >> "$reporte"
    echo "Total de valores (Sin encabezado): $total_valores" >> "$reporte"
    echo "Total de valores NA: $total_na" >> "$reporte"
    echo "" >> "$reporte"
    
    if [ "$total_na" -gt 0 ]; then
        echo "Líneas con NA:" >> "$reporte"
        # Imprimir el número de línea tantas veces como NA haya en esa línea 
        # la instruccion dice Para cada valor NA encontrado, el número de línea en la que aparece.
        grep -n "NA" "$archivo" | while IFS=: read -r num linea; do
            cantidad=$(echo "$linea" | grep -o "NA" | wc -l)
            for i in $(seq 1 $cantidad); do
                echo "$num" >> "$reporte"
            done
        done
        echo "" >> "$reporte"
    fi
done

echo "Reporte generado en: $reporte"