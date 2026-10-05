namespace GeoAsysApi.Models;

public class FiguraRaw
{
    public int IdFigura { get; set; }
    public string FiguraGeometrica { get; set; } = string.Empty;
    public string Dimension { get; set; } = string.Empty;
    public string CriterioClasificacion { get; set; } = string.Empty;
    public string Subclasificacion { get; set; } = string.Empty;
    public string Lados { get; set; } = string.Empty;
    public string Caras { get; set; } = string.Empty;
    public string Vertices { get; set; } = string.Empty;
    public string Aristas { get; set; } = string.Empty;
    public string FiguraBaseOrigen { get; set; } = string.Empty;
    public string DescripcionClasificacion { get; set; } = string.Empty;
}