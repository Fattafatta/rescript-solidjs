import { defineConfig } from "vite";
import createReScriptPlugin from "@jihchi/vite-plugin-rescript";
import babel from "vite-plugin-babel";

export default defineConfig({
  plugins: [
    createReScriptPlugin(),
    babel({
      babelConfig: {
        plugins: ["@fattafatta/babel-plugin-rescript-react-to-jsx"],
        presets: ["solid"],
      },
    }),
  ],
});
