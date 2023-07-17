import { defineConfig } from "vite"
import * as path from "path"
import copy from "rollup-plugin-copy"
import RubyPlugin from "vite-plugin-ruby"
import StimulusHMR from "vite-plugin-stimulus-hmr"
import FullReload from "vite-plugin-full-reload"

const mode = process.env.NODE_ENV || "development"

const paths = {
  production: "",
  development: "-dev",
  test: "-test"
}

const vitePath = `public/vite${paths[mode]}/assets`


export default defineConfig({
  build: {
    rollupOptions: {
      plugins: [
        copy({
          targets: [
            {
              src: path.resolve(__dirname, 'node_modules/@shoelace-style/shoelace/dist/assets/icons'),
              dest: path.resolve(__dirname, vitePath)
            }
          ],
          // https://github.com/vitejs/vite/issues/1231
          hook: 'writeBundle'
        })
      ]

    }
  },
  plugins: [
    RubyPlugin(),
    StimulusHMR(),
    FullReload(["config/routes.rb", "app/views/**/*"], { delay: 250 }),
  ],
  resolve: {
    alias: [
      {
        find: "@/lib",
        replacement: path.resolve(__dirname, "./app/frontend/components/lib/")
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
