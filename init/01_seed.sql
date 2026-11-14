-- ==========================================================
-- SCRIPT DE INICIALIZACIÓN (SEED)
-- PROYECTO: Certificación Data Scientist - Tec de Monterrey
-- BASE DE DATOS: agencia
-- DESCRIPCIÓN: Creación de esquema y datos de prueba (6 meses)
-- ==========================================================

-- Codificación del cliente: sin esto, Docker lee este archivo como latin1
-- y los acentos se guardan mal (por ejemplo, "Jesús" queda como "JesÃºs").
SET NAMES utf8mb4;

-- Crear la base de datos (por si se ejecuta manualmente, Docker lo ignora si ya la creó)
CREATE DATABASE IF NOT EXISTS agencia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE agencia;

-- Desactivar revisión de llaves foráneas para permitir DROP y creación en cualquier orden
SET FOREIGN_KEY_CHECKS = 0;

-- Eliminar tablas si ya existen (útil para reiniciar el entorno)
DROP TABLE IF EXISTS detalle_servicio;
DROP TABLE IF EXISTS ordenes_servicio;
DROP TABLE IF EXISTS tipos_servicio;
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS autos;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS sucursales;

-- Reactivar revisión de llaves foráneas
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================================
-- 1. CREACIÓN DE TABLAS
-- ==========================================================

-- Tabla: sucursales
CREATE TABLE sucursales (
    id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    direccion VARCHAR(150) NOT NULL
);

-- Tabla: clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(15),
    ciudad VARCHAR(50),
    fecha_registro DATE DEFAULT '2023-01-01'
);

-- Tabla: empleados
CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    puesto VARCHAR(50) NOT NULL,
    id_sucursal INT,
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

-- Tabla: autos
CREATE TABLE autos (
    id_auto INT AUTO_INCREMENT PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    submarca VARCHAR(50) NOT NULL,
    modelo INT NOT NULL, 
    kilometraje INT NOT NULL,
    precio_mxp DECIMAL(12,2) NOT NULL,
    estado ENUM('Nuevo', 'Usado', 'Vendido') DEFAULT 'Nuevo',
    id_sucursal INT,
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

-- Tabla: ventas
CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_auto INT UNIQUE, 
    id_cliente INT,
    id_empleado INT,
    fecha_venta DATE NOT NULL,
    precio_final_mxp DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (id_auto) REFERENCES autos(id_auto),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- Tabla: tipos_servicio
CREATE TABLE tipos_servicio (
    id_tipo_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL
);

-- Tabla: ordenes_servicio
CREATE TABLE ordenes_servicio (
    id_orden INT AUTO_INCREMENT PRIMARY KEY,
    id_auto INT,
    id_cliente INT, 
    id_empleado INT, 
    fecha_ingreso DATE NOT NULL,
    fecha_entrega DATE,
    total_mxp DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_auto) REFERENCES autos(id_auto),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- Tabla: detalle_servicio
CREATE TABLE detalle_servicio (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_orden INT,
    id_tipo_servicio INT,
    costo_aplicado DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_orden) REFERENCES ordenes_servicio(id_orden),
    FOREIGN KEY (id_tipo_servicio) REFERENCES tipos_servicio(id_tipo_servicio)
);

-- ==========================================================
-- 2. INSERCIÓN DE DATOS (INSERTS)
-- ==========================================================

-- Sucursales
INSERT INTO sucursales (nombre, ciudad, direccion) VALUES
('Sucursal Centro', 'Ciudad de México', 'Av. Juárez 123'),
('Sucursal Sur', 'Guadalajara', 'Av. López Mateos 456'),
('Sucursal Norte', 'Monterrey', 'Calle Hidalgo 789');

-- Clientes
INSERT INTO clientes (nombre, apellido, email, telefono, ciudad, fecha_registro) VALUES
('Jesús', 'Pérez', 'jesus.perez@email.com', '555-1234', 'Ciudad de México', '2023-11-01'),
('Ana', 'García', 'ana.garcia@email.com', '333-5678', 'Guadalajara', '2023-11-15'),
('Pedro', 'López', 'pedro.lopez@email.com', '818-8765', 'Monterrey', '2023-12-05'),
('María', 'Martínez', 'maria.mtz@email.com', '555-4321', 'Ciudad de México', '2024-01-10'),
('Luis', 'Hernández', 'luis.hdz@email.com', '333-1122', 'Guadalajara', '2024-01-20'),
('Laura', 'Gómez', 'laura.gomez@email.com', '555-9876', 'Ciudad de México', '2024-02-15'),
('Roberto', 'Díaz', 'roberto.diaz@email.com', '818-5432', 'Monterrey', '2024-02-20'),
('Carmen', 'Ruiz', 'carmen.ruiz@email.com', '333-8765', 'Guadalajara', '2024-03-05'),
('Javier', 'Mendoza', 'javier.mtz@email.com', '555-3344', 'Ciudad de México', '2024-03-15'),
('Elena', 'Torres', 'elena.torres@email.com', '818-2233', 'Monterrey', '2024-04-01'),
('Diego', 'Silva', 'diego.silva@email.com', '333-9988', 'Guadalajara', '2024-04-10'),
('Patricia', 'Rojas', 'patricia.rojas@email.com', '555-7766', 'Ciudad de México', '2024-05-05');

-- Empleados
INSERT INTO empleados (nombre, apellido, puesto, id_sucursal) VALUES
('Carlos', 'Sánchez', 'Vendedor', 1),
('Sofía', 'Ramírez', 'Gerente', 2),
('Jorge', 'Torres', 'Vendedor', 3),
('Mónica', 'Vargas', 'Asesor de Servicio', 1),
('Ricardo', 'Castro', 'Mecánico', 1);

-- Tipos de Servicio
INSERT INTO tipos_servicio (nombre_servicio, precio_base) VALUES
('Cambio de aceite y filtro', 1500.00),
('Revisión y ajuste de frenos', 2500.00),
('Alineación y balanceo', 800.00),
('Cambio de batería', 3500.00),
('Servicio de suspensión', 4500.00),
('Lavado y detallado', 500.00),
('Diagnóstico computarizado', 1000.00);

-- Autos
INSERT INTO autos (marca, submarca, modelo, kilometraje, precio_mxp, estado, id_sucursal) VALUES
('Nissan', 'Versa', 2024, 0, 325000.00, 'Vendido', 1),
('Toyota', 'Corolla', 2022, 45000, 290000.00, 'Vendido', 1),
('Honda', 'Civic', 2021, 62000, 340000.00, 'Vendido', 2),
('Mazda', 'Mazda 3', 2023, 0, 380000.00, 'Vendido', 2),
('Volkswagen', 'Jetta', 2020, 80000, 250000.00, 'Vendido', 3),
('Ford', 'Mustang', 2022, 15000, 850000.00, 'Vendido', 1),
('Chevrolet', 'Aveo', 2024, 0, 260000.00, 'Vendido', 3),
('Kia', 'Rio', 2019, 95000, 190000.00, 'Vendido', 2),
('Nissan', 'Sentra', 2021, 35000, 320000.00, 'Vendido', 1),
('Hyundai', 'Elantra', 2024, 0, 360000.00, 'Vendido', 3),
('Toyota', 'RAV4', 2022, 30000, 480000.00, 'Vendido', 2),
('Mazda', 'CX-5', 2021, 40000, 450000.00, 'Vendido', 1),
('Peugeot', '208', 2024, 0, 310000.00, 'Nuevo', 1),
('Renault', 'Kwid', 2023, 0, 210000.00, 'Nuevo', 3),
('Nissan', 'Kicks', 2023, 12000, 350000.00, 'Usado', 2),
('Honda', 'CR-V', 2022, 25000, 520000.00, 'Usado', 1),
('Volkswagen', 'Virtus', 2024, 0, 340000.00, 'Nuevo', 2);

-- Ventas (Enero a Junio 2024)
INSERT INTO ventas (id_auto, id_cliente, id_empleado, fecha_venta, precio_final_mxp) VALUES
(1, 1, 1, '2024-01-15', 320000.00),
(2, 4, 1, '2024-01-22', 285000.00),
(3, 2, 2, '2024-02-05', 335000.00),
(4, 6, 2, '2024-02-18', 375000.00),
(5, 3, 3, '2024-03-02', 245000.00),
(6, 7, 1, '2024-03-15', 840000.00),
(7, 5, 3, '2024-04-10', 255000.00),
(8, 8, 2, '2024-04-25', 185000.00),
(9, 9, 1, '2024-05-12', 315000.00),
(10, 10, 3, '2024-05-28', 355000.00),
(11, 11, 2, '2024-06-05', 475000.00),
(12, 12, 1, '2024-06-20', 445000.00);

-- Órdenes de Servicio
INSERT INTO ordenes_servicio (id_auto, id_cliente, id_empleado, fecha_ingreso, fecha_entrega, total_mxp) VALUES
(1, NULL, 5, '2024-01-12', '2024-01-14', 2000.00), 
(1, 1, 4, '2024-03-10', '2024-03-10', 1500.00), 
(2, 4, 5, '2024-04-05', '2024-04-06', 3300.00),
(5, NULL, 5, '2024-02-28', '2024-03-01', 7000.00),
(3, 2, 4, '2024-05-15', '2024-05-15', 800.00),
(6, 7, 5, '2024-05-20', '2024-05-22', 4500.00),
(13, NULL, 5, '2024-06-01', '2024-06-02', 500.00),
(5, 3, 4, '2024-06-10', '2024-06-11', 3500.00);

-- Detalle de los Servicios
INSERT INTO detalle_servicio (id_orden, id_tipo_servicio, costo_aplicado) VALUES
(1, 6, 500.00), 
(1, 1, 1500.00),
(2, 1, 1500.00),
(3, 2, 2500.00),
(3, 3, 800.00),
(4, 2, 2500.00),
(4, 5, 4500.00),
(5, 3, 800.00),
(6, 5, 4500.00),
(7, 6, 500.00),
(8, 4, 3500.00);