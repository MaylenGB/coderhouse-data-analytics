# Coderhouse - Data Analytics · Proyecto RetailPro

Repositorio de prácticas y checkpoints del curso de Data Analytics en Coderhouse. Cada módulo se documenta en su propia carpeta, con los scripts SQL y las consultas de negocio correspondientes.

## Sobre el proyecto

**RetailPro** es el caso de negocio del proyecto integrador: una distribuidora B2B de tecnología (el brief y el modelo relacional corresponden a los módulos 1 y 2).

Los scripts SQL de este repositorio corren sobre **Ventas_Tech_DB**, la base de práctica de una tienda de tecnología (TechStore). Es la base que se usa en los módulos 3 a 5 y la que después alimenta el trabajo en Power BI.

## Motor SQL

PostgreSQL 16 (probado en local con pgAdmin 4).

## Herramientas

- PostgreSQL 16
- pgAdmin 4
- GitHub
- Power BI Desktop (en desarrollo, a partir del módulo 6)

## Modelo de datos: Ventas_Tech_DB

```
categorias (1) ──── (N) productos (1) ──── (N) ventas (N) ──── (1) clientes
```

- **categorias**: id_categoria (PK), nombre_categoria, descripcion
- **clientes**: id_cliente (PK), nombre, email, ciudad, fecha_registro
- **productos**: id_producto (PK), nombre_producto, id_categoria (FK → categorias), precio, stock, activo
- **ventas**: id_venta (PK), id_cliente (FK → clientes), id_producto (FK → productos), cantidad, precio_unitario, fecha_venta

## Cómo ejecutar los scripts

1. Conectate a la base `postgres` y ejecutá, por separado: `CREATE DATABASE Ventas_Tech_DB;` (PostgreSQL no permite crearla dentro del mismo script que las tablas).
2. En pgAdmin, seleccioná `Ventas_Tech_DB` en el árbol y abrí un **Query Tool** nuevo.
3. Ejecutá primero el script de `modulo-3`, que crea las tablas y carga los datos.
4. Después podés correr las consultas de `modulo-4` y `modulo-5`: seleccioná cada consulta con el mouse y ejecutala con ▶.

> ⚠️ **Atención:** el script de `modulo-3` empieza con `DROP TABLE`. Al ejecutarlo se borran y se vuelven a crear las tablas, así que vuelve todo a los datos iniciales. Usalo solo cuando quieras reiniciar la base.

## Cómo verificar que salió bien

- Después del módulo 3: 4 categorías, 5 clientes, 6 productos y 10 ventas.
- Módulo 4, resumen mensual: total facturado de 6.444,00 en 10 pedidos.
- Módulo 5, vista base: 10 filas, con un total de ventas de 6.444,00.

## Estructura del repositorio

- **modulo-3/**: `ventas_tech_db.sql` — creación de las tablas (DDL), restricciones de integridad (PK, FK, NOT NULL, UNIQUE) y carga inicial de datos (DML).
- **modulo-4/**: `m4_consultas_negocio.sql` — consultas de agregación (SUM, COUNT, AVG), agrupamiento (GROUP BY, HAVING) y una subconsulta para comparar cada mes con el promedio.
- **modulo-5/**: `m5_consultas_joins.sql` — consultas con INNER JOIN, LEFT JOIN y UNION ALL.

## Autora

Mailén · Curso de Data Analytics, Coderhouse.
