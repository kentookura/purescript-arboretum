import { defineConfig } from "vite";
import toplevelAwait from "vite-plugin-top-level-await";

export default defineConfig({
  plugins: [toplevelAwait()],
  build: {
    target: "esnext",
  },
});
