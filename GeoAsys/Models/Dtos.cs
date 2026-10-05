namespace GeoAsys.Models
{
    public class Dtos
    {
        public record UserQueryRequest(
            int Dimension,                  
            int? NumeroLados,               
            int? NumeroCaras,              
            int? NumeroVertices,           
            int? NumeroAristas,             
            string? CriterioFiltro,         
            string? SubclasificacionFiltro  
        );

        public record InferenceResult(
            int IdFigura,
            string Nombre,
            string Dimension,
            string CriterioClasificacion,
            string Subclasificacion,
            string Lados,
            string Caras,
            string Vertices,
            string Aristas,
            string FiguraBaseOrigen,
            double CoincidenciaPorcentaje,
            string Explicacion
        );
    }
}
