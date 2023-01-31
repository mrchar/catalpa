import {label} from "./label"

export interface task {
    description: string
    tags: label[] | void
    members: label[] | void
    ddl: Date | void
    begin: Date | void
    end: Date | void
    phase: label | void
    children: task[] | void
}