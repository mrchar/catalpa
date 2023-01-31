import {Backlog} from "./model/backlog"
import parser from "../parser/index.jison"
import {Task} from "./model/task"


export class ParseStringifier {
    parse(script: string): Backlog {
        return parser.parse(script)
    }

    stringify(backlog: Backlog): string {
        return stringify(backlog)
    }
}

export const defaults = new ParseStringifier()

export default defaults

function stringify(backlog: Backlog): string {
    let script = ""
    // 序列化前言
    script = stringifyForeword(backlog)

    // 序列化任务列表
    script += stringifyTasks(backlog.tasks)

    return script
}

function stringifyForeword(backlog: Backlog): string {
    let script = ""
    if (backlog.title) {
        script = "title:" + backlog.title + "\n"
    }
    if (backlog.tags) {
        script += "tags:" + backlog.tags.join(",") + "\n"
    }
    if (backlog.members) {
        script += "members:" + backlog.members.join(",") + "\n"
    }
    if (backlog.phases) {
        script += "phases:" + backlog.phases.join(",") + "\n"
    }
    if (script) {
        script = "---\n" + script + "---\n"
    }

    return script
}

function stringifyTasks(tasks: Task[] | undefined): string {
    let script = ""
    if (!tasks) {
        return script
    }

    // 查找最长的任务描述
    const descriptionLength = findMaxDescriptionLength(tasks)

    // 执行序列化
    return doStringifyTasks(tasks, descriptionLength)
}

function doStringifyTasks(tasks: Task[], descriptionLength: number): string {
    let script = ""

    // 遍历所有任务
    for (const task of tasks) {
        let description = task.description
        if (task.depth) {
            description = description.padStart(task.depth, " ")
        }
        let taskScript = description.padEnd(descriptionLength, " ")

        if (task.tags) {
            for (const tag of task.tags) {
                taskScript += ` #${tag}`
            }
        }
        if (task.members) {
            for (const member of task.members) {
                taskScript += ` @${member}`
            }
        }
        if (task.ddl) {
            taskScript += ` !${task.ddl}`
        }

        if (task.begin && task.end) {
            taskScript += ` [${task.begin},${task.end}]`
        } else if (task.begin) {
            taskScript += ` ^${task.begin}`
        } else if (task.end) {
            taskScript += ` $${task.end}`
        }

        taskScript += "\n"

        // 处理子元素
        if (task.children) {
            script += doStringifyTasks(task.children, descriptionLength)
        }

        script += taskScript
    }

    return script
}

function findMaxDescriptionLength(tasks: Task[]): number {
    let maxDescriptionLength = 0

    for (const task of tasks) {
        // 获取描述长度
        let descriptionLength = task.description.length
        if (task.depth) {
            descriptionLength += task.depth
        }

        // 如果描述长度大于之前的最大值，修改最大值
        if (descriptionLength > maxDescriptionLength) {
            maxDescriptionLength = descriptionLength
        }

        // 遍历成员
        if (task.children) {
            const childrenMaxDescLength = findMaxDescriptionLength(task.children)
            if (childrenMaxDescLength > maxDescriptionLength) {
                maxDescriptionLength = childrenMaxDescLength
            }
        }
    }

    return maxDescriptionLength
}







