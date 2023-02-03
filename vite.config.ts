import path from "path"
import {defineConfig} from "vite"
import vue from "@vitejs/plugin-vue"
import jison from "./packages/jison"
import shebang from "rollup-plugin-preserve-shebang"
import AutoImport from "unplugin-auto-import/vite"
import Components from "unplugin-vue-components/vite"
import {ElementPlusResolver} from "unplugin-vue-components/resolvers"

const pathSrc = path.resolve(__dirname, "src")

// https://vitejs.dev/config/
export default defineConfig({
    resolve: {
        extensions: [".jison", ".js", ".ts", ".json"],
    },
    plugins: [
        vue(),
        jison(),
        shebang(), // 因为jslint时命令行程序，需要使用shebang插件处理成commonjs才能引入
        AutoImport({
            resolvers: [ElementPlusResolver()],
            dts: path.resolve(pathSrc, "auto-imports.d.ts"),
        }),
        Components({
            resolvers: [ElementPlusResolver()],
            dts: path.resolve(pathSrc, "components.d.ts"),
        }),
    ],
    build: {
        lib: {
            entry: "./packages/parser/index.jison",
            name: "BacklogParser",
            fileName: "backlog-parser",
        },
    },
})
