export interface Board extends Foreword {
    tasks: string[] | Task[]
}

export interface Foreword {
    title?: string
    tags?: Array<Property>
    members?: Array<Property>
    phases?: Array<Property>
    labels?: Array<Property>
}

export type Property = string | PropertyDefinition

export interface PropertyDefinition {
    name: string
    aliases?: string[]
}

export type  Task = string | {
    description: string
    tags?: Label[]
    members?: Label[]
    ddl?: Date
    begin?: Date
    end?: Date
    phase?: Label
    labels?: LabelDefinition[]
    children?: Task[]
}

export type Label = string | LabelDefinition

export interface LabelDefinition {
    type: string // 类型
    key: string // 原始标记
    value: string // 内容
}