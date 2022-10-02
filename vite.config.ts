import { defineConfig } from "vite";
import * as path from "path";
import RubyPlugin from "vite-plugin-ruby";
import StimulusHMR from "vite-plugin-stimulus-hmr";
import FullReload from "vite-plugin-full-reload";

export default defineConfig({
  plugins: [
    RubyPlugin(),
    StimulusHMR(),
    FullReload(["config/routes.rb", "app/views/**/*"], { delay: 250 }),
  ],
  resolve: {
    alias: [
      {
        find: "@/lib",
        replacement: path.resolve(_dirname, "./app/frontend/components/lib/")
      },
      {
        find: "@/components",
        replacement: path.resolve(__dirname, "./app/frontend/components/")
      },
      {
        find: "@/entrypoints",
        replacement: path.resolve(__dirname, "./app/frontend/entrypoints")
      }
    ]
  },
})