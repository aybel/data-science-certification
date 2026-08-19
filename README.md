# Certificación Data Scientist - Tec de Monterrey

Repositorio personal para mi formación en la **Certificación en Ciencia de Datos** del Tecnológico de Monterrey.

Este espacio reúne ejercicios, proyectos, notebooks y materiales desarrollados durante las **210 horas** de formación, distribuidas en **5 microcertificados** y **17 módulos**.

## Objetivo

- Documentar el aprendizaje durante la certificación.
- Mantener un portafolio de proyectos y análisis.
- Organizar código reutilizable y material de referencia.

## Estructura del repositorio

```text
.
├── data/
│   ├── raw/
│   ├── interim/
│   └── processed/
├── notebooks/
│   ├── 01_estadistica/
│   ├── 02_python/
│   ├── 03_ingenieria_datos/
│   ├── 04_visualizacion/
│   ├── 05_estadistica_avanzada/
│   └── exploration/
├── src/
│   ├── data/
│   ├── features/
│   ├── models/
│   ├── visualization/
│   └── utils.py
├── projects/
│   └── pida/
│       ├── data/
│       ├── notebooks/
│       ├── src/
│       └── reports/
├── reports/
│   └── figures/
├── tests/
├── docs/
├── .env.example
├── .gitignore
├── requirements.txt
├── LICENSE
└── README.md
```

## Mapa de la certificación

| Microcertificado | Módulos | Temas principales |
| --- | --- | --- |
| Principios de la Ciencia de Datos | 1-2 | Estadística y Shell de Linux |
| Programación en Python para Ciencia de Datos | 3-4 | Python, NumPy y pandas |
| Ingeniería de Datos | 5-9 | Integración, SQL, MongoDB, extracción y Kedro |
| Visualización Efectiva de Datos con Python | 10-11 | Visualización estática y geoespacial |
| Desarrollo de Visualizaciones de Datos | 12-14 | UX/UI, Power BI o Tableau y Streamlit |
| Análisis Estadísticos de Datos | 15-17 | Análisis exploratorio, inferencial y predictivo |

### Proyecto integrador

| Etapa | Descripción | Dedicación |
| --- | --- | --- |
| PIDA | Proyecto Integrador de Dominio Autónomo | 40 horas |

## Cómo empezar

### 1. Clonar el repositorio

```bash
git clone https://github.com/TU-USUARIO/tec-data-scientist.git
cd tec-data-scientist
```

### 2. Crear y activar el entorno virtual

```bash
python -m venv .venv
source .venv/bin/activate  # Linux/macOS
# .venv\Scripts\activate  # Windows
```

### 3. Instalar dependencias

```bash
python -m pip install -r requirements.txt
```

### 4. Configurar variables de entorno

```bash
cp .env.example .env
# Edita .env con tus credenciales si es necesario
```

## Dependencias principales

Las dependencias se encuentran en [`requirements.txt`](requirements.txt).

| Librería | Uso |
| --- | --- |
| `numpy`, `pandas` | Cálculo y manipulación de datos |
| `matplotlib`, `seaborn`, `plotly` | Visualización |
| `scikit-learn`, `scipy`, `statsmodels` | Modelado y estadística |
| `sqlalchemy`, `pymongo` | Bases de datos SQL y MongoDB |
| `beautifulsoup4`, `requests` | Extracción de datos web |
| `kedro`, `streamlit` | Pipelines y dashboards |
| `geopandas` | Datos geoespaciales |
| `jupyter` | Notebooks interactivos |

## Convenciones del proyecto

### Notebooks

```text
01_estadistica/
├── 1.0-conceptos-basicos.ipynb
├── 1.1-medidas-resumen.ipynb
└── ...

02_python/
├── 3.0-fundamentos-python.ipynb
├── 4.0-numpy-pandas.ipynb
└── ...
```

### Código y commits

- Seguir PEP 8 y documentar las funciones con docstrings.
- Mantener los notebooks limpios y con una narrativa clara.
- Usar convenciones como `feat`, `fix`, `docs`, `refactor` y `data` en los commits.

## Progreso

| Microcertificado | Módulos | Estado |
| --- | --- | --- |
| Principios de la Ciencia de Datos | 1-2 | ⬜ Pendiente |
| Programación en Python | 3-4 | ⬜ Pendiente |
| Ingeniería de Datos | 5-9 | ⬜ Pendiente |
| Visualización Efectiva de Datos | 10-11 | ⬜ Pendiente |
| Desarrollo de Visualizaciones | 12-14 | ⬜ Pendiente |
| Análisis Estadísticos de Datos | 15-17 | ⬜ Pendiente |
| PIDA | - | ⬜ Pendiente |

Leyenda: ⬜ Pendiente | 🟡 En progreso | ✅ Completado

## Recursos útiles

- [Documentación de pandas](https://pandas.pydata.org/docs/)
- [Documentación de NumPy](https://numpy.org/doc/)
- [Documentación de scikit-learn](https://scikit-learn.org/stable/)
- [Guía de estilo PEP 8](https://peps.python.org/pep-0008/)
- [Markdown Guide](https://www.markdownguide.org/)
- [GitHub Docs](https://docs.github.com/)

## Licencia

Este repositorio es de uso personal y educativo. Todo el código y los materiales aquí contenidos forman parte de mi proceso de aprendizaje.

## Autor

Tu Nombre  
GitHub: [@tu-usuario](https://github.com/tu-usuario)  
LinkedIn: [tu-linkedin](https://linkedin.com/in/tu-linkedin)

_Última actualización: agosto de 2026._
