import {defineConfig} from "vite"
import jison from "./packages/jison"
import vue from "@vitejs/plugin-vue"

// https://vitejs.dev/config/
export default defineConfig({
    resolve: {
        extensions: [".jison", ".js", ".ts", ".json"],
    },
    plugins: [vue(), jison()],
    build: {
        lib: {
            entry: "./packages/parser/index.jison",
            name: "BacklogParser",
            fileName: "backlog-parser",
        },
    },
})
