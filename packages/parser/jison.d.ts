declare module "jison" {
    export class Parser {
        constructor(bnf: string)

        parse(backlog: Buffer)
    }
}