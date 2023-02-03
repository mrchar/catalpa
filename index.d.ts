declare module parser {
    import {Board} from "./packages/catalpa"

    export function parse(script: string): Board
}
