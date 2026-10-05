using GeoAsysApi.Models;
using GeoAsysApi.Repositories;
using static GeoAsys.Models.Dtos;

namespace GeoAsysApi.Services;

public interface IInferenceEngine
{
    Task<IEnumerable<InferenceResult>> InferirFiguraAsync(UserQueryRequest request);
}