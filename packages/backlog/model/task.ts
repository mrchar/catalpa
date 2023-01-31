import {label} from "./label"

export interface Task {
    description: string
    tags?: label[]
    members?: label[]
    ddl?: Date
    begin?: Date
    end?: Date
    phase?: label
    depth?: number
    children?: Task[]
}