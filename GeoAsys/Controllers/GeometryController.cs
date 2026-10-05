using GeoAsysApi.Models;
using GeoAsysApi.Repositories;
using GeoAsysApi.Services;
using Microsoft.AspNetCore.Mvc;
using static GeoAsys.Models.Dtos;

namespace GeoAsysApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class GeometryController : ControllerBase
{
    private readonly IGeometryRepository _repository;
    private readonly IInferenceEngine _inferenceEngine;

    public GeometryController(IGeometryRepository repository, IInferenceEngine inferenceEngine)
    {
        _repository = repository;
        _inferenceEngine = inferenceEngine;
    }

    [HttpPost("inferir")]
    [ProducesResponseType(typeof(IEnumerable<InferenceResult>), StatusCodes.Status200OK)]
    public async Task<IActionResult> InferirFigura([FromBody] UserQueryRequest request)
    {
        var resultados = await _inferenceEngine.InferirFiguraAsync(request);
        return Ok(resultados);
    }

    [HttpGet("todas")]
    [ProducesResponseType(typeof(IEnumerable<FiguraRaw>), StatusCodes.Status200OK)]
    public async Task<IActionResult> ObtenerTodas()
    {
        var figuras = await _repository.ObtenerTodasAsync();
        return Ok(figuras);
    }

    [HttpGet("paginado")]
    [ProducesResponseType(typeof(IEnumerable<FiguraRaw>), StatusCodes.Status200OK)]
    public async Task<IActionResult> ObtenerPaginado([FromQuery] int pagina = 1, [FromQuery] int registros = 10)
    {
        var figuras = await _repository.ObtenerPaginadoAsync(pagina, registros);
        return Ok(figuras);
    }
}