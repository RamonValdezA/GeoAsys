using System.Data;
using Dapper;
using GeoAsysApi.Models;
using Microsoft.Data.SqlClient;

namespace GeoAsysApi.Repositories;

public interface IGeometryRepository
{
    Task<IEnumerable<FiguraRaw>> ObtenerTodasAsync();
    Task<IEnumerable<FiguraRaw>> ObtenerPaginadoAsync(int pagina, int registros);
}