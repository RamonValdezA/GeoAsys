using GeoAsysApi.Repositories;
using GeoAsysApi.Services;
using Microsoft.OpenApi;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowTauri", policy =>
    {
        policy.WithOrigins("http://localhost:1425", "tauri://localhost", "https://tauri.localhost")
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddScoped<IGeometryRepository, GeometryRepository>();
builder.Services.AddScoped<IInferenceEngine, InferenceEngine>();

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "GEOASYS API",
        Version = "v1"
    });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "GEOASYS API V1");
        c.RoutePrefix = string.Empty; 
    });
}

app.UseHttpsRedirection();
app.UseCors("AllowTauri");
app.UseAuthorization();
app.MapControllers();
app.Run();