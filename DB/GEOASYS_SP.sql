USE GEOASYS
GO 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[SP_ExtraerObjetos]
(
    @Pagina INT = 1,
    @Registros INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TotalRegistros INT,
            @TotalPaginas INT,
            @Desde INT;
    SET @Desde = (@Pagina - 1) * @Registros;

    SELECT @TotalRegistros = COUNT(*)
    FROM FiguraGeometrica
    SET @TotalPaginas = CEILING(CAST(@TotalRegistros AS FLOAT) / @Registros);

    SELECT 
        f.idFigura,
        f.nombre AS FiguraGeometrica,
        CASE f.dimension 
            WHEN 2 THEN '2D (Plana)' 
            WHEN 3 THEN '3D (Tridimensional)' 
        END AS Dimension,
        cr.nombre AS CriterioClasificacion,
        c.nombre AS Subclasificacion,
        ISNULL(CAST(f.numeroLados AS NVARCHAR(50)), 'No aplica') AS Lados,
        ISNULL(CAST(f.numeroCaras AS NVARCHAR(50)), 'No aplica') AS Caras,
        ISNULL(CAST(f.numeroVertices AS NVARCHAR(50)), 'No aplica') AS Vertices,
        ISNULL(CAST(f.numeroAristas AS NVARCHAR(50)), 'No aplica') AS Aristas,
        ISNULL(fb.nombre, 'No aplica') AS FiguraBaseOrigen,
        c.descripcion AS DescripcionClasificacion
    FROM dbo.FiguraGeometrica f
        INNER JOIN dbo.ClasificacionObj c ON f.idClasificacion = c.idClasificación
        INNER JOIN dbo.CriterioClasif cr ON c.idCriterio = cr.idCriterio
        LEFT JOIN dbo.FiguraGeometrica fb ON f.idFiguraBase = fb.idFigura
    ORDER BY f.dimension, f.idFigura ASC
    OFFSET @Desde ROWS
    FETCH NEXT @Registros ROWS ONLY;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_ExtraerFiguras]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        f.idFigura,
        f.nombre AS FiguraGeometrica,
        CASE f.dimension 
            WHEN 2 THEN '2D (Plana)' 
            WHEN 3 THEN '3D (Tridimensional)' 
        END AS Dimension,
        cr.nombre AS CriterioClasificacion,
        c.nombre AS Subclasificacion,
        ISNULL(CAST(f.numeroLados AS NVARCHAR(50)), 'No aplica') AS Lados,
        ISNULL(CAST(f.numeroCaras AS NVARCHAR(50)), 'No aplica') AS Caras,
        ISNULL(CAST(f.numeroVertices AS NVARCHAR(50)), 'No aplica') AS Vertices,
        ISNULL(CAST(f.numeroAristas AS NVARCHAR(50)), 'No aplica') AS Aristas,
        ISNULL(fb.nombre, 'No aplica') AS FiguraBaseOrigen,
        c.descripcion AS DescripcionClasificacion
    FROM dbo.FiguraGeometrica f
        INNER JOIN dbo.ClasificacionObj c ON f.idClasificacion = c.idClasificación
        INNER JOIN dbo.CriterioClasif cr ON c.idCriterio = cr.idCriterio
        LEFT JOIN dbo.FiguraGeometrica fb ON f.idFiguraBase = fb.idFigura
    ORDER BY f.dimension, f.idFigura ASC
END
GO