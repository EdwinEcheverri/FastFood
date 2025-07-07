-- Creacion de Base de Datos

CREATE DATABASE FastFood;

-- Activacion de Base de Datos
USE FastFood

-- Creacion de las tablas

--Tabla de Categorias
CREATE TABLE Categorias(
    CategoriaId INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL 
);

--Tabla de Productos
CREATE TABLE Productos(
	ProductoID INT PRIMARY KEY IDENTITY(1,1),
	Nombre VARCHAR(100) NOT NULL,
	CategoriaID INT NOT NULL FOREIGN KEY REFERENCES Categorias(CategoriaId),
	Precio DECIMAL(10,2) NOT NULL,
);

--Tabla de Sucursales
CREATE TABLE Sucursales(
	SucursalID INT PRIMARY KEY IDENTITY(1,1),
	Nombre VARCHAR(100) NOT NULL,
	Direccion VARCHAR(255) NOT NULL,
);

--Tabla Empleados
CREATE TABLE Empleados(
	EmpleadoID INT PRIMARY KEY IDENTITY(1,1),
	Nombre VARCHAR(100) NOT NULL,
	Posicion VARCHAR(100) NOT NULL,
	Departamento VARCHAR(100) NOT NULL,
	SucursalID INT NOT NULL FOREIGN KEY REFERENCES Sucursales(SucursalId),
	Rol VARCHAR(100) NOT NULL,
);

--Tabla Clientes
CREATE TABLE Clientes(
	ClienteID INT PRIMARY KEY IDENTITY(1,1),
	Nombre VARCHAR(100) NOT NULL,
	Direccion VARCHAR(255) NOT NULL,
);

--Tabla OrigenesOrden
CREATE TABLE OrigenesOrden(
	OrigenID INT PRIMARY KEY IDENTITY(1,1),
	Descripcion VARCHAR(255) NOT NULL,
);

--Tabla TiposPago
CREATE TABLE TiposPago(
	TipoPagoID INT PRIMARY KEY IDENTITY(1,1),
	Descripcion VARCHAR(255) NOT NULL,
);

--Tabla Mensajeros
CREATE TABLE Mensajeros(
	MensajeroID INT PRIMARY KEY IDENTITY(1,1),
	Nombre VARCHAR(100) NOT NULL,
	EsExterno BIT NOT NULL DEFAULT 0,
);

--Tabla Ordenes
CREATE TABLE Ordenes(
	OrdenID INT PRIMARY KEY IDENTITY(1,1),
	ClienteID INT NOT NULL FOREIGN KEY REFERENCES Clientes(ClienteId),
	EmpleadoID INT NOT NULL FOREIGN KEY REFERENCES Empleados(EmpleadoId),
	SucursalID INT NOT NULL FOREIGN KEY REFERENCES Sucursales(SucursalId),
	MensajeroID INT NOT NULL FOREIGN KEY REFERENCES Mensajeros(MensajeroId),
	TipoPagoID INT NOT NULL FOREIGN KEY REFERENCES TiposPago(TipoPagoId),
	OrigenID INT NOT NULL FOREIGN KEY REFERENCES OrigenesOrden(OrigenId),
	HorarioVenta VARCHAR(100) NOT NULL,
	TotalCompra DECIMAL (10,2) NOT NULL,
	KilometrosRecorrer DECIMAL (10,2) NOT NULL,
	FechaDespacho DATETIME NOT NULL,
	FechaEntrega DATETIME NOT NULL,
	FechaOrdenTomada DATETIME NOT NULL,
	FechaOrdenLista DATETIME NOT NULL,
);

--Tabla DetalleOrdenes
CREATE TABLE DetalleOrdenes(
	OrdenID INT NOT NULL FOREIGN KEY REFERENCES Ordenes(OrdenId),
	ProductoID INT NOT NULL FOREIGN KEY REFERENCES Productos(ProductoId),
	Cantidad INT NOT NULL,
	Precio DECIMAL(10,2) NOT NULL,
	PRIMARY KEY (OrdenID,ProductoID)
	);