import {expect, test} from "vitest"
import parser from "../packages/parser/index.jison"

const task1Description = "task1"
const tag1 = "tag1"
const tag2 = "tag2"
const member1 = "member1"
const member2 = "member2"

const plan = "Plan"
const doing = "Doing"
const check = "check"
const action = "Action"
const Done = "Done"

test("Empty", () => {
    const parsed = parser.parse("")
    expect(parsed).toEqual({})
})


test("Only Description with newline", () => {
    const parsed = parser.parse(`${task1Description}\n`)
    expect(parsed).toEqual({
        tasks: [
            {description: task1Description},
        ],
    })
})

test("Only Description with labels", () => {
    const parsed = parser.parse(`${task1Description} tag:${tag1} #${tag2} member:${member1} @${member2} !2022/1/15 :${plan}\n`)
    expect(parsed).toEqual({
        tasks: [
            {
                description: task1Description,
                tags: [tag1, {
                    key: "#",
                    type: "tag",
                    value: "tag2",
                }],
                members: [member1, {
                    key: "@",
                    type: "member",
                    value: "member2",
                }],
                ddl: {
                    key: "!",
                    type: "ddl",
                    value: "2022/1/15",
                },
                phase: {
                    key: ":",
                    type: "phase",
                    value: "Plan",
                },
            },
        ],
    })
})