-- ============================
-- CREATE DATABASE
-- ============================

-- Paso previo: crear la base de datos (ejecutar por separado, conectada a otra base como "postgres").
-- CREATE DATABASE Ventas_Tech_DB;
-- Luego abrir un Query Tool conectado a Ventas_Tech_DB y ejecutar el resto del script.

-- ============================
-- SECCIÓN 1: DDL (DROP + CREATE TABLE)
-- ============================

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

-- ============================
-- SECCIÓN 2: RESTRICCIONES DE INTEGRIDAD
-- (ya incluidas dentro del DDL: PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE)
-- ============================

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50)NOT NULL,
    descripcion VARCHAR(200)
);

CREATE TABLE clientes (
id_cliente	INT	PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
email	VARCHAR(100) UNIQUE,
ciudad	VARCHAR(50)	,
fecha_registro	DATE NOT NULL
);

CREATE TABLE productos(
id_producto    INT    PRIMARY KEY,
nombre_producto    VARCHAR(100)    NOT NULL,
id_categoria    INT,   
FOREIGN KEY (id_categoria) 
REFERENCES categorias (id_categoria),
precio    DECIMAL(10,2)    NOT NULL,
stock    INT    DEFAULT 0,
activo BOOLEAN DEFAULT true
);

CREATE TABLE ventas(
id_venta	INT	PRIMARY KEY,
id_cliente	INT,
FOREIGN KEY (id_cliente)
REFERENCES clientes (id_cliente),
id_producto	INT,
FOREIGN KEY (id_producto)
REFERENCES productos (id_producto),
cantidad	INT	NOT NULL,
precio_unitario	DECIMAL(10,2)	NOT NULL,
fecha_venta	DATE	NOT NULL
);

-- ============================
-- SECCIÓN 3: DML (INSERT)
-- ============================

INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

INSERT INTO clientes VALUES (1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05');
INSERT INTO clientes VALUES (2, 'Carlos Ruiz',   'carlos@mail.com',  'Córdoba',      '2024-01-10');
INSERT INTO clientes VALUES (3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01');
INSERT INTO clientes VALUES (4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15');
INSERT INTO clientes VALUES (5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01');

INSERT INTO productos VALUES (1, 'Laptop Pro 15',       1, 1200.00, 15, true);
INSERT INTO productos VALUES (2, 'Mouse Inalámbrico',   2,   28.00, 80, true);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"',      1,  450.00, 12, true);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro',  3,  120.00, 35, true);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB',     4,  130.00, 18, true);
INSERT INTO productos VALUES (6, 'Teclado Mecánico',    2,   95.00, 40, true);

INSERT INTO ventas VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO ventas VALUES (2,  2, 2, 5,   28.00, '2024-03-06');
INSERT INTO ventas VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO ventas VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO ventas VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO ventas VALUES (6,  2, 6, 4,   95.00, '2024-03-11');
INSERT INTO ventas VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas VALUES (8,  3, 2, 8,   28.00, '2024-03-13');
INSERT INTO ventas VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2,  450.00, '2024-03-15');

SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;

-- ============================
-- M5: CONSULTAS CON JOINS
-- Base de datos: Ventas_Tech_DB
-- ============================

-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Sirve para unir ventas con clientes, productos y categorías en una sola tabla, como fuente de datos principal para Power BI.

SELECT 
    v.fecha_venta,
    c.nombre AS cliente,
    c.ciudad,
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;

-- Hallazgo: Computación concentra el 76,8% de la facturación ($4.950 de $6.444) con solo 4 de las 10 ventas.
-- Accesorios tiene 3 ventas pero aporta apenas $744, por el bajo precio de sus productos.

-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Es para detectar clientes registrados que nunca compraron, para que CRM los contacte.

SELECT c.nombre, c.email, c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: 0 de los 5 clientes registrados están sin ventas, ya que todos compraron al menos una vez,
-- por lo que CRM no tiene clientes inactivos para reactivar con estos datos.

-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Para detectar productos del catálogo sin ninguna venta registrada, para que el área de producto evalúe su rotación.

SELECT p.nombre_producto, cat.nombre_categoria, p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: 0 de los 6 productos del catálogo están sin ventas. Todos se vendieron al menos una vez,
-- por lo que el área de producto no detecta artículos sin rotación con estos datos.

-- Consulta 4: Consolidado por canal (UNION ALL)
-- Sirve para comparar la facturación de dos tramos del período, creando una columna "canal" con un texto fijo en cada SELECT.

SELECT canal, SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Hasta 10/03' AS canal
    FROM ventas
    WHERE fecha_venta <= '2024-03-10'
    UNION ALL
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Desde 11/03' AS canal
    FROM ventas
    WHERE fecha_venta > '2024-03-10'
) AS consolidado
GROUP BY canal;

-- Hallazgo: el tramo hasta el 10/03 facturó $3.620 (56,2% del total) y el tramo desde el 11/03, $2.824 (43,8%), con 5 ventas en cada uno.
-- La segunda mitad del período facturó un 22% menos que la primera, con la misma cantidad de ventas.
