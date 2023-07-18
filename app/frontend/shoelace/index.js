import { setBasePath } from "@shoelace-style/shoelace/dist/utilities/base-path.js"

const mode = import.meta.env.MODE || "development"

const paths = {
  production: "",
  development: "-dev",
  test: "-test"
}

let rootUrl = `/vite${paths[mode]}`
setBasePath(rootUrl)

