declare module parser {
    import {Board} from "./packages/backlog"

    export function parse(script: string): Board
}
