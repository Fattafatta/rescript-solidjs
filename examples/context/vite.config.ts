import { defineConfig } from "vite";
import createReScriptPlugin from "@jihchi/vite-plugin-rescript";
import babel from "vite-plugin-babel";

export default defineConfig({
  plugins: [
    createReScriptPlugin(),
    babel({
      babelConfig: {
        presets: ["@fattafatta/babel-preset-rescript-solidjs"],
      },
    }),
  ],
});
