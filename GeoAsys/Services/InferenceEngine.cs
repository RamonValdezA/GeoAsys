using GeoAsysApi.Models;
using GeoAsysApi.Repositories;
using GeoAsysApi.Services;
using static GeoAsys.Models.Dtos;

public class InferenceEngine : IInferenceEngine
{
    private readonly IGeometryRepository _repository;

    public InferenceEngine(IGeometryRepository repository)
    {
        _repository = repository;
    }

    public async Task<IEnumerable<InferenceResult>> InferirFiguraAsync(UserQueryRequest request)
    {
        var baseConocimiento = await _repository.ObtenerTodasAsync();
        var resultados = new List<InferenceResult>();
        string dimTexto = request.Dimension == 2 ? "2D (Plana)" : "3D (Tridimensional)";
        var candidatos = baseConocimiento.Where(f => f.Dimension == dimTexto);

        foreach (var figura in candidatos)
        {
            double puntosClave = 0;
            double puntosObtenidos = 0;
            var detallesExplicacion = new List<string>();
            if (request.NumeroLados.HasValue)
            {
                puntosClave++;
                if (int.TryParse(figura.Lados, out int lados) && lados == request.NumeroLados.Value)
                {
                    puntosObtenidos++;
                    detallesExplicacion.Add($"Coincide en número de lados ({request.NumeroLados}).");
                }
            }

            if (request.NumeroCaras.HasValue)
            {
                puntosClave++;
                if (int.TryParse(figura.Caras, out int caras) && caras == request.NumeroCaras.Value)
                {
                    puntosObtenidos++;
                    detallesExplicacion.Add($"Coincide en número de caras ({request.NumeroCaras}).");
                }
            }

            if (request.NumeroVertices.HasValue)
            {
                puntosClave++;
                if (int.TryParse(figura.Vertices, out int vertices) && vertices == request.NumeroVertices.Value)
                {
                    puntosObtenidos++;
                    detallesExplicacion.Add($"Coincide en número de vértices ({request.NumeroVertices}).");
                }
            }

            if (request.NumeroAristas.HasValue)
            {
                puntosClave++;
                if (int.TryParse(figura.Aristas, out int aristas) && aristas == request.NumeroAristas.Value)
                {
                    puntosObtenidos++;
                    detallesExplicacion.Add($"Coincide en número de aristas ({request.NumeroAristas}).");
                }
            }

            if (!string.IsNullOrWhiteSpace(request.CriterioFiltro))
            {
                puntosClave++;
                if (figura.CriterioClasificacion.Contains(request.CriterioFiltro, StringComparison.OrdinalIgnoreCase))
                {
                    puntosObtenidos++;
                    detallesExplicacion.Add($"Coincide con el criterio '{request.CriterioFiltro}'.");
                }
            }

            if (!string.IsNullOrWhiteSpace(request.SubclasificacionFiltro))
            {
                puntosClave++;
                if (figura.Subclasificacion.Contains(request.SubclasificacionFiltro, StringComparison.OrdinalIgnoreCase))
                {
                    puntosObtenidos++;
                    detallesExplicacion.Add($"Coincide con la subclasificación '{request.SubclasificacionFiltro}'.");
                }
            }

            double coincidencia = puntosClave > 0 ? (puntosObtenidos / puntosClave) * 100 : 100;

            if (coincidencia > 0)
            {
                string explicacion = detallesExplicacion.Count > 0
                    ? string.Join(" ", detallesExplicacion)
                    : "Coincidencia basada únicamente en filtro de dimensión.";

                resultados.Add(new InferenceResult(
                    figura.IdFigura,
                    figura.FiguraGeometrica,
                    figura.Dimension,
                    figura.CriterioClasificacion,
                    figura.Subclasificacion,
                    figura.Lados,
                    figura.Caras,
                    figura.Vertices,
                    figura.Aristas,
                    figura.FiguraBaseOrigen,
                    Math.Round(coincidencia, 2),
                    explicacion
                ));
            }
        }

        return resultados.OrderByDescending(r => r.CoincidenciaPorcentaje);
    }
}