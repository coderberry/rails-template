import { defineConfig } from "vite"
import * as path from "path"
import { viteStaticCopy } from "vite-plugin-static-copy"
import Rails from "vite-plugin-rails"

const mode = process.env.NODE_ENV || "development"

const paths = {
  production: "",
  development: "-dev",
  test: "-test"
}

const vitePath = `public/vite${paths[mode]}/assets`

export default defineConfig({
  plugins: [
    viteStaticCopy({
      targets: [
        {
          src: 'node_modules/@shoelace-style/shoelace/dist/assets',
          dest: vitePath
        }
      ]
    }),
    Rails()
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
