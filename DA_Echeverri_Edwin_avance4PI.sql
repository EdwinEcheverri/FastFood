--CONSULTAS CON MULTIPLES TABLAS Y JOINs

USE FastFood;

/*1. Listar todos los productos y sus categorías
Pregunta: ¿Cómo puedo obtener una lista de todos los productos junto con sus categorías?*/

SELECT
	P.Nombre AS NombreProducto,
	c.Nombre AS NombreCategoria
FROM
	Productos AS p
LEFT JOIN Categorias AS c ON p.CategoriaID = c.CategoriaId;

/*2. Obtener empleados y su sucursal asignada
Pregunta: ¿Cómo puedo saber a qué sucursal está asignado cada empleado?*/

SELECT 
	e.Nombre AS NombreEmpleado, s.nombre AS NombreSucursal
FROM 
	Empleados e
INNER JOIN Sucursales s ON e.SucursalID = s.SucursalID;

/*3. Identificar productos sin categoría asignada
Pregunta: ¿Existen productos que no tienen una categoría asignada?*/

SELECT 
	p.Nombre AS NombreProducto
FROM 
	Productos p
LEFT JOIN Categorias c ON p.CategoriaID = c.CategoriaId
WHERE 
	c.CategoriaId IS NULL;

/*4. Detalle completo de órdenes
Pregunta: ¿Cómo puedo obtener un detalle completo de las órdenes, incluyendo el Nombre del cliente, 
Nombre del empleado que tomó la orden, y Nombre del mensajero que la entregó?*/

SELECT
	O.*,
	cl.Nombre AS NombreCliente,
	e.Nombre AS NombreEmpleado,
	m.Nombre AS NombreMensajero
FROM
	Ordenes o
LEFT JOIN Clientes cl ON o.ClienteID = cl.ClienteID
LEFT JOIN Empleados e ON o.EmpleadoID = e.EmpleadoID
LEFT JOIN Mensajeros m ON o.MensajeroID = m.MensajeroID;

/*5. Productos vendidos por sucursal
Pregunta: ¿Cuántos artículos correspondientes a cada Categoría de Productos se han vendido en cada sucursal?*/

SELECT
	s.Nombre AS Sucursal,
	c.Nombre AS Categoria,
	SUM(do.Cantidad) AS UnidadesVendidas
FROM Ordenes AS o
INNER JOIN detalleOrdenes AS do
	ON o.OrdenID = do.OrdenID
INNER JOIN Sucursales AS s
	ON o.SucursalID = s.SucursalID
INNER JOIN Productos AS p
	ON do.ProductoID = p.ProductoID
INNER JOIN Categorias AS c
	ON p.CategoriaID = c.CategoriaID
GROUP BY s.Nombre, c.Nombre;

--CONSULTAS FINALES

USE FastFood;

/*1. Eficiencia de los mensajeros: 
¿Cuál es el tiempo promedio desde el despacho hasta la entrega de los pedidos 
gestionados por todo el equipo de mensajería?*/

SELECT
CONVERT(DECIMAL(10,2), AVG(DATEDIFF(minute, FechaDespacho, FechaEntrega))) AS MinutosPromedioEntrega
FROM 
	Ordenes
WHERE
	MensajeroID IS NOT NULL AND FechaDespacho IS NOT NULL AND FechaEntrega IS NOT NULL;

/*2. Análisis de Ventas por Origen de Orden: 
¿Qué canal de ventas genera más ingresos?*/

SELECT TOP 1
	oo.Descripcion AS OrigenOrden,
	SUM(o.TotalCompra) AS TotalIngresos
FROM 
	Ordenes AS o
INNER JOIN
	OrigenesOrden AS oo ON o.OrigenID = oo.OrigenID
GROUP BY
	oo.Descripcion
ORDER BY
	TotalIngresos DESC;

/*3. Productividad de los Empleados: 
¿Cuál es el nivel de ingreso generado por Empleado?*/

SELECT
	e.Nombre AS NombreEmpleado,
	SUM(o.TotalCompra) AS TotalIngresos
FROM 
	Ordenes AS o
INNER JOIN Empleados  AS e ON o.EmpleadoID = e.EmpleadoID
GROUP BY
	e.Nombre
ORDER BY
	TotalIngresos DESC;

/*4. Análisis de Demanda por Horario y Día: 
¿Cómo varía la demanda de productos a lo largo del día? 
NOTA: Esta consulta no puede ser implementada sin una definición clara del horario (mañana, tarde, noche) en la base de datos existente. 
Asumiremos que HorarioVenta refleja esta información correctamente.*/

SELECT o.HorarioVenta,
	SUM(do.Cantidad) AS UnidadesVendidas
FROM Ordenes AS o
LEFT JOIN DetalleOrdenes AS do
	ON o.OrdenID = do.OrdenID
GROUP BY o.HorarioVenta;

/*5. Comparación de Ventas Mensuales: 
¿Cuál es la tendencia de los ingresos generados en cada periodo mensual?*/

SELECT
	FORMAT(FechaOrdenTomada, 'yyyy-MM') AS PeriodoMensual,
	SUM(TotalCompra) AS TotalIngresos
FROM
	Ordenes
GROUP BY
	FORMAT(FechaOrdenTomada, 'yyyy-MM')
ORDER BY
	PeriodoMensual;