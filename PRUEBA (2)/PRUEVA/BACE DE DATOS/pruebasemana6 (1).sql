
create database pruevasemana6; -- crear BD
USE pruevasemana6; -- USAR BD
SHOW TABLES; -- VALIDAR CUANTAS TABLAS EXISTEN 
SHOW databases; 
drop database pruevasemana6; -- ELIMINAR BD SI ES NECESARIO 

-- CREACION DE LAS TABLAS CORREGIDAS
CREATE TABLE productos (
    id_productos INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    descripcion_producto TEXT,
    stock INT NOT NULL DEFAULT 0,
    venta INT NOT NULL DEFAULT 0,  -- contador de ventas
    precio DECIMAL(10,2) NOT NULL
);

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(150),
    correo VARCHAR(100)
);

CREATE TABLE realizarcompras (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_productos INT,
    id_cliente INT,  -- AGREGADO: para saber quién compró
    cantidad INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    precio DECIMAL(10,2),
    FOREIGN KEY (id_productos) REFERENCES productos(id_productos),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE factura ( 
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT,
    id_productos INT,
    cantidad INT NOT NULL,
    nombre_cliente VARCHAR(100) NOT NULL,  -- CORREGIDO: Nombre → nombre_cliente
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    precio DECIMAL(10,2),
    total DECIMAL(10,2),
    FOREIGN KEY (id_compra) REFERENCES realizarcompras(id_compra),
    FOREIGN KEY (id_productos) REFERENCES productos(id_productos)
);


INSERT INTO productos (id_productos, nombre_producto, descripcion_producto, stock, precio, venta) VALUES
(1, 'Auriculares Sony', 'Auriculares Bluetooth con cancelación de ruido', 25, 120.00, 0),
(2, 'Tablet Lenovo', 'Tablet 10 pulgadas 4GB RAM', 18, 210.00, 0),
(3, 'Impresora Epson', 'Impresora multifuncional WiFi', 12, 160.00, 0),
(4, 'Disco Duro Seagate 1TB', 'Disco duro externo USB 3.0', 40, 55.00, 0),
(5, 'Memoria USB Kingston 64GB', 'USB de alta velocidad 64GB', 80, 12.50, 0),
(6, 'Tarjeta Gráfica NVIDIA GTX', 'GPU para gaming 6GB', 8, 320.00, 0),
(7, 'Procesador Intel i5', 'CPU 10ª generación', 15, 200.00, 0),
(8, 'Placa Madre ASUS', 'Motherboard gaming ATX', 10, 150.00, 0),
(9, 'Fuente de Poder Corsair', '750W certificada 80 Plus', 20, 90.00, 0),
(10, 'Router TP-Link', 'Router WiFi doble banda', 35, 45.00, 0),
(11, 'Smartphone Samsung A54', 'Celular 128GB 6GB RAM', 22, 350.00, 0),
(12, 'Smartphone iPhone 13', '128GB pantalla OLED', 10, 700.00, 0),
(13, 'Cargador Rápido Xiaomi', 'Cargador USB tipo C 33W', 60, 15.00, 0),
(14, 'Cable HDMI 2.0', 'Cable HDMI 4K 2 metros', 100, 8.00, 0),
(15, 'Smart TV LG 50"', 'Televisor 4K UHD Smart TV', 7, 450.00, 0),
(16, 'Smartwatch Huawei', 'Reloj inteligente deportivo', 28, 110.00, 0),
(17, 'Ventilador CPU Cooler', 'Disipador para procesador', 30, 25.00, 0),
(18, 'SSD Kingston 480GB', 'Disco sólido alta velocidad', 25, 60.00, 0),
(19, 'Laptop Dell Inspiron', 'Laptop 16GB RAM Intel i7', 6, 900.00, 0),
(20, 'Webcam Logitech HD', 'Cámara para videollamadas', 45, 35.00, 0);

----------------------------------------------------------------------------------------
/*
INSERT INTO clientes (id_productos, nombre, telefono, direccion, correo) VALUES
(1, 'Juan Perez', '123456789', 'Calle 123', 'juan@email.com'),
(2, 'Maria Gomez', '987654321', 'Carrera 45', 'maria@email.com'),
(3, 'Carlos Lopez', '3001234567', 'Av 10 #20-30', 'carlos@email.com'),
(4, 'Ana Martinez', '3017654321', 'Calle 50 #15-20', 'ana@email.com'),
(5, 'Luis Rodriguez', '3024567890', 'Cra 8 #12-34', 'luis@email.com'),
(6, 'Sofia Ramirez', '3031122334', 'Av Siempre Viva 742', 'sofia@email.com'),
(7, 'Pedro Torres', '3049988776', 'Calle 80 #10-50', 'pedro@email.com'),
(8, 'Laura Hernandez', '3055566778', 'Cra 15 #45-60', 'laura@email.com'),
(9, 'Diego Castro', '3062233445', 'Av 30 #25-10', 'diego@email.com'),
(10, 'Valentina Ruiz', '3078899001', 'Calle 100 #20-15', 'valentina@email.com');  

-- ===========================================================================
-- IMPLEMENTACION DE TRANSACSIONES  
BEGIN;

-- 1. INSERTAR COMPRA CON FECHA
INSERT INTO compras (id_productos, nombre, cantidad, fecha, precio)
VALUES (1, 'Maria Gomez', 3, NOW(), 120.00);

-- 2. GUARDAR EL ID
SET @id_compra = LAST_INSERT_ID();

-- 3. ACTUALIZAR INVENTARIO
UPDATE productos
SET stock = stock - 3
WHERE id_productos = 4;

-- 4. ACTUALIZAR PRODUCTO
UPDATE productos
SET stock = stock - 3,
    venta = venta + 3
WHERE id_productos = 4;

-- 5. INSERTAR FACTURA
INSERT INTO factura (
    id_compra, id_productos, cantidad, Nombre, fecha, precio, total
)
VALUES (
    @id_compra,
    4,
    3,
    (SELECT nombre FROM clientes WHERE id_cliente = 2),
    NOW(),
    120.00,
    120.00 * 3
);
-- 6. CONFIRMAR
COMMIT;

ROLLBACK; -- PERO DESPUES DE HACER COMIMIT NO SE PUEDE RETROCEDER O VOLVER 

-- ========================================================================
BEGIN;

-- 1. INSERTAR COMPRA CON FECHA
INSERT INTO compras (id_productos, nombre, cantidad, fecha, precio)
VALUES (10, 'Valentina Ruiz', 5, NOW(), 45.00);

-- 2. GUARDAR EL ID
SET @id_compra = LAST_INSERT_ID();

-- 3. ACTUALIZAR INVENTARIO
UPDATE productos
SET stock = stock - 5
WHERE id_productos = 10;

-- 4. ACTUALIZAR PRODUCTO
UPDATE productos
SET stock = stock - 5,
    venta = venta + 1
WHERE id_productos = 10;

-- 5. INSERTAR FACTURA
INSERT INTO factura (
    id_compra, id_productos, cantidad, Nombre, fecha, precio, total
)
VALUES (
    @id_compra,
    4,
    3,
    (SELECT nombre FROM clientes WHERE id_cliente = 10),
    NOW(),
    45.00,
    45.00 * 5
);
-- 6. CONFIRMAR
COMMIT;
ROLLBACK; -- -- PERO DESPUES DE HACER COMIMIT NO SE PUEDE RETROCEDER O VOLVER

-- ================================================================================================

BEGIN;

-- 1. INSERTAR COMPRA CON FECHA
INSERT INTO compras (id_productos, nombre, cantidad, fecha, precio)
VALUES (7, 'Maria Gomez', 3, NOW(), 200.00);

-- 2. GUARDAR EL ID
SET @id_compra = LAST_INSERT_ID();

-- 3. ACTUALIZAR INVENTARIO
UPDATE productos
SET stock = stock - 3
WHERE id_productos = 4;

-- 4. ACTUALIZAR PRODUCTO
UPDATE productos
SET stock = stock - 3,
    venta = venta + 3
WHERE id_productos = 7;

-- 5. INSERTAR FACTURA
INSERT INTO factura (
    id_compra, id_productos, cantidad, Nombre, fecha, precio, total
)
VALUES (
    @id_compra,
    7,
    3,
    (SELECT nombre FROM clientes WHERE id_cliente = 2),
    NOW(),
    200.00,
    200.00 * 3
);
-- 6. CONFIRMAR
COMMIT;
-- Si te arrepientes:
ROLLBACK; -- PERO DESPUES DE HACER COMIMIT NO SE PUEDE RETROCEDER O VOLVER 

-- ================================================
-- OTO MODO DE MODIFICAR LAS TRANSACCIONES 
-- modificar manualmente las ventas
UPDATE productos
SET stock = stock - 0,
    venta = venta + 0
WHERE id_productos = 0;

-- ================================================
-- VERIFICACION DE LA BACE DE DATOS DESPUES DE LA EJECUCION DE JAVA 

-- Ver todas las bases de datos
	SHOW DATABASES; -- NO ES NECESARIO
-- Usar la correcta
	USE pruevasemana6;
-- Ver todas las tablas
	SHOW TABLES;
-- Ver datos insertados
	SELECT * FROM productos;
	SELECT * FROM compras;
	SELECT * FROM factura;
-- Ver el último ID insertado
SELECT LAST_INSERT_ID();
-- ============================================================
*/
/*sirve para verificar si queda algun producto 
select  id_productos, nombre_producto, descripcion_producto, stock, precio, venta from  productos where id_productos =7;  

-- CONSULTAS PARA VERIFICAR LOS RESULTADOS
-- Ver todas las compras con su estado
SELECT * FROM compras ORDER BY id_compra DESC;
-- Ver facturas
SELECT * FROM factura ORDER BY id_factura DESC;
-- Ver entregas
SELECT * FROM Entregas ORDER BY id_entrega DESC;

*/

