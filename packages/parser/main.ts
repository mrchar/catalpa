import fs from "fs"
import jison from "jison"
import bnf from "./grammar.jison?raw"

const parser = new jison.Parser(bnf)

export function parse(path: string) {
    const backlog = fs.readFileSync(path)
    return parser.parse(backlog)
}
