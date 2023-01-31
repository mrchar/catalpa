import stringifier from "../packages/backlog"
import {expect, test} from "vitest"

const title = "Title"
const description = "Description"

test("Empty", () => {
    const script = stringifier.stringify({})
    console.log(script)
    expect(script).toEqual(``)
})


test("Title", () => {
    const script = stringifier.stringify({title: title})
    console.log(script)
    expect(script).toEqual(`---
title:${title}
---
`)
})

test("Task", () => {
    const script = stringifier.stringify({tasks: [{description: description}]})
    console.log(script)
    expect(script).toEqual(`${description}
`)
})