import { defineConfig } from "vite";
import solidPlugin from "vite-plugin-solid";
import createReScriptPlugin from "@jihchi/vite-plugin-rescript";

export default defineConfig({
  plugins: [solidPlugin(), createReScriptPlugin()],
  build: {
    target: "esnext",
    polyfillDynamicImport: false,
  },
  publicDir: "public",
});
