  
PRAGMA foreign_keys = ON;

-- tabla clientes
CREATE TABLE IF NOT EXISTS Clientes (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre TEXT NOT NULL,
    Licencia TEXT NOT NULL UNIQUE,
    Telefono TEXT NOT NULL
);

-- tabla auto
CREATE TABLE IF NOT EXISTS Auto (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Marca TEXT NOT NULL,
    Description TEXT
);

-- tabla alquiler
CREATE TABLE IF NOT EXISTS Alquiler (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    ClienteId INTEGER NOT NULL,
    AutoId INTEGER NOT NULL,
    FechaInicio TEXT NOT NULL,
    FechaFin TEXT,
    Precio REAL NOT NULL CHECK (Precio >= 0),
    FOREIGN KEY (ClienteId) REFERENCES Clientes(Id),
    FOREIGN KEY (AutoId) REFERENCES Auto(Id)
);

-- datos de prueba: Clientes (Licencia es UNIQUE, no se duplican)
INSERT OR IGNORE INTO Clientes (Nombre, Licencia, Telefono) VALUES
('Juan Pérez',     'LIC-001', '809-555-0101'),
('María Gómez',    'LIC-002', '809-555-0102'),
('Carlos Ramírez', 'LIC-003', '809-555-0103'),
('Ana Martínez',   'LIC-004', '809-555-0104'),
('Luis Fernández', 'LIC-005', '809-555-0105');

-- datos de prueba: Auto (solo si la tabla está vacía)
INSERT INTO Auto (Marca, Description)
SELECT column1, column2 FROM (VALUES
    ('Toyota',  'Corolla 2020, sedán blanco'),
    ('Honda',   'Civic 2019, sedán gris'),
    ('Hyundai', 'Tucson 2021, SUV negra'),
    ('Kia',     'Rio 2022, hatchback rojo'),
    ('Nissan',  'Sentra 2018, sedán azul')
)
WHERE NOT EXISTS (SELECT 1 FROM Auto);

-- datos de prueba: Alquiler (solo si está vacía y existen clientes y autos 1 a 5)
INSERT INTO Alquiler (ClienteId, AutoId, FechaInicio, FechaFin, Precio)
SELECT column1, column2, column3, column4, column5 FROM (VALUES
    (1, 1, '2026-10-01', '2026-10-05', 200.00),
    (1, 2, '2026-10-10', '2026-10-12', 120.00),
    (2, 1, '2026-10-06', '2026-10-09', 150.00),
    (3, 3, '2026-10-15', '2026-10-20', 400.00),
    (4, 4, '2026-11-01', '2026-11-03',  90.00),
    (5, 5, '2026-11-05', NULL,         180.00)
)
WHERE NOT EXISTS (SELECT 1 FROM Alquiler)
  AND (SELECT COUNT(*) FROM Clientes WHERE Id <= 5) = 5
  AND (SELECT COUNT(*) FROM Auto WHERE Id <= 5) = 5;