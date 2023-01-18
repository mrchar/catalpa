import {defineConfig} from "vite"
import vue from "@vitejs/plugin-vue"

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [vue()],
    build: {
        lib: {
            entry: "./packages/parser/main.ts",
            name: "BacklogParser",
            fileName: "backlog-parser",
        },
    },
})
