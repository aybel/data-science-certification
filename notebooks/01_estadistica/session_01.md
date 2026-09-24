# Estadística para Ciencia de Datos - Módulo 1

Repositorio de apuntes, ejercicios y ejemplos prácticos del **Módulo 1: Estadística para la Ciencia de Datos** de la Certificación Data Scientist del Tec de Monterrey.

---

## Temario del Módulo

| # | Tema | Horas |
|---|------|-------|
| 1 | Conceptos Básicos | 2 |
| 2 | Medidas de Resumen | 2 |
| 3 | Teorema de Chebyshev | 2 |
| 4 | La Distribución Normal | 2 |
| 5 | Verificación de Normalidad | 2 |

---

## Objetivos de Aprendizaje

- Realizar análisis estadísticos formales para apoyar decisiones de alto impacto.
- Identificar y manejar datos atípicos, valores perdidos y anomalías.
- Interpretar datos con rigor estadístico.
- Seleccionar las medidas resumen adecuadas según la naturaleza de la variable.
- Verificar el supuesto de normalidad con pruebas de bondad y ajuste.

---

## Estructura del Repositorio

estadistica-ciencia-datos/
│
├── notebooks/
│   ├── 1.0-conceptos-basicos.ipynb
│   ├── 1.1-medidas-resumen.ipynb
│   ├── 1.2-teorema-chebyshev.ipynb
│   ├── 1.3-distribucion-normal.ipynb
│   ├── 1.4-verificacion-normalidad.ipynb
│   └── 1.5-pruebas-bondad-ajuste.ipynb
│
├── src/
│   ├── estadistica.py
│   └── visualizacion.py
│
├── data/
│   ├── raw/
│   └── processed/
│
├── reports/
│   └── figures/
│
├── requirements.txt
└── README.md

---

## Parte 1: Conceptos Básicos

### Tipos de Variables

| Tipo | Subtipo | Definición | Ejemplo |
|------|---------|-----------|---------|
| Cuantitativa | Discreta | Valores enteros contables | Número de hijos |
| Cuantitativa | Continua | Cualquier valor en un rango | Peso, estatura |
| Categórica | Nominal | Sin orden | Género, color |
| Categórica | Ordinal | Con orden | Nivel educativo |

### Escalas de Medición

- Nominal: Solo clasifica (género, estado civil)
- Ordinal: Clasifica y ordena (nivel socioeconómico)
- Intervalo: Ordena y suma, sin cero absoluto (temperatura en °C)
- Razón: Ordena, suma y tiene cero absoluto (edad, ingreso)

---

## Parte 2: Medidas de Resumen

### Medidas de Tendencia Central

| Medida | Fórmula | Cuándo usarla |
|--------|---------|---------------|
| Media | Σx / n | Datos simétricos sin outliers |
| Mediana | Valor central | Datos con outliers o asimetría |
| Moda | Valor más frecuente | Variables categóricas |

### Medidas de Dispersión

| Medida | Fórmula | Interpretación |
|--------|---------|----------------|
| Rango | Máx - Mín | Amplitud total |
| Varianza | Σ(x - x̄)² / (n-1) | Dispersión al cuadrado |
| Desviación Estándar | √Varianza | Dispersión en unidades originales |
| IQR | Q3 - Q1 | Rango del 50% central |
| Coef. Variación | (s / x̄) × 100 | Dispersión relativa (%) |

### Medidas de Forma

| Medida | Interpretación |
|--------|----------------|
| Asimetría (Skewness) | 0 = simétrica, >0 = cola derecha, <0 = cola izquierda |
| Curtosis | 0 = normal, >0 = puntiaguda, <0 = plana |

### Ejemplo en Python

```python
import pandas as pd
import numpy as np

datos = [5, 8, 12, 15, 18, 20, 22, 25, 30, 45, 60]
serie = pd.Series(datos)

print("=== MEDIDAS DE TENDENCIA CENTRAL ===")
print(f"Media: {serie.mean():.2f}")
print(f"Mediana: {serie.median():.2f}")
print(f"Moda: {serie.mode().values}")

print("\n=== MEDIDAS DE DISPERSIÓN ===")
print(f"Rango: {serie.max() - serie.min()}")
print(f"Varianza: {serie.var():.2f}")
print(f"Desviación Estándar: {serie.std():.2f}")
print(f"IQR: {serie.quantile(0.75) - serie.quantile(0.25):.2f}")
print(f"Coef. Variación: {(serie.std() / serie.mean()) * 100:.2f}%")

print("\n=== MEDIDAS DE FORMA ===")
print(f"Asimetría: {serie.skew():.2f}")
print(f"Curtosis: {serie.kurtosis():.2f}")