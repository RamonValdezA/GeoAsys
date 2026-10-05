import { defineConfig } from 'vite';

export default defineConfig({
  clearScreen: false,
  server: {
    port: 1425,
    strictPort: true,
    host: true
  }
});