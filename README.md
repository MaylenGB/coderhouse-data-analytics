# Coderhouse - Data Analytics

Repositorio de prácticas y checkpoints del curso de Data Analytics en Coderhouse. Cada módulo se documenta en su propia carpeta, con los scripts SQL y consultas de negocio correspondientes.

## Motor SQL

PostgreSQL 16 (probado en local con pgAdmin 4).

## Modelo de datos: Ventas_Tech_DB

Base de datos de una cadena de tiendas de tecnología (TechStore), usada como dataset de práctica a lo largo del curso.

**Relaciones:**

categorias (1) ──── (N) productos (1) ──── (N) ventas (N) ──── (1) clientes


- **categorias**: id_categoria (PK), nombre_categoria, descripcion
- **clientes**: id_cliente (PK), nombre, email, ciudad, fecha_registro
- **productos**: id_producto (PK), nombre_producto, id_categoria (FK → categorias), precio, stock, activo
- **ventas**: id_venta (PK), id_cliente (FK → clientes), id_producto (FK → productos), cantidad, precio_unitario, fecha_venta

## Cómo ejecutar los scripts

1. Crear la base de datos: `CREATE DATABASE Ventas_Tech_DB;`
2. Conectarse a esa base (en pgAdmin: seleccionarla en el árbol y abrir un Query Tool nuevo).
3. Ejecutar el script correspondiente al módulo (ver estructura abajo).

## Estructura del repositorio

- **modulo-3/**: `ventas_tech_db.sql` — creación de la base de datos, definición de tablas (DDL), restricciones de integridad (PK/FK/NOT NULL/UNIQUE) y carga inicial de datos (DML).
- **modulo-4/**: `m4_consultas_negocio.sql` — consultas SQL de agregación (COUNT, SUM, AVG, MIN, MAX) y agrupamiento (GROUP BY) que responden preguntas de negocio sobre la base creada en el módulo 3.
