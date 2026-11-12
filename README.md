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
├── init/                  # Scripts SQL de inicialización para MySQL
├── Dockerfile             # Imagen de MySQL
├── .dockerignore
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

### 5. Abrir Jupyter Notebook

Con el entorno virtual activado y desde la carpeta raíz del repositorio, ejecuta:

```bash
jupyter notebook
```

Jupyter abrirá una pestaña en el navegador. Si no se abre automáticamente, copia en el navegador la URL que aparece en la terminal. Desde ahí, entra a `notebooks/` y abre el archivo `.ipynb` que quieras usar. Para detener Jupyter, vuelve a la terminal y presiona `Ctrl+C`.

## Base de datos MySQL con Docker

El [`Dockerfile`](Dockerfile) de la raíz construye una imagen de MySQL 8.4 para el módulo de manipulación de bases de datos. Requiere tener [Docker](https://docs.docker.com/get-docker/) instalado.

### Arrancar MySQL

1. Crea el archivo `.env` y define tus contraseñas (si ya lo hiciste en el paso 4 de [Cómo empezar](#cómo-empezar), solo revísalo):

   ```bash
   cp .env.example .env
   ```

   | Variable | Descripción |
   | --- | --- |
   | `MYSQL_ROOT_PASSWORD` | Contraseña del usuario `root` |
   | `MYSQL_DATABASE` | Base de datos que se crea al iniciar |
   | `MYSQL_USER` | Usuario con acceso a esa base de datos |
   | `MYSQL_PASSWORD` | Contraseña de ese usuario |

   Escribe los valores sin comillas. Docker las toma como parte de la contraseña.

2. Construye la imagen (una sola vez, o cuando cambie el `Dockerfile`):

   ```bash
   docker build -t ds-mysql .
   ```

3. Inicia el contenedor:

   ```bash
   docker run -d --name ds-mysql \
     --env-file .env \
     -p 127.0.0.1:3306:3306 \
     -v ds_mysql_data:/var/lib/mysql \
     ds-mysql
   ```

   - `-p 127.0.0.1:3306:3306` publica el puerto solo en tu equipo. Otras máquinas de la red no pueden conectarse.
   - `-v ds_mysql_data:/var/lib/mysql` guarda los datos en un volumen. Sin él se pierden al borrar el contenedor.
   - Si el puerto 3306 ya está ocupado (por ejemplo, por un MySQL local), usa otro puerto del lado izquierdo, como `-p 127.0.0.1:3307:3306`, y ese mismo puerto en las conexiones de abajo.

4. Verifica que esté listo. El estado debe cambiar de `starting` a `healthy` (tarda unos 30 segundos la primera vez):

   ```bash
   docker ps --filter name=ds-mysql
   ```

### Comandos habituales

| Acción | Comando |
| --- | --- |
| Ver logs | `docker logs -f ds-mysql` |
| Abrir consola de MySQL | `docker exec -it ds-mysql mysql -u root -p` |
| Detener | `docker stop ds-mysql` |
| Volver a iniciar | `docker start ds-mysql` |
| Eliminar el contenedor (conserva los datos) | `docker rm -f ds-mysql` |
| Eliminar los datos | `docker volume rm ds_mysql_data` |

Las variables `MYSQL_DATABASE`, `MYSQL_USER` y `MYSQL_PASSWORD` solo se aplican la primera vez, cuando el volumen está vacío. Si las cambias después, elimina el volumen con `docker volume rm ds_mysql_data` (esto borra los datos) y vuelve a crear el contenedor.

Los scripts `.sql` que pongas en [`init/`](init/) se ejecutan en esa misma primera inicialización, en orden alfabético. Después de agregar uno, reconstruye la imagen con `docker build -t ds-mysql .`.

### Conectarse desde aplicaciones externas

Con el contenedor corriendo, cualquier cliente instalado en tu equipo se conecta por TCP con estos datos:

| Campo | Valor |
| --- | --- |
| Host | `127.0.0.1` |
| Puerto | `3306` (o el que hayas publicado) |
| Usuario | El valor de `MYSQL_USER` en tu `.env` (`root` para tareas administrativas) |
| Contraseña | La que definiste en tu `.env` |
| Base de datos | El valor de `MYSQL_DATABASE` en tu `.env` |

#### DBeaver

1. Ve a **Base de datos → Nueva conexión** y elige **MySQL**.
2. En la pestaña **Principal**, captura host, puerto, base de datos, usuario y contraseña de la tabla anterior.
3. Pulsa **Probar conexión**. Si DBeaver pide descargar el driver de MySQL, acepta.
4. Si aparece el error `Public Key Retrieval is not allowed`, abre la pestaña **Propiedades del driver** y establece `allowPublicKeyRetrieval` en `true`. Si también falla por SSL, establece `useSSL` en `false`.

#### HeidiSQL

1. En el **Administrador de sesiones**, pulsa **Nueva** y elige **MariaDB or MySQL (TCP/IP)** como tipo de red.
2. Captura **Nombre de host / IP** (`127.0.0.1`), **Usuario**, **Contraseña** y **Puerto**.
3. En la pestaña **Avanzado**, en **Base de datos**, escribe el valor de `MYSQL_DATABASE`, o déjalo vacío para ver todas.
4. Pulsa **Abrir**.

HeidiSQL solo tiene versión nativa para Windows. En Linux puedes usar DBeaver, o ejecutar HeidiSQL con Wine. Si Docker corre en otra máquina o dentro de WSL, usa la IP o el nombre de host de esa máquina en lugar de `127.0.0.1`.

#### Python (SQLAlchemy)

```python
import os
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

url = URL.create(
    "mysql+pymysql",
    username=os.environ["MYSQL_USER"],
    password=os.environ["MYSQL_PASSWORD"],
    host=os.getenv("MYSQL_HOST", "127.0.0.1"),
    port=int(os.getenv("MYSQL_PORT", "3306")),
    database=os.environ["MYSQL_DATABASE"],
)
engine = create_engine(url)
```

`URL.create` escapa caracteres especiales en la contraseña. Las variables se leen del entorno. En un notebook puedes cargarlas desde `.env` con `python-dotenv` (no está en `requirements.txt`) o exportarlas antes de abrir Jupyter.

## Dependencias principales

Las dependencias se encuentran en [`requirements.txt`](requirements.txt).

| Librería | Uso |
| --- | --- |
| `numpy`, `pandas` | Cálculo y manipulación de datos |
| `matplotlib`, `seaborn`, `plotly` | Visualización |
| `scikit-learn`, `scipy`, `statsmodels` | Modelado y estadística |
| `sqlalchemy`, `pymysql`, `cryptography` | Conexión a MySQL (`cryptography` es necesaria para la autenticación de MySQL 8) |
| `pymongo` | Base de datos MongoDB |
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
| Principios de la Ciencia de Datos | 1-2 | ✅ Completado |
| Programación en Python | 3-4 | ✅ Completado |
| Ingeniería de Datos | 5-9 | 🟡 En progreso |
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
LinkedIn: [tu-linkedin](https://www.linkedin.com/in/aybel)

_Última actualización: 09 agosto de 2026._
