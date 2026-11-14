-- ==========================================================
-- SCRIPT DE DATOS MASIVOS (SEED)
-- PROYECTO: Certificación Data Scientist - Tec de Monterrey
-- BASE DE DATOS: agencia
-- DESCRIPCIÓN: Amplía los datos de 01_seed.sql con volumen:
--   - 2,000 ventas nuevas   (total: 2,012)
--   - 4,000 órdenes de servicio nuevas (total: 4,008) y sus detalles
--   - Más sucursales, empleados, clientes, autos y tipos de servicio
--
-- USO:
--   * Debe ejecutarse DESPUÉS de 01_seed.sql (que recrea las tablas).
--   * Docker lo ejecuta solo, en orden alfabético, al crear el volumen.
--   * Para repetirlo: ejecuta 01_seed.sql y luego este archivo.
--     Si lo ejecutas dos veces seguidas falla en el primer INSERT
--     (llave duplicada) y no agrega nada.
--
-- Los datos son pseudoaleatorios pero deterministas (CRC32 sobre
-- un texto fijo): cada ejecución genera exactamente los mismos datos.
-- Para cambiar el volumen, modifica los parámetros de abajo.
-- ==========================================================

USE agencia;
SET NAMES utf8mb4;
SET SESSION cte_max_recursion_depth = 1000000;

-- ----------------------------------------------------------
-- Parámetros
-- ----------------------------------------------------------
SET @n_ventas     = 2000;   -- ventas nuevas (1 auto vendido por venta)
SET @n_ordenes    = 4000;   -- órdenes de servicio nuevas
SET @n_inventario = 400;    -- autos en inventario (sin vender)
SET @fecha_inicio = '2022-01-01';
SET @fecha_corte  = '2024-06-30';   -- ningún dato posterior a esta fecha
SET @dias         = DATEDIFF(@fecha_corte, @fecha_inicio) + 1;

-- ----------------------------------------------------------
-- 1. SUCURSALES (ids explícitos: sirven también de guarda
--    contra una segunda ejecución)
-- ----------------------------------------------------------
INSERT INTO sucursales (id_sucursal, nombre, ciudad, direccion) VALUES
(4, 'Sucursal Angelópolis', 'Puebla',    'Blvd. Atlixcáyotl 1500'),
(5, 'Sucursal Bajío',       'Querétaro', 'Av. Constituyentes 820'),
(6, 'Sucursal Frontera',    'Tijuana',   'Blvd. Agua Caliente 3400');

-- ----------------------------------------------------------
-- 2. TABLAS AUXILIARES (se eliminan al final)
-- ----------------------------------------------------------
DROP TABLE IF EXISTS _plan_ordenes, _plan_ventas, _catalogo, _apellidos, _nombres, _seq;

CREATE TABLE _seq (n INT PRIMARY KEY);
INSERT INTO _seq (n)
WITH RECURSIVE s (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM s
    WHERE n < GREATEST(@n_ventas, @n_ordenes, @n_inventario, 100)
)
SELECT n FROM s;

CREATE TABLE _nombres (id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL);
INSERT INTO _nombres (nombre) VALUES
('Juan'), ('José'), ('Luis'), ('Carlos'), ('Miguel'), ('Jorge'), ('Fernando'), ('Ricardo'),
('Alejandro'), ('Daniel'), ('Eduardo'), ('Manuel'), ('Raúl'), ('Sergio'), ('Andrés'),
('María'), ('Ana'), ('Laura'), ('Sofía'), ('Patricia'), ('Gabriela'), ('Fernanda'),
('Daniela'), ('Lucía'), ('Valeria'), ('Mariana'), ('Paola'), ('Verónica'), ('Alicia'), ('Rosa');

CREATE TABLE _apellidos (id INT AUTO_INCREMENT PRIMARY KEY, apellido VARCHAR(50) NOT NULL);
INSERT INTO _apellidos (apellido) VALUES
('García'), ('Martínez'), ('López'), ('Hernández'), ('González'), ('Rodríguez'), ('Pérez'),
('Sánchez'), ('Ramírez'), ('Flores'), ('Gómez'), ('Morales'), ('Vázquez'), ('Jiménez'),
('Reyes'), ('Cruz'), ('Ortiz'), ('Gutiérrez'), ('Chávez'), ('Ramos'), ('Mendoza'),
('Aguilar'), ('Castillo'), ('Romero'), ('Herrera'), ('Medina'), ('Guerrero'), ('Ríos'),
('Salazar'), ('Navarro');

-- Catálogo de modelos con precio de lista (auto nuevo, MXN, referencia 2024).
-- Los primeros son los más vendidos (la selección favorece los ids bajos).
CREATE TABLE _catalogo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    submarca VARCHAR(50) NOT NULL,
    precio_base DECIMAL(12,2) NOT NULL
);
INSERT INTO _catalogo (marca, submarca, precio_base) VALUES
('Nissan', 'Versa', 325000), ('Chevrolet', 'Aveo', 260000), ('Nissan', 'Kicks', 350000),
('Toyota', 'Corolla', 420000), ('Volkswagen', 'Virtus', 340000), ('Kia', 'Rio', 310000),
('Mazda', 'Mazda 3', 380000), ('Honda', 'Civic', 450000), ('Hyundai', 'Elantra', 360000),
('Nissan', 'Sentra', 365000), ('Renault', 'Kwid', 210000), ('Volkswagen', 'Jetta', 380000),
('Toyota', 'RAV4', 640000), ('Mazda', 'CX-5', 560000), ('Honda', 'CR-V', 640000),
('Chevrolet', 'Onix', 280000), ('Ford', 'Ranger', 780000), ('Toyota', 'Hilux', 820000),
('Nissan', 'Frontier', 450000), ('Suzuki', 'Swift', 290000), ('Kia', 'Seltos', 430000),
('Hyundai', 'Tucson', 600000), ('Peugeot', '208', 310000), ('Renault', 'Duster', 380000),
('Volkswagen', 'Tiguan', 720000), ('Ford', 'Mustang', 850000), ('SEAT', 'Ibiza', 330000),
('Chevrolet', 'Tracker', 410000), ('Mazda', 'CX-30', 470000), ('Honda', 'HR-V', 480000);

-- ----------------------------------------------------------
-- 3. EMPLEADOS
--    Por sucursal: 2 vendedores, 1 asesor de servicio, 2 mecánicos
--    y 1 gerente (si la sucursal no tiene).
-- ----------------------------------------------------------
INSERT INTO empleados (nombre, apellido, puesto, id_sucursal)
SELECT nn.nombre, aa.apellido, p.puesto, s.id_sucursal
FROM sucursales s
JOIN (
    SELECT 'Vendedor' AS puesto, 2 AS cant
    UNION ALL SELECT 'Asesor de Servicio', 1
    UNION ALL SELECT 'Mecánico', 2
) p
JOIN _seq k ON k.n <= p.cant
JOIN _nombres nn ON nn.id = 1 + (CRC32(CONCAT('emp-nom-', s.id_sucursal, p.puesto, k.n)) MOD 30)
JOIN _apellidos aa ON aa.id = 1 + (CRC32(CONCAT('emp-ape-', s.id_sucursal, p.puesto, k.n)) MOD 30)
ORDER BY s.id_sucursal, p.puesto, k.n;

INSERT INTO empleados (nombre, apellido, puesto, id_sucursal)
SELECT nn.nombre, aa.apellido, 'Gerente', s.id_sucursal
FROM sucursales s
JOIN _nombres nn ON nn.id = 1 + (CRC32(CONCAT('emp-nom-g', s.id_sucursal)) MOD 30)
JOIN _apellidos aa ON aa.id = 1 + (CRC32(CONCAT('emp-ape-g', s.id_sucursal)) MOD 30)
WHERE NOT EXISTS (
    SELECT 1 FROM empleados e
    WHERE e.id_sucursal = s.id_sucursal AND e.puesto = 'Gerente'
);

-- ----------------------------------------------------------
-- 4. TIPOS DE SERVICIO (13 nuevos, 20 en total)
-- ----------------------------------------------------------
INSERT INTO tipos_servicio (nombre_servicio, precio_base) VALUES
('Afinación mayor', 2800.00),
('Cambio de bujías', 1200.00),
('Cambio de banda de distribución', 4200.00),
('Cambio de llantas (juego)', 9000.00),
('Cambio de amortiguadores', 5200.00),
('Servicio de aire acondicionado', 1800.00),
('Cambio de filtro de aire', 450.00),
('Limpieza de inyectores', 1300.00),
('Reparación de clutch', 7500.00),
('Revisión de dirección', 1600.00),
('Cambio de líquido de frenos', 900.00),
('Pulido y encerado', 1500.00),
('Verificación vehicular', 600.00);

-- ----------------------------------------------------------
-- 5. PLAN DE VENTAS
--    n = orden cronológico de la venta (1 = la más antigua).
--    es_nuevo = 1 si el comprador es un cliente nuevo (≈72 %);
--    si no, es un cliente recurrente que ya había comprado antes.
--    cli = número de cliente (1..N) dentro de los clientes generados.
--    suc = sucursal del cliente (CDMX 30 %, GDL 20 %, MTY 20 %,
--          Puebla/Querétaro/Tijuana 10 % cada una).
-- ----------------------------------------------------------
CREATE TABLE _plan_ventas (
    n INT PRIMARY KEY,
    fecha DATE NOT NULL,
    es_nuevo TINYINT NOT NULL,
    acum INT NOT NULL,
    cli INT NOT NULL DEFAULT 0,
    suc INT NOT NULL DEFAULT 0
);

INSERT INTO _plan_ventas (n, fecha, es_nuevo, acum)
SELECT x.n, x.fecha, x.es_nuevo, SUM(x.es_nuevo) OVER (ORDER BY x.n)
FROM (
    SELECT r.n,
           r.fecha,
           IF(r.n <= 20 OR (CRC32(CONCAT('vta-nuevo-', r.n)) MOD 100) < 72, 1, 0) AS es_nuevo
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY d.dia, d.k) AS n,
               DATE_ADD(@fecha_inicio, INTERVAL d.dia DAY) AS fecha
        FROM (
            SELECT n AS k, (CRC32(CONCAT('vta-dia-', n)) MOD @dias) AS dia
            FROM _seq
            WHERE n <= @n_ventas
        ) d
    ) r
) x;

UPDATE _plan_ventas
SET cli = IF(es_nuevo = 1, acum, 1 + (CRC32(CONCAT('vta-cli-', n)) MOD acum));

UPDATE _plan_ventas
SET suc = CAST(ELT(1 + (CRC32(CONCAT('cli-suc-', cli)) MOD 10), 1, 1, 1, 2, 2, 3, 3, 4, 5, 6) AS UNSIGNED);

-- ----------------------------------------------------------
-- 6. CLIENTES (uno por cada venta con es_nuevo = 1)
--    Se registran de 0 a 20 días antes de su primera compra.
-- ----------------------------------------------------------
SET @base_cli = (SELECT COALESCE(MAX(id_cliente), 0) FROM clientes);

INSERT INTO clientes (id_cliente, nombre, apellido, email, telefono, ciudad, fecha_registro)
SELECT @base_cli + p.cli,
       nn.nombre,
       aa.apellido,
       CONCAT('cliente', LPAD(@base_cli + p.cli, 5, '0'), '@example.com'),
       CONCAT(ELT(p.suc, '555', '333', '818', '222', '442', '664'), '-',
              LPAD(CRC32(CONCAT('cli-tel-', p.cli)) MOD 10000, 4, '0')),
       s.ciudad,
       DATE_SUB(p.fecha, INTERVAL (CRC32(CONCAT('cli-reg-', p.cli)) MOD 21) DAY)
FROM _plan_ventas p
JOIN _nombres nn ON nn.id = 1 + (CRC32(CONCAT('cli-nom-', p.cli)) MOD 30)
JOIN _apellidos aa ON aa.id = 1 + (CRC32(CONCAT('cli-ape-', p.cli)) MOD 30)
JOIN sucursales s ON s.id_sucursal = p.suc
WHERE p.es_nuevo = 1;

-- ----------------------------------------------------------
-- 7. AUTOS
--    a) Un auto vendido por cada venta (60 % nuevos, 40 % usados de 1 a 8 años).
--       Precio de lista: precio base del modelo, ajustado por año (4 % anual,
--       tomando 2024 como referencia) y por depreciación (8 % por año de uso).
--    b) Inventario sin vender (Nuevo / Usado).
-- ----------------------------------------------------------
SET @base_auto = (SELECT COALESCE(MAX(id_auto), 0) FROM autos);

INSERT INTO autos (id_auto, marca, submarca, modelo, kilometraje, precio_mxp, estado, id_sucursal)
SELECT @base_auto + t.n,
       c.marca,
       c.submarca,
       YEAR(t.fecha) + IF(t.edad = 0 AND MONTH(t.fecha) >= 10, 1, 0) - t.edad,
       IF(t.edad = 0, 0, t.edad * (8000 + (CRC32(CONCAT('auto-km-', t.n)) MOD 14000))),
       ROUND(c.precio_base * (1 - 0.04 * (2024 - YEAR(t.fecha))) * (1 - 0.08 * t.edad), -3),
       'Vendido',
       t.suc
FROM (
    SELECT p.n, p.fecha, p.suc,
           CAST(1 + FLOOR((SELECT COUNT(*) FROM _catalogo)
                          * POW((CRC32(CONCAT('auto-cat-', p.n)) MOD 10000) / 10000, 2)) AS UNSIGNED) AS cat,
           IF((CRC32(CONCAT('auto-tipo-', p.n)) MOD 100) < 60,
              0,
              1 + (CRC32(CONCAT('auto-edad-', p.n)) MOD 8)) AS edad
    FROM _plan_ventas p
) t
JOIN _catalogo c ON c.id = t.cat;

INSERT INTO autos (id_auto, marca, submarca, modelo, kilometraje, precio_mxp, estado, id_sucursal)
SELECT @base_auto + @n_ventas + t.n,
       c.marca,
       c.submarca,
       2024 - t.edad,
       IF(t.edad = 0, 0, t.edad * (8000 + (CRC32(CONCAT('inv-km-', t.n)) MOD 14000))),
       ROUND(c.precio_base * (1 - 0.08 * t.edad), -3),
       IF(t.edad = 0, 'Nuevo', 'Usado'),
       t.suc
FROM (
    SELECT n,
           CAST(1 + FLOOR((SELECT COUNT(*) FROM _catalogo)
                          * POW((CRC32(CONCAT('inv-cat-', n)) MOD 10000) / 10000, 2)) AS UNSIGNED) AS cat,
           IF((CRC32(CONCAT('inv-tipo-', n)) MOD 100) < 55,
              0,
              1 + (CRC32(CONCAT('inv-edad-', n)) MOD 6)) AS edad,
           CAST(ELT(1 + (CRC32(CONCAT('inv-suc-', n)) MOD 10), 1, 1, 1, 2, 2, 3, 3, 4, 5, 6) AS UNSIGNED) AS suc
    FROM _seq
    WHERE n <= @n_inventario
) t
JOIN _catalogo c ON c.id = t.cat;

-- ----------------------------------------------------------
-- 8. VENTAS
--    El vendedor pertenece a la sucursal del auto. El precio final
--    es entre 94 % y 100 % del precio de lista.
-- ----------------------------------------------------------
SET @base_vta = (SELECT COALESCE(MAX(id_venta), 0) FROM ventas);

INSERT INTO ventas (id_venta, id_auto, id_cliente, id_empleado, fecha_venta, precio_final_mxp)
SELECT @base_vta + p.n,
       a.id_auto,
       @base_cli + p.cli,
       v.id_empleado,
       p.fecha,
       ROUND(a.precio_mxp * (0.94 + (CRC32(CONCAT('vta-desc-', p.n)) MOD 7) / 100), -2)
FROM _plan_ventas p
JOIN autos a ON a.id_auto = @base_auto + p.n
JOIN (
    SELECT id_empleado, id_sucursal,
           ROW_NUMBER() OVER (PARTITION BY id_sucursal ORDER BY id_empleado) AS rn,
           COUNT(*) OVER (PARTITION BY id_sucursal) AS cnt
    FROM empleados
    WHERE puesto = 'Vendedor'
) v ON v.id_sucursal = a.id_sucursal
   AND v.rn = 1 + (CRC32(CONCAT('vta-emp-', p.n)) MOD v.cnt);

-- ----------------------------------------------------------
-- 9. ÓRDENES DE SERVICIO
--    tipo 0 (8 %):  revisión previa a la venta, sin cliente (el auto es de la agencia).
--    tipo 1 (85 %): servicio posterior a la venta, a nombre del comprador.
--    tipo 2 (7 %):  servicio a un auto del inventario, sin cliente.
--    Los autos vendidos hace más tiempo reciben más servicios.
-- ----------------------------------------------------------
CREATE TABLE _plan_ordenes (
    m INT PRIMARY KEY,
    id_auto INT NOT NULL,
    id_cliente INT NULL,
    ingreso DATE NOT NULL,
    lineas TINYINT NOT NULL
);

INSERT INTO _plan_ordenes (m, id_auto, id_cliente, ingreso, lineas)
SELECT t.m,
       IF(t.tipo = 2,
          @base_auto + @n_ventas + 1 + (CRC32(CONCAT('ord-inv-', t.m)) MOD @n_inventario),
          @base_auto + t.sn),
       IF(t.tipo = 1, @base_cli + p.cli, NULL),
       CASE t.tipo
           WHEN 0 THEN DATE_SUB(p.fecha, INTERVAL (1 + (CRC32(CONCAT('ord-pre-', t.m)) MOD 10)) DAY)
           WHEN 1 THEN DATE_ADD(p.fecha, INTERVAL IF(DATEDIFF(@fecha_corte, p.fecha) <= 0,
                                                      0,
                                                      1 + (CRC32(CONCAT('ord-post-', t.m))
                                                           MOD DATEDIFF(@fecha_corte, p.fecha))) DAY)
           ELSE DATE_SUB(@fecha_corte, INTERVAL (CRC32(CONCAT('ord-invf-', t.m)) MOD 182) DAY)
       END,
       CASE WHEN t.h_lin < 55 THEN 1 WHEN t.h_lin < 85 THEN 2 ELSE 3 END
FROM (
    SELECT n AS m,
           CASE WHEN (CRC32(CONCAT('ord-tipo-', n)) MOD 100) < 8 THEN 0
                WHEN (CRC32(CONCAT('ord-tipo-', n)) MOD 100) < 93 THEN 1
                ELSE 2 END AS tipo,
           CAST(1 + FLOOR(@n_ventas * POW((CRC32(CONCAT('ord-vta-', n)) MOD 10000) / 10000, 1.5)) AS UNSIGNED) AS sn,
           (CRC32(CONCAT('ord-lin-', n)) MOD 100) AS h_lin
    FROM _seq
    WHERE n <= @n_ordenes
) t
JOIN _plan_ventas p ON p.n = t.sn;

SET @base_ord = (SELECT COALESCE(MAX(id_orden), 0) FROM ordenes_servicio);

-- total_mxp se recalcula más abajo con la suma de los detalles
INSERT INTO ordenes_servicio (id_orden, id_auto, id_cliente, id_empleado, fecha_ingreso, fecha_entrega, total_mxp)
SELECT @base_ord + o.m,
       o.id_auto,
       o.id_cliente,
       e.id_empleado,
       o.ingreso,
       LEAST(DATE_ADD(o.ingreso, INTERVAL (CRC32(CONCAT('ord-ent-', o.m)) MOD 4) DAY), @fecha_corte),
       0.00
FROM _plan_ordenes o
JOIN autos a ON a.id_auto = o.id_auto
JOIN (
    SELECT id_empleado, id_sucursal,
           ROW_NUMBER() OVER (PARTITION BY id_sucursal ORDER BY id_empleado) AS rn,
           COUNT(*) OVER (PARTITION BY id_sucursal) AS cnt
    FROM empleados
    WHERE puesto IN ('Asesor de Servicio', 'Mecánico')
) e ON e.id_sucursal = a.id_sucursal
   AND e.rn = 1 + (CRC32(CONCAT('ord-emp-', o.m)) MOD e.cnt);

-- ----------------------------------------------------------
-- 10. DETALLE DE SERVICIOS (1 a 3 servicios distintos por orden)
--     Los primeros tipos de servicio son los más frecuentes.
--     El 10 % de las líneas lleva 10 % de descuento.
-- ----------------------------------------------------------
INSERT INTO detalle_servicio (id_orden, id_tipo_servicio, costo_aplicado)
SELECT @base_ord + o.m,
       ts.id_tipo_servicio,
       ROUND(ts.precio_base * IF((CRC32(CONCAT('det-desc-', o.m, '-', k.n)) MOD 10) = 0, 0.90, 1.00), 2)
FROM _plan_ordenes o
JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3) k ON k.n <= o.lineas
JOIN (
    SELECT id_tipo_servicio, precio_base,
           ROW_NUMBER() OVER (ORDER BY id_tipo_servicio) AS rn,
           COUNT(*) OVER () AS cnt
    FROM tipos_servicio
) ts ON ts.rn = 1 + ((FLOOR(ts.cnt * POW((CRC32(CONCAT('det-tipo-', o.m)) MOD 10000) / 10000, 2))
                      + (k.n - 1) * 7) MOD ts.cnt)
ORDER BY o.m, k.n;

-- El total de cada orden es la suma de sus detalles (igual que en 01_seed.sql)
UPDATE ordenes_servicio o
JOIN (
    SELECT id_orden, SUM(costo_aplicado) AS total
    FROM detalle_servicio
    GROUP BY id_orden
) d ON d.id_orden = o.id_orden
SET o.total_mxp = d.total
WHERE o.id_orden > @base_ord;

-- ----------------------------------------------------------
-- 11. LIMPIEZA Y RESUMEN
-- ----------------------------------------------------------
DROP TABLE IF EXISTS _plan_ordenes, _plan_ventas, _catalogo, _apellidos, _nombres, _seq;

SELECT 'sucursales' AS tabla, COUNT(*) AS filas FROM sucursales
UNION ALL SELECT 'empleados', COUNT(*) FROM empleados
UNION ALL SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL SELECT 'autos', COUNT(*) FROM autos
UNION ALL SELECT 'ventas', COUNT(*) FROM ventas
UNION ALL SELECT 'tipos_servicio', COUNT(*) FROM tipos_servicio
UNION ALL SELECT 'ordenes_servicio', COUNT(*) FROM ordenes_servicio
UNION ALL SELECT 'detalle_servicio', COUNT(*) FROM detalle_servicio;
