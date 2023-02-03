/// <reference types="vite/client" />
declare module "*.jison" {
    export function parse(script: string): object
}

declare module "jsonlint/lib/formatter" {
    export interface Formatter {
        formatJson(raw: string, indentChars?: number): string
    }

    export const formatter: Formatter
}

