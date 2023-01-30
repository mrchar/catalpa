<script setup lang="ts">
import {computed, ref} from "vue"
import {Codemirror} from "vue-codemirror"
import {json} from "@codemirror/lang-json"
import {oneDark} from "@codemirror/theme-one-dark"
import parser from "../../packages/parser/index.jison"

const script = ref<string>(`---
title:团队待办事项
tags:工作,游戏,计划,执行,检查,回顾,工作
members:小王,小李,小周,小潘
phases:Plan,Doing,Check,Action,Done
---
周末组织团队到一个风景优美的地方转转                 tag:团建 tag:摄影 member:所有人 ddl:2023/1/15 begin:2023/1/12 phase:Plan
    选择一个合适的目的地                          #计划 @小王 !2023/1/12 [2023/1/12,2023/1/12] :Done
    计划出行的方式和路线                          #计划 #交通 @小王 !2023/1/13 ^2023/1/13 :Doing
    整理出行要带的物品清单                        #计划 @小李 !2023/1/13 :Done
    执行出行时间计划                             #计划 @小王 !2023/1/13
        1.整理一个可行的时间表
        2.通知所有人
    行程中                                     #执行 @小周 !2023/1/15
    返回后整理游玩的照片并分享给团队                #回顾 @Tim !2023/1/20
第一季度绩效报告会议                              #会议 #里程碑 !2023/1/10 :Done`)

const error = ref<string>("")

const result = computed(() => {
  try {
    const parsed = parser.parse(script.value)
    return JSON.stringify(parsed, null, 2)
  } catch (e) {
    error.value = (e as Error).message
    return ""
  }
})

</script>

<template>
  <div class="container">
    <codemirror
        v-model="script"
        :autofocus="true"
        :extensions="[oneDark]"
        :style="{width: '80em', height: '30em'}"
        placeholder="从这里开始编写Backlog..."
    />
    <codemirror
        v-if="result"
        :model-value="result"
        :extensions="[json(),oneDark]"
        :style="{width: '80em', height: '30em'}"
    />
    <codemirror
        v-else
        :model-value="error"
        :extensions="[oneDark]"
        :style="{width: '80em', height: '30em'}"
    />
  </div>
</template>

<style scoped>
div.container {
  display: flex;
  gap: 1em;
}
</style>
