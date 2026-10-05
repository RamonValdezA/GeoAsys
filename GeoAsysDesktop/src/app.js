import { initViewport, renderFigure } from "./viewport.js";

const API_URL = "https://localhost:7025/api/Geometry/inferir";

document.addEventListener("DOMContentLoaded", () => {
  
  initViewport("renderCanvasContainer");

  const dimensionSelect = document.getElementById("dimension");
  const group2d = document.querySelectorAll(".group-2d");
  const group3d = document.querySelectorAll(".group-3d");
  const form = document.getElementById("inferenceForm");
  const resultsList = document.getElementById("resultsList");

  dimensionSelect.addEventListener("change", (e) => {
    const is2D = e.target.value === "2";
    group2d.forEach((el) => el.classList.toggle("hidden", !is2D));
    group3d.forEach((el) => el.classList.toggle("hidden", is2D));
  });

  form.addEventListener("submit", async (e) => {
    e.preventDefault();

    const dimension = parseInt(dimensionSelect.value);
    const body = {
      dimension: dimension,
      numeroLados: document.getElementById("numeroLados").value
        ? parseInt(document.getElementById("numeroLados").value)
        : null,
      numeroCaras: document.getElementById("numeroCaras").value
        ? parseInt(document.getElementById("numeroCaras").value)
        : null,
      numeroVertices: document.getElementById("numeroVertices").value
        ? parseInt(document.getElementById("numeroVertices").value)
        : null,
      numeroAristas: document.getElementById("numeroAristas").value
        ? parseInt(document.getElementById("numeroAristas").value)
        : null,
    };

    resultsList.innerHTML =
      '<p class="placeholder">Evaluando reglas del sistema experto...</p>';

    try {
      const response = await fetch(API_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      });

      if (!response.ok) throw new Error("Error en la solicitud a la API.");

      const resultados = await response.json();
      displayResults(resultados);
    } catch (err) {
      resultsList.innerHTML = `<p class="placeholder" style="color: #f44336;">Error de conexión con la API: ${err.message}</p>`;
    }
  });

  function displayResults(data) {
    resultsList.innerHTML = "";

    if (!data || data.length === 0) {
      resultsList.innerHTML =
        '<p class="placeholder">No se encontraron figuras que coincidan con las características introducidas.</p>';
      return;
    }

    renderFigure(data[0].nombre, data[0].dimension);

    data.forEach((item, index) => {
      const div = document.createElement("div");
      div.className = "result-item";
      div.innerHTML = 
      `<div class="result-title">
          <span>${index + 1}. ${item.nombre}</span>
          <span class="confidence">${item.coincidenciaPorcentaje}% Certeza</span>
        </div>
        <div class="result-explanation">${item.explicacion}</div>`;
      div.addEventListener("click", () => {
        renderFigure(item.nombre, item.dimension);
      });

      resultsList.appendChild(div);
    });
  }
});
