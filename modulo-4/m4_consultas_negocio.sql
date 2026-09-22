-- ============================
-- CONSULTA 1: RESUMEN EJECUTIVO MENSUAL
-- ============================

SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta);

-- ============================
-- CONSULTA 2: RANKING DE PRODUCTOS (TOP 5)
-- ============================

SELECT 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;

-- ============================
-- CONSULTA 3: CLIENTES RECURRENTES
-- ============================

SELECT id_cliente,
 COUNT(*) AS cantidad_pedidos,
 SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

-- ============================
-- CONSULTA 4:  Meses por encima/por debajo del promedio
-- ============================

SELECT 
    mes,
    total_facturado,
    CASE 
        WHEN total_facturado > (
            SELECT AVG(total_facturado) 
            FROM (
                SELECT 
                    EXTRACT(MONTH FROM fecha_venta) AS mes,
                    SUM(cantidad * precio_unitario) AS total_facturado
                FROM ventas
                GROUP BY EXTRACT(MONTH FROM fecha_venta)
            ) AS sub
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion
FROM (
    SELECT 
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
) AS totales_mensuales;

-- ============================
-- HALLAZGOS
-- ============================
-- 1. El producto 1 (Laptop Pro 15) concentra el 55.9% de la facturación 
--    del mes ($3600 de $6444 totales), a pesar de haber vendido solo 3 unidades.
-- 2. El producto 2 (Mouse Inalámbrico) fue el más vendido en unidades (13), 
--    pero generó la menor facturación ($364), reflejo de su bajo precio unitario.
-- 3. Los 5 clientes hicieron exactamente 2 pedidos cada uno, pero con gastos 
--    muy dispares: el cliente 1 gastó $2640 (el mayor), mientras que el 
--    cliente 4 gastó solo $510 (casi 5 veces menos).
