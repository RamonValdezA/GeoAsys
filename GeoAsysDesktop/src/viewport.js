import * as THREE from "three";

let scene, camera, renderer, currentMesh;

export function initViewport(containerId) {
  const container = document.getElementById(containerId);

  scene = new THREE.Scene();
  scene.background = new THREE.Color(0x0a0a0a);

  camera = new THREE.PerspectiveCamera(
    45,
    container.clientWidth / container.clientHeight,
    0.1,
    1000,
  );
  camera.position.set(0, 2, 5);

  renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setSize(container.clientWidth, container.clientHeight);
  container.appendChild(renderer.domElement);

  // Iluminación
  const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
  scene.add(ambientLight);

  const dirLight = new THREE.DirectionalLight(0x00bcd4, 1.2);
  dirLight.position.set(5, 10, 7);
  scene.add(dirLight);

  // Malla / Piso de referencia
  const gridHelper = new THREE.GridHelper(10, 10, 0x333333, 0x222222);
  scene.add(gridHelper);

  // Bucle de animación (Rotación del objeto)
  function animate() {
    requestAnimationFrame(animate);
    if (currentMesh) {
      currentMesh.rotation.y += 0.01;
      currentMesh.rotation.x += 0.005;
    }
    renderer.render(scene, camera);
  }
  animate();

  // Ajuste en cambio de tamaño de ventana
  window.addEventListener("resize", () => {
    camera.aspect = container.clientWidth / container.clientHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(container.clientWidth, container.clientHeight);
  });
}

export function renderFigure(figureName, dimension) {
  if (currentMesh) scene.remove(currentMesh);

  let geometry;
  const material = new THREE.MeshStandardMaterial({
    color: 0x00bcd4,
    wireframe: false,
    roughness: 0.3,
    metalness: 0.2,
  });

  const nameLower = figureName.toLowerCase();

  // Generación dinámica de la geometría según el nombre deducido
  if (dimension.includes("3D")) {
    if (nameLower.includes("cubo") || nameLower.includes("hexaedro")) {
      geometry = new THREE.BoxGeometry(1.5, 1.5, 1.5);
    } else if (nameLower.includes("tetraedro")) {
      geometry = new THREE.TetrahedronGeometry(1.5);
    } else if (nameLower.includes("octaedro")) {
      geometry = new THREE.OctahedronGeometry(1.5);
    } else if (nameLower.includes("dodecaedro")) {
      geometry = new THREE.DodecahedronGeometry(1.5);
    } else if (nameLower.includes("icosaedro")) {
      geometry = new THREE.IcosahedronGeometry(1.5);
    } else if (nameLower.includes("esfera")) {
      geometry = new THREE.SphereGeometry(1.2, 32, 32);
    } else if (nameLower.includes("cilindro")) {
      geometry = new THREE.CylinderGeometry(1, 1, 2, 32);
    } else if (nameLower.includes("cono")) {
      geometry = new THREE.ConeGeometry(1.2, 2, 32);
    } else if (
      nameLower.includes("pirámide") ||
      nameLower.includes("piramide")
    ) {
      geometry = new THREE.ConeGeometry(1.5, 2, 4); // Pirámide cuadrangular
    } else {
      geometry = new THREE.BoxGeometry(1.5, 1.5, 1.5); // Por defecto
    }
  } else {
    // Figuras 2D (Renderizadas como formas planas en 3D)
    if (nameLower.includes("triángulo") || nameLower.includes("triangulo")) {
      geometry = new THREE.CircleGeometry(1.5, 3);
    } else if (
      nameLower.includes("cuadrado") ||
      nameLower.includes("rectángulo") ||
      nameLower.includes("rectangulo")
    ) {
      geometry = new THREE.PlaneGeometry(2, 1.5);
    } else if (
      nameLower.includes("pentágono") ||
      nameLower.includes("pentagono")
    ) {
      geometry = new THREE.CircleGeometry(1.5, 5);
    } else if (
      nameLower.includes("hexágono") ||
      nameLower.includes("hexagono")
    ) {
      geometry = new THREE.CircleGeometry(1.5, 6);
    } else if (nameLower.includes("círculo") || nameLower.includes("circulo")) {
      geometry = new THREE.CircleGeometry(1.5, 32);
    } else {
      geometry = new THREE.CircleGeometry(1.5, 5);
    }
    material.side = THREE.DoubleSide;
  }

  // Crear objeto y agregar bordes de alambre para destacar la geometría
  currentMesh = new THREE.Group();

  const mainMesh = new THREE.Mesh(geometry, material);
  const wireframeGeometry = new THREE.WireframeGeometry(geometry);
  const wireframeMaterial = new THREE.LineBasicMaterial({
    color: 0xffffff,
    linewidth: 2,
  });
  const wireframe = new THREE.LineSegments(
    wireframeGeometry,
    wireframeMaterial,
  );

  currentMesh.add(mainMesh);
  currentMesh.add(wireframe);
  currentMesh.position.set(0, 1, 0);

  scene.add(currentMesh);
}
