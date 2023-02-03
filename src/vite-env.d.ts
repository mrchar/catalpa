/// <reference types="vite/client" />
declare module "*.jison" {
    import {Board} from "../packages/catalpa"

    export function parse(script: string): Board
}

declare module "jsonlint/lib/formatter" {
    export interface Formatter {
        formatJson(raw: string, indentChars?: number): string
    }

    export const formatter: Formatter
}

