import {expect, test} from "vitest"
import parser from "../packages/parser/index.jison"

test("Example", () => {
    const parsed = parser.parse(`---
title: 团队待办事项
tags: 工作, 游戏, 计划, 执行, 检查, 回顾, 工作 alias Job
members: 小王, 小李, 小周, 小潘, 小潘 alias Tim, All alias 所有人
phases: Plan, Doing, Check, Action, Done, Done alias OK
---
计划中:
周末组织团队到一个风景优美的地方转转                 tag:团建 tag:摄影 member:所有人 ddl:2023/1/15 begin:2023/1/12 phase:Plan
    选择一个合适的目的地                          #计划 @小王 !2023/1/12 [2023/1/12, 2023/1/12] :Done
    计划出行的方式和路线                          #计划 #交通 @小王 !2023/1/13 ^2023/1/13 :Doing
    整理出行要带的物品清单                        #计划 @小李 !2023/1/13 :Done
    执行出行时间计划                             #计划 @小王 !2023/1/13
        1. 整理一个可行的时间表
        2. 通知所有人
    行程中                                     #执行 @小周 !2023/1/15
    返回后整理游玩的照片并分享给团队                #回顾 @Tim !2023/1/20
    
已完成:
第一季度绩效报告会议                              #会议 #里程碑 !2023/1/10 :Done  
`)
    expect(parsed).toEqual({
        title: "团队待办事项",
        tags: [
            "工作",
            "游戏",
            "计划",
            "执行",
            "检查",
            "回顾",
            "工作",
        ],
        members: [
            "小王",
            "小李",
            "小周",
            "小潘",
        ],
        phases: [
            "Plan",
            "Doing",
            "Check",
            "Action",
            "Done",
        ],
        tasks: [
            {
                description: "周末组织团队到一个风景优美的地方转转",
                tags: [
                    "团建",
                    "摄影",
                ],
                members: [
                    "所有人",
                ],
                ddl: "2023/1/15",
                begin: "2023/1/12",
                phase: "Plan",
                children: [
                    {
                        description: "选择一个合适的目的地",
                        tags: [
                            "计划",
                        ],
                        members: [
                            "小王",
                        ],
                        ddl: "2023/1/12",
                        begin: "2023/1/12",
                        end: "2023/1/12",
                        phase: "Done",
                        depth: 4,
                    },
                    {
                        description: "计划出行的方式和路线",
                        tags: [
                            "计划",
                            "交通",
                        ],
                        members: [
                            "小王",
                        ],
                        ddl: "2023/1/13",
                        begin: "2023/1/13",
                        phase: "Doing",
                        depth: 4,
                    },
                    {
                        description: "整理出行要带的物品清单",
                        tags: [
                            "计划",
                        ],
                        members: [
                            "小李",
                        ],
                        ddl: "2023/1/13",
                        phase: "Done",
                        depth: 4,
                    },
                    {
                        description: "执行出行时间计划",
                        tags: [
                            "计划",
                        ],
                        members: [
                            "小王",
                        ],
                        ddl: "2023/1/13",
                        depth: 4,
                        children: [
                            {
                                description: "1.整理一个可行的时间表",
                                depth: 8,
                            },
                            {
                                description: "2.通知所有人",
                                depth: 8,
                            },
                        ],
                    },
                    {
                        description: "行程中",
                        tags: [
                            "执行",
                        ],
                        members: [
                            "小周",
                        ],
                        ddl: "2023/1/15",
                        depth: 4,
                    },
                    {
                        description: "返回后整理游玩的照片并分享给团队",
                        tags: [
                            "回顾",
                        ],
                        members: [
                            "Tim",
                        ],
                        ddl: "2023/1/20",
                        depth: 4,
                    },
                ],
            },
            {
                description: "第一季度绩效报告会议",
                tags: [
                    "会议",
                    "里程碑",
                ],
                ddl: "2023/1/10",
                phase: "Done",
            },
        ],
    })
})

