using Dapper;
using GeoAsysApi.Models;
using GeoAsysApi.Repositories;
using Microsoft.Data.SqlClient;
using System.Data;

public class GeometryRepository : IGeometryRepository
{
    private readonly string _connectionString;

    public GeometryRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new ArgumentNullException("No se configuró la cadena de conexión 'DefaultConnection'.");
    }

    public async Task<IEnumerable<FiguraRaw>> ObtenerTodasAsync()
    {
        using IDbConnection db = new SqlConnection(_connectionString);
        return await db.QueryAsync<FiguraRaw>(
            "dbo.SP_ExtraerFiguras",
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<IEnumerable<FiguraRaw>> ObtenerPaginadoAsync(int pagina, int registros)
    {
        using IDbConnection db = new SqlConnection(_connectionString);
        var parametros = new DynamicParameters();
        parametros.Add("@Pagina", pagina);
        parametros.Add("@Registros", registros);

        return await db.QueryAsync<FiguraRaw>(
            "dbo.SP_ExtraerObjetos",
            parametros,
            commandType: CommandType.StoredProcedure
        );
    }
}