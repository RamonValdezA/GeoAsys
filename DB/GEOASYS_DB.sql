CREATE DATABASE GEOASYS;
GO 
USE GEOASYS;
GO 

-- 1. Tipos de Criterios (Ej. 'Según lados', 'Según ángulos', 'Revolución', etc.)
CREATE TABLE dbo.CriterioClasif (
    idCriterio INT PRIMARY KEY IDENTITY(1,1), 
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(MAX) NULL
);
GO 

-- 2. Categorías/Clasificaciones específicas (Ej. 'Paralelogramo', 'Cónica', 'Poliedro Regular')
CREATE TABLE dbo.ClasificacionObj (
    idClasificación INT PRIMARY KEY IDENTITY(1,1),
    idCriterio INT NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(MAX) NULL,
    
    CONSTRAINT FK_Clasif_Criterio 
        FOREIGN KEY (idCriterio) REFERENCES dbo.CriterioClasif(idCriterio)
);
GO

-- 3. TABLA CENTRAL DE FIGURAS (Modelado unificado)
CREATE TABLE dbo.FiguraGeometrica (
    idFigura INT PRIMARY KEY IDENTITY(1,1),
    idClasificacion INT NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    dimension INT NOT NULL CHECK (dimension IN (2, 3)), -- 2D o 3D
    
    -- Atributos comunes/opcionales (permiten NULL si no aplican a la figura)
    numeroLados INT NULL,     -- Aplica a Polígonos (2D)
    numeroCaras INT NULL,     -- Aplica a Poliedros/Cuerpos (3D)
    numeroVertices INT NULL,  -- Aplica a Polígonos y Poliedros
    numeroAristas INT NULL,   -- Aplica a Poliedros
    
    -- Opcional: si la figura 3D proviene de rotar/extruir una figura 2D
    idFiguraBase INT NULL, 

    CONSTRAINT FK_Figura_Clasificacion 
        FOREIGN KEY (idClasificacion) REFERENCES dbo.ClasificacionObj(idClasificación),
    CONSTRAINT FK_Figura_FiguraBase 
        FOREIGN KEY (idFiguraBase) REFERENCES dbo.FiguraGeometrica(idFigura)
);
GO
---------------------------------------------------------------------------------------------------------------

USE GEOASYS;
GO

-- =============================================
-- 1. INSERTAR CRITERIOS DE CLASIFICACIÓN
-- =============================================
INSERT INTO dbo.CriterioClasif (nombre, descripcion) VALUES 
('Lados de Poligonos', 'Clasificacion de figuras planas segun su numero de lados o longitud'),
('Angulos de Poligonos', 'Clasificacion segun la apertura de sus angulos internos'),
('Propiedades de Cuadrilateros', 'Clasificacion de cuadrilateros por paralelismo o симetrıa'),
('Secciones Conicas y Curvas', 'Curvas planas obtenidas por cortes en conos o ecuaciones continuas'),
('Poliedros Regulares (Platonicos)', 'Cuerpos 3D convexos con caras poligonales regulares idénticas'),
('Poliedros Semirregulares (Arquimedeanos)', 'Cuerpos 3D convexos cuyas caras son dos o mas tipos de poligonos regulares'),
('Prismas y Antiprismas', 'Poliedros formados por dos bases paralelas e iguales unidas por paralelogramos o triangulos'),
('Piramides y Troncos', 'Poliedros formados por una base poligonal y caras triangulares concurrentes en un vertice'),
('Cuerpos de Revolucion y Redondos', 'Cuerpos 3D engendrados por la rotacion de una figura plana sobre un eje'),
('Superficies Cuadraticas', 'Sólidos y superficies 3D definidos por ecuaciones de segundo grado');
GO

-- =============================================
-- 2. INSERTAR CLASIFICACIONES ESPECÍFICAS
-- =============================================
INSERT INTO dbo.ClasificacionObj (idCriterio, nombre, descripcion) VALUES
-- Criterio 1: Lados de Polígonos
(1, 'Triangulo por Lados', 'Triangulos clasificados por la igualdad de sus lados'),
(1, 'Poligono Regular', 'Poligono plano con todos sus lados y angulos iguales'),
(1, 'Poligono Irregular', 'Poligono plano con lados y angulos desiguales'),

-- Criterio 2: Ángulos de Polígonos
(2, 'Triangulo por Angulos', 'Triangulos clasificados por la medida de sus angulos internos'),
(2, 'Poligono Convexo', 'Poligono donde todos sus angulos internos son menores a 180°'),
(2, 'Poligono Concavo', 'Poligono con al menos un angulo interno mayor a 180°'),

-- Criterio 3: Cuadriláteros
(3, 'Paralelogramo', 'Cuadrilatero con lados opuestos paralelos e iguales dos a dos'),
(3, 'Trapecio', 'Cuadrilatero con unicamente un par de lados paralelos'),
(3, 'Trapezoide', 'Cuadrilatero sin lados paralelos'),

-- Criterio 4: Cónicas y Curvas
(4, 'Conica Cerrada', 'Curva plana sin extremos libres (Circulo, Elipse)'),
(4, 'Conica Abierta', 'Curva plana abierta al infinito (Parabola, Hiperbola)'),
(4, 'Curva Especial', 'Curvas geometricas no conicas (Cardioide, Espiral)'),

-- Criterio 5: Poliedros Regulares
(5, 'Solido Platonico', 'Uno de los 5 poliedros regulares convexos'),

-- Criterio 6: Poliedros Semirregulares
(6, 'Solido Arquimedeano', 'Poliedro semirregular con vertices uniformes'),
(6, 'Solido Catalán', 'Poliedro dual de los solidos de Arquimedes'),

-- Criterio 7: Prismas y Antiprismas
(7, 'Prisma Recto', 'Prisma cuyas caras laterales son perpendiculares a las bases'),
(7, 'Prisma Oblicuo', 'Prisma cuyas caras laterales no son perpendiculares a las bases'),
(7, 'Antiprisma', 'Poliedro con dos bases paralelas unidas por una banda de triangulos alternados'),

-- Criterio 8: Pirámides y Troncos
(8, 'Pirámide', 'Poliedro con base poligonal y caras triangulares convergentes'),
(8, 'Tronco de Pirámide', 'Porcion de pirámide comprendida entre la base y un plano de corte'),

-- Criterio 9: Cuerpos de Revolución
(9, 'Cuerpo Redondo Clásico', 'Cuerpos formados por revolucion directa (Cilindro, Cono, Esfera)'),
(9, 'Toroide', 'Cuerpo engendrado por el giro de una figura alrededor de un eje coplanar no secante'),

-- Criterio 10: Cuádricas
(10, 'Elipsoide / Esferoide', 'Superficie cuadrica análoga en 3D a la elipse'),
(10, 'Paraboloide / Hiperboloide', 'Superficies tridimensionales abiertas');
GO

-- =============================================
-- 3. INSERTAR FIGURAS GEOMÉTRICAS (2D Y 3D)
-- =============================================

---------------------------------------------------
-- A) FIGURAS PLANAS (2D) - Para usarse individualmente o como base
---------------------------------------------------
INSERT INTO dbo.FiguraGeometrica (idClasificacion, nombre, dimension, numeroLados, numeroCaras, numeroVertices, numeroAristas, idFiguraBase) VALUES
-- Triángulos (IDs 1 - 6)
(1, 'Triángulo Equilátero', 2, 3, NULL, 3, NULL, NULL),
(1, 'Triángulo Isósceles', 2, 3, NULL, 3, NULL, NULL),
(1, 'Triángulo Escaleno', 2, 3, NULL, 3, NULL, NULL),
(4, 'Triángulo Acutángulo', 2, 3, NULL, 3, NULL, NULL),
(4, 'Triángulo Rectángulo', 2, 3, NULL, 3, NULL, NULL),
(4, 'Triángulo Obtusángulo', 2, 3, NULL, 3, NULL, NULL),

-- Cuadriláteros (IDs 7 - 14)
(7, 'Cuadrado', 2, 4, NULL, 4, NULL, NULL),
(7, 'Rectángulo', 2, 4, NULL, 4, NULL, NULL),
(7, 'Rombo', 2, 4, NULL, 4, NULL, NULL),
(7, 'Romboide', 2, 4, NULL, 4, NULL, NULL),
(8, 'Trapecio Isósceles', 2, 4, NULL, 4, NULL, NULL),
(8, 'Trapecio Rectángulo', 2, 4, NULL, 4, NULL, NULL),
(8, 'Trapecio Escaleno', 2, 4, NULL, 4, NULL, NULL),
(9, 'Trapezoide Deltoide (Cometa)', 2, 4, NULL, 4, NULL, NULL),

-- Polígonos Regulares (IDs 15 - 22)
(2, 'Pentágono Regular', 2, 5, NULL, 5, NULL, NULL),
(2, 'Hexágono Regular', 2, 6, NULL, 6, NULL, NULL),
(2, 'Heptágono Regular', 2, 7, NULL, 7, NULL, NULL),
(2, 'Octágono Regular', 2, 8, NULL, 8, NULL, NULL),
(2, 'Eneágono / Nonágono Regular', 2, 9, NULL, 9, NULL, NULL),
(2, 'Decágono Regular', 2, 10, NULL, 10, NULL, NULL),
(2, 'Endecágono Regular', 2, 11, NULL, 11, NULL, NULL),
(2, 'Dodecágono Regular', 2, 12, NULL, 12, NULL, NULL),

-- Estrellados y Cóncavos (IDs 23 - 24)
(6, 'Pentagrama (Estrella de 5 puntas)', 2, 10, NULL, 10, NULL, NULL),
(6, 'Polígono Cóncavo Irregular', 2, 5, NULL, 5, NULL, NULL),

-- Cónicas y Curvas Planas (IDs 25 - 29)
(10, 'Círculo / Circunferencia', 2, 0, NULL, 0, NULL, NULL),
(10, 'Elipse', 2, 0, NULL, 0, NULL, NULL),
(11, 'Parábola (Curva plana)', 2, 0, NULL, 0, NULL, NULL),
(11, 'Hipérbola (Curva plana)', 2, 0, NULL, 0, NULL, NULL),
(12, 'Cardioide', 2, 0, NULL, 0, NULL, NULL);

---------------------------------------------------
-- B) CUERPOS TRIDIMENSIONALES (3D)
---------------------------------------------------
INSERT INTO dbo.FiguraGeometrica (idClasificacion, nombre, dimension, numeroLados, numeroCaras, numeroVertices, numeroAristas, idFiguraBase) VALUES
-- Sólidos Platónicos (IDs 30 - 34)
(13, 'Tetraedro Regular', 3, NULL, 4, 4, 6, 1),        -- Base: Triángulo Equilátero
(13, 'Hexaedro Regular (Cubo)', 3, NULL, 6, 8, 12, 7),  -- Base: Cuadrado
(13, 'Octaedro Regular', 3, NULL, 8, 6, 12, 1),       -- Base: Triángulo Equilátero
(13, 'Dodecaedro Regular', 3, NULL, 12, 20, 30, 15),   -- Base: Pentágono Regular
(13, 'Icosaedro Regular', 3, NULL, 20, 12, 30, 1),     -- Base: Triángulo Equilátero

-- Sólidos Arquimedeanos y Catalán seleccionados (IDs 35 - 38)
(14, 'Cubo Truncado', 3, NULL, 14, 24, 36, 18),        -- Caras de octágonos y triángulos
(14, 'Icosidodecaedro', 3, NULL, 32, 30, 60, NULL),
(14, 'Tetraedro Truncado', 3, NULL, 8, 12, 18, 16),
(15, 'Rombododecaedro', 3, NULL, 12, 14, 24, 9),       -- Dual del Cuboctaedro, caras rombos

-- Prismas (IDs 39 - 43)
(16, 'Prisma Triangular Recto', 3, NULL, 5, 6, 9, 1),       -- Base: Triángulo Equilátero
(16, 'Prisma Rectangular (Ortoedro)', 3, NULL, 6, 8, 12, 8), -- Base: Rectángulo
(16, 'Prisma Pentagonal', 3, NULL, 7, 10, 15, 15),          -- Base: Pentágono Regular
(16, 'Prisma Hexagonal', 3, NULL, 8, 12, 18, 16),           -- Base: Hexágono Regular
(17, 'Prisma Hexagonal Oblicuo', 3, NULL, 8, 12, 18, 16),

-- Antiprismas (ID 44)
(18, 'Antiprisma Cuadrado', 3, NULL, 10, 8, 16, 7),         -- Bases cuadradas unidas por triángulos

-- Pirámides (IDs 45 - 48)
(19, 'Pirámide Triangular', 3, NULL, 4, 4, 6, 1),           -- Base: Triángulo Equilátero
(19, 'Pirámide Cuadrangular', 3, NULL, 5, 5, 8, 7),         -- Base: Cuadrado
(19, 'Pirámide Pentagonal', 3, NULL, 6, 6, 10, 15),         -- Base: Pentágono Regular
(19, 'Pirámide Hexagonal', 3, NULL, 7, 7, 12, 16),          -- Base: Hexágono Regular

-- Troncos de Pirámide y Cono (IDs 49 - 50)
(20, 'Tronco de Pirámide Cuadrangular', 3, NULL, 6, 8, 12, 7),
(20, 'Tronco de Cono (Cono Truncado)', 3, NULL, 3, 0, 2, 25),-- Base: Círculo

-- Cuerpos Redondos y de Revolución (IDs 51 - 56)
(21, 'Cilindro Recto', 3, NULL, 3, 0, 2, 25),               -- Base: Círculo
(21, 'Cono Recto', 3, NULL, 2, 1, 1, 25),                   -- Base: Círculo
(21, 'Esfera', 3, NULL, 1, 0, 0, 25),                       -- Generado por semicírculo
(21, 'Hemisferio (Semiesfera)', 3, NULL, 2, 0, 1, 25),
(22, 'Toro / Toroide (Dona)', 3, NULL, 1, 0, 0, 25),         -- Giro de círculo sobre eje exterior
(22, 'Cilindro Hueco (Tubo)', 3, NULL, 4, 0, 4, 25),

-- Superficies Cuádricas (IDs 57 - 60)
(23, 'Elipsoide', 3, NULL, 1, 0, 0, 26),                    -- Base/Referencia: Elipse
(23, 'Esferoide Oblato', 3, NULL, 1, 0, 0, 26),
(24, 'Paraboloide de Revolución', 3, NULL, 1, 0, 0, 27),   -- Referencia: Parábola
(24, 'Hiperboloide de una Hoja', 3, NULL, 1, 0, 0, 28);    -- Referencia: Hipérbola
GO