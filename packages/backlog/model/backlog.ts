import {label} from "./label"
import {Task} from "./task"

export interface Backlog {
    title?: string
    tags?: label[]
    members?: label[]
    phases?: label[]
    tasks?: Task[]
}