import {Label} from "./label"

export interface backlog {
    title?: string
    tags?: string[] | Label[]
    members?: string[] | Label[]
    phases?: string[] | Label[]
    tasks: string[] | Label[]
}