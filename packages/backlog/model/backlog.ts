import {label} from "./label"
import {task} from "./task"

export interface backlog {
    title: string | void
    tags: label[] | void
    members: label[] | void
    phases: label[] | void
    tasks: task[] | void
}