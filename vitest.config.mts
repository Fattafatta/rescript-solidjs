/// <reference types="vitest" />
/// <reference types="vite/client" />

import { defineConfig } from "vite";
import createReScriptPlugin from "@jihchi/vite-plugin-rescript";
import babel from "vite-plugin-babel";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    createReScriptPlugin(),
    babel({
      babelConfig: {
        presets: ["@fattafatta/babel-preset-rescript-solidjs"],
      },
    }),
  ],
  test: {
    // deps: {
    //   registerNodeLoader: true,
    //   inline: [/solid-js/],
    // },
    setupFiles: [
      // "node_modules/@testing-library/jest-dom/extend-expect",
      "./tests/setup.ts",
    ],
    transformMode: { web: [/\.[jt]sx?$/] },
    include: ["tests/**/*_test.bs.js"],
    globals: true,
    environment: "jsdom",
  },
  resolve: {
    conditions: ["development", "browser"],
    dedupe: ["solid-js"],
  },
});
