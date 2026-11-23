# Notas de manipulación de base de datos NO-SQL Mongo-db

Las bases de datos NoSQL no siguen un esquema predefinido y pueden estructurar la información de diversas maneras, motivo por el cual también se les conoce como bases de datos no estructuradas. 

Dentro de las bases de datos NoSQL existen diferentes subcategoria, como:

- Bases de tipo llave-valor: Almacenan información en pares clave-valor, similares a un diccionario.
  - Redis: Es uno de los mas popúlares, usado frecuentemente con caché y almacén de estructuras de datos en memoria
  - Amazon DynamoDB: Un servicio de base de datos completamente gestionado por AWS diseñado para alta escabilidad
  - Riak: Conicido por su alta disponibilidad y tolerancia a fallos en entornos distribuidos.  
- Bases de datos basadas en grafos: Representan datos meidnate nodos y relaciones, ideales para redes sociales o sistemas de recomendación
  - Neo4j:El lider del mercado para bases de datos de grafos, muy utulizado en deteccion de fraude y rdes sociales
  - Amazon Neptune: Servicio gestionado de AWS que soporta modelos de grafos de propiedad y RDF
  - FalkorDB: Una base deda tis de grafos construida sobre Redis, optimizada para consultas rápidas y eficientes en momeria.
- Bases de datos de documentos: Almacenan información en documentos, principalmente JSON o XML
  - MongoDB: El ejmplo mas claro de esta categoría; permite almacenar datos son un esquema fijo y es ampliamente usado en aplicaciones modernas
  - Couchbase: Combina al almacenamiento de documentos con capacidades de clave-valor y ofrece una alta escalabilidad.
  - Amazon DocumentDB: Un servicio de dase de datos de documentos compatible con MongoDB, gestionado por AWS.  
- Bases de datos de objetos: Manejan datos como objetos, mantenido relaciones entre ellos
  - db4o: Una base de datos de objetos de código abierto muy conocida por su facilidad de integracion con apliaciones Java y .NET
  - GemStone: Un sistema maduro y robusto pque ha sido utilizado en entornos empresariables de alta concurrencia.
  - InterSystems Cache: Aunque a veces se clasifica de forma híbrida, es un ejemplo de sistema que maneja datos como objetos y permite acceso relacional
- Bases de datos multimodelo: Combina múltiples enfoque en un mismos sitema.
  - ArangoDB: Soporta de forma nativa los modelos de documentos, grafos y clave-valor, utilizando su propio lenguaje de consulta unificado (AQL)
  - OrientDB: Es un sistema multimodelo que soporta grafos y documentos, y mantiene compatibilidad con SQL para facilitar la transación desde bases de datos relacionales.
  - Couchbase: Aunque se listó en documentos, también se considera multimodelos al integrar el acceso clave-valor con el almacenamiento de documentos.

# Fundamentos de MongoDB

Ejemplo de un documentos de Mongo: En este caso son los datos de un agencia de autos en México

```json
{
  "_id": ObjectId('6b03e2314a40a5a576c41178'),
  "nombre": "AutoMax Premium",
  "tipo_agencia": "Concesionario Oficial",
  "marcas_autorizadas": ["Toyota", "Honda", "Mazda", "Volkswagen"],
  "contacto": {
    "telefono": "+52 55 1234 5678",
    "whatsapp": "+52 55 8765 4321",
    "email": "ventas@automaxpremium.com",
    "sitio_web": "www.automaxpremium.com",
    "redes_sociales": {
      "facebook": "/AutoMaxPremiumOficial",
      "instagram": "@automax_premium"
    }
  },
  "ubicacion": {
    "direccion": "Av. Insurgentes Sur 1450, Col. Actipan",
    "ciudad": "Ciudad de México",
    "estado": "CDMX",
    "codigo_postal": "03230",
    "coordenadas": {
      "latitud": 19.3715,
      "longitud": -99.1789
    }
  },
  "horarios_atencion": {
    "lunes_a_viernes": "09:00 - 19:00",
    "sabado": "10:00 - 16:00",
    "domingo": "Cerrado"
  },
  "servicios_ofrecidos": [
    "Venta de autos nuevos",
    "Venta de autos seminuevos",
    "Financiamiento automotriz",
    "Seguro de auto",
    "Taller de servicio autorizado",
    "Trámites de emplacamiento"
  ],
  "inventario": [
    {
      "id_vehiculo": "VH-2023-001",
      "marca": "Toyota",
      "modelo": "Corolla",
      "año": 2024,
      "version": "LE CVT",
      "tipo": "Sedán",
      "precio_mxn": 415000.00,
      "estado": "Nuevo",
      "color": "Blanco Perlado",
      "transmision": "Automática",
      "combustible": "Gasolina",
      "disponible": true
    },
    {
      "id_vehiculo": "VH-2022-045",
      "marca": "Honda",
      "modelo": "CR-V",
      "año": 2022,
      "version": "Touring",
      "tipo": "SUV",
      "precio_mxn": 520000.00,
      "estado": "Seminuevo",
      "kilometraje": 25000,
      "color": "Gris Grafito",
      "transmision": "Automática",
      "combustible": "Gasolina",
      "disponible": true
    },
    {
      "id_vehiculo": "VH-2021-112",
      "marca": "Mazda",
      "modelo": "Mazda 3",
      "año": 2021,
      "version": "i Grand Touring",
      "tipo": "Hatchback",
      "precio_mxn": 320000.00,
      "estado": "Seminuevo",
      "kilometraje": 48000,
      "color": "Rojo Diamante",
      "transmision": "Automática",
      "combustible": "Gasolina",
      "disponible": false
    }
  ],
  "calificacion_clientes": 4.8,
  "fecha_apertura": "2015-03-15T00:00:00Z",
  "activa": true
}
```

# Búsquedas en MongoDB

Los ejemplos usan una colección llamada `agencias` con documentos como el de arriba. Se escriben para `mongosh`. Al final hay un ejemplo equivalente en Python con `pymongo`.

Para abrir `mongosh` en el contenedor del proyecto:

```bash
docker exec -it ds-mongo mongosh -u <MONGO_USER> -p --authenticationDatabase admin
```

## Estructura de una consulta

`find(filtro, proyeccion)` recibe dos documentos. El primero filtra qué documentos regresan y el segundo elige qué campos se muestran.

```javascript
use ciencia_datos

// Todos los documentos
db.agencias.find()

// Un solo documento (regresa el primero que coincida)
db.agencias.findOne({ nombre: "AutoMax Premium" })

// Igualdad simple
db.agencias.find({ activa: true })

// Varios campos en el filtro equivalen a un AND implícito
db.agencias.find({ activa: true, tipo_agencia: "Concesionario Oficial" })
```

### Proyección, orden y límite

```javascript
// 1 incluye el campo, 0 lo excluye. _id se incluye siempre salvo que se excluya
db.agencias.find({ activa: true }, { nombre: 1, "ubicacion.ciudad": 1, _id: 0 })

// Ordenar: 1 ascendente, -1 descendente
db.agencias.find().sort({ calificacion_clientes: -1 })

// Paginación
db.agencias.find().sort({ nombre: 1 }).skip(10).limit(5)

// Contar
db.agencias.countDocuments({ activa: true })
```

No se pueden mezclar inclusiones y exclusiones en la misma proyección. La única excepción es `_id: 0`.

## Acceso a campos anidados y arreglos

Para entrar a un subdocumento se usa la notación de punto y el nombre del campo entre comillas.

```javascript
db.agencias.find({ "ubicacion.estado": "CDMX" })
db.agencias.find({ "contacto.redes_sociales.instagram": "@automax_premium" })

// En un arreglo de valores simples, la igualdad busca si el valor está en el arreglo
db.agencias.find({ marcas_autorizadas: "Toyota" })

// En un arreglo de documentos, la notación de punto busca en cualquier elemento
db.agencias.find({ "inventario.marca": "Honda" })
```

## Operadores de comparación

Los operadores empiezan con `$` y se escriben dentro del campo que se compara: `{ campo: { $operador: valor } }`.

| Operador | Significado | Equivalente SQL |
| --- | --- | --- |
| `$eq` | Igual a | `=` |
| `$ne` | Distinto de | `<>` o `!=` |
| `$gt` | Mayor que | `>` |
| `$gte` | Mayor o igual que | `>=` |
| `$lt` | Menor que | `<` |
| `$lte` | Menor o igual que | `<=` |
| `$in` | Igual a cualquiera de los valores de una lista | `IN` |
| `$nin` | No es igual a ninguno de los valores de la lista | `NOT IN` |

```javascript
// Calificación de 4.5 o más
db.agencias.find({ calificacion_clientes: { $gte: 4.5 } })

// Rango: se combinan dos operadores sobre el mismo campo (BETWEEN)
db.agencias.find({ calificacion_clientes: { $gte: 4, $lt: 5 } })

// Distinto de
db.agencias.find({ tipo_agencia: { $ne: "Concesionario Oficial" } })

// Lista de valores
db.agencias.find({ "ubicacion.estado": { $in: ["CDMX", "Jalisco", "Nuevo León"] } })
db.agencias.find({ "ubicacion.estado": { $nin: ["CDMX"] } })

// Fechas: se comparan con objetos Date (en el ejemplo se guardó como texto ISO)
db.agencias.find({ fecha_apertura: { $lt: ISODate("2020-01-01T00:00:00Z") } })
```

`$ne` y `$nin` también regresan los documentos que no tienen el campo. Si no quieres eso, agrega `$exists: true`.

Comparar texto con `$gt` o `$lt` usa el orden alfabético. Las fechas guardadas como cadena ISO 8601 se ordenan bien, pero es mejor guardarlas como `Date`.

## Operadores lógicos

| Operador | Uso |
| --- | --- |
| `$and` | Todas las condiciones deben cumplirse |
| `$or` | Al menos una condición debe cumplirse |
| `$nor` | Ninguna condición debe cumplirse |
| `$not` | Niega el operador de un campo |

```javascript
// OR
db.agencias.find({
  $or: [
    { "ubicacion.estado": "CDMX" },
    { calificacion_clientes: { $gte: 4.8 } }
  ]
})

// AND explícito. Se usa cuando se repite el mismo campo o se combina con $or
db.agencias.find({
  $and: [
    { activa: true },
    { $or: [{ "ubicacion.estado": "CDMX" }, { "ubicacion.estado": "Jalisco" }] }
  ]
})

// NOT
db.agencias.find({ calificacion_clientes: { $not: { $gte: 4.5 } } })
```

## Operadores de elemento

```javascript
// El campo existe
db.agencias.find({ "contacto.whatsapp": { $exists: true } })

// El campo no existe
db.agencias.find({ "contacto.fax": { $exists: false } })

// Tipo de dato BSON
db.agencias.find({ calificacion_clientes: { $type: "double" } })

// Valor nulo
db.agencias.find({ "contacto.fax": null })
```

`{ campo: null }` coincide con valores nulos y con documentos que no tienen el campo.

## Operadores para arreglos

| Operador | Uso |
| --- | --- |
| `$all` | El arreglo contiene todos los valores indicados, sin importar el orden |
| `$size` | El arreglo tiene exactamente esa longitud |
| `$elemMatch` | Un mismo elemento cumple varias condiciones a la vez |

```javascript
// Vende Toyota y Honda
db.agencias.find({ marcas_autorizadas: { $all: ["Toyota", "Honda"] } })

// Exactamente 4 marcas
db.agencias.find({ marcas_autorizadas: { $size: 4 } })

// Un mismo vehículo debe ser Honda Y costar menos de 600,000
db.agencias.find({
  inventario: { $elemMatch: { marca: "Honda", precio_mxn: { $lt: 600000 } } }
})
```

Sin `$elemMatch`, la consulta `{ "inventario.marca": "Honda", "inventario.precio_mxn": { $lt: 600000 } }` puede cumplirse con elementos distintos: una marca en un vehículo y un precio en otro. Con `$elemMatch` ambas condiciones se aplican al mismo elemento.

Para ver solo el elemento que coincidió, se usa el operador de proyección `$`:

```javascript
db.agencias.find(
  { "inventario.marca": "Honda" },
  { nombre: 1, "inventario.$": 1 }
)
```

## Búsqueda de texto

### Expresiones regulares

`$regex` busca patrones dentro de una cadena. Es el equivalente de `LIKE` en SQL.

```javascript
// Empieza con "Auto" (equivale a LIKE 'Auto%')
db.agencias.find({ nombre: { $regex: "^Auto" } })

// Contiene "premium", sin distinguir mayúsculas (LIKE '%premium%')
db.agencias.find({ nombre: { $regex: "premium", $options: "i" } })

// Termina en "Oficial"
db.agencias.find({ tipo_agencia: { $regex: "Oficial$" } })

// Sintaxis corta con literal de expresión regular
db.agencias.find({ nombre: /premium/i })
```

| Opción | Efecto |
| --- | --- |
| `i` | No distingue mayúsculas de minúsculas |
| `m` | `^` y `$` coinciden en cada línea |
| `s` | El punto también coincide con saltos de línea |
| `x` | Ignora espacios en blanco del patrón |

Una expresión regular que empieza con `^` puede usar un índice sobre el campo. Las que empiezan con un comodín o usan `i` recorren la colección completa.

### Índice de texto y `$text`

Para buscar palabras en varios campos con relevancia, se crea un índice de texto. Cada colección admite solo uno.

```javascript
db.agencias.createIndex(
  { nombre: "text", servicios_ofrecidos: "text" },
  { default_language: "spanish" }
)

// Busca cualquiera de las palabras
db.agencias.find({ $text: { $search: "financiamiento seguro" } })

// Frase exacta
db.agencias.find({ $text: { $search: "\"taller de servicio\"" } })

// Excluir una palabra con el signo menos
db.agencias.find({ $text: { $search: "autos -seminuevos" } })

// Ordenar por relevancia
db.agencias.find(
  { $text: { $search: "financiamiento" } },
  { nombre: 1, puntaje: { $meta: "textScore" } }
).sort({ puntaje: { $meta: "textScore" } })
```

`$text` busca por palabra completa y aplica reglas del idioma, como quitar plurales. No sirve para buscar fragmentos dentro de una palabra. Para eso se usa `$regex`.

## Operadores de evaluación

```javascript
// $expr compara campos del mismo documento
db.agencias.find({ $expr: { $gt: ["$calificacion_clientes", 4.5] } })

// $mod: residuo de una división
db.agencias.find({ "inventario.año": { $mod: [2, 0] } })
```

## Orden de las condiciones y rendimiento

- Crea índices en los campos que más filtras: `db.agencias.createIndex({ "ubicacion.estado": 1 })`.
- Usa `explain("executionStats")` para saber si una consulta usó un índice o recorrió toda la colección.
- Proyecta solo los campos que necesitas.

```javascript
db.agencias.find({ "ubicacion.estado": "CDMX" }).explain("executionStats")
```

## Agregación básica

El pipeline de agregación procesa los documentos por etapas. `$match` filtra con los mismos operadores de `find`, y las demás etapas transforman el resultado.

```javascript
// Precio promedio de los vehículos disponibles por marca
db.agencias.aggregate([
  { $match: { activa: true } },
  { $unwind: "$inventario" },
  { $match: { "inventario.disponible": true } },
  { $group: { _id: "$inventario.marca", precio_promedio: { $avg: "$inventario.precio_mxn" }, total: { $sum: 1 } } },
  { $sort: { precio_promedio: -1 } }
])
```

| Etapa | Función |
| --- | --- |
| `$match` | Filtra documentos |
| `$unwind` | Convierte cada elemento de un arreglo en un documento |
| `$group` | Agrupa y calcula con `$sum`, `$avg`, `$min`, `$max` |
| `$project` | Elige o calcula campos |
| `$sort`, `$limit` | Ordenan y limitan el resultado |

## Equivalencia SQL y MongoDB

| SQL | MongoDB |
| --- | --- |
| `SELECT * FROM agencias` | `db.agencias.find()` |
| `WHERE activa = 1` | `find({ activa: true })` |
| `WHERE calificacion >= 4.5` | `find({ calificacion_clientes: { $gte: 4.5 } })` |
| `WHERE estado IN ('CDMX', 'Jalisco')` | `find({ "ubicacion.estado": { $in: [...] } })` |
| `WHERE a AND b` | `find({ a: ..., b: ... })` |
| `WHERE a OR b` | `find({ $or: [{ a: ... }, { b: ... }] })` |
| `WHERE nombre LIKE '%premium%'` | `find({ nombre: /premium/i })` |
| `ORDER BY x DESC LIMIT 5` | `find().sort({ x: -1 }).limit(5)` |
| `COUNT(*)` | `countDocuments()` |
| `GROUP BY` | `aggregate([{ $group: ... }])` |

## Las mismas consultas desde Python

`pymongo` usa diccionarios con la misma estructura que `mongosh`. Las diferencias son que `true`, `false` y `null` se escriben `True`, `False` y `None`, y que los métodos usan guion bajo (`sort`, `limit`).

```python
import os
import re
from dotenv import load_dotenv, find_dotenv
from pymongo import MongoClient, DESCENDING

load_dotenv(find_dotenv(), override=True)

client = MongoClient(
    host=os.getenv("MONGO_HOST", "127.0.0.1"),
    port=int(os.getenv("MONGO_PORT", "27017")),
    username=os.environ["MONGO_USER"],
    password=os.environ["MONGO_PASSWORD"],
    authSource="admin",
)
agencias = client["ciencia_datos"]["agencias"]

# Comparación
for doc in agencias.find({"calificacion_clientes": {"$gte": 4.5}}, {"nombre": 1, "_id": 0}):
    print(doc)

# Lógico y lista de valores
filtro = {
    "$or": [
        {"ubicacion.estado": {"$in": ["CDMX", "Jalisco"]}},
        {"calificacion_clientes": {"$gte": 4.8}},
    ]
}
resultado = agencias.find(filtro).sort("calificacion_clientes", DESCENDING).limit(5)

# Expresión regular sin distinguir mayúsculas
agencias.find({"nombre": {"$regex": "premium", "$options": "i"}})
agencias.find({"nombre": re.compile("premium", re.IGNORECASE)})

# Un mismo elemento del arreglo cumple varias condiciones
agencias.find({"inventario": {"$elemMatch": {"marca": "Honda", "precio_mxn": {"$lt": 600000}}}})

# Conteo y agregación
agencias.count_documents({"activa": True})
agencias.aggregate([
    {"$unwind": "$inventario"},
    {"$group": {"_id": "$inventario.marca", "promedio": {"$avg": "$inventario.precio_mxn"}}},
])
```
