<script lang="ts" setup>
import {useDark} from "@vueuse/core"
import BacklogEditor from "./components/BacklogEditor.vue"
import BacklogViewer from "./components/BacklogViewer.vue"
import {ref} from "vue"

const isDark = useDark()

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

</script>

<template>
  <div class="container">
    <backlog-editor v-model="script"/>
    <backlog-viewer :value="script"/>
  </div>
</template>

<style>
.el-tabs {
  border-radius: var(--el-border-radius-base);
}

.el-tabs__header {
  border-top-left-radius: var(--el-border-radius-base);
  border-top-right-radius: var(--el-border-radius-base);
}

.el-tabs__item#tab-0 {
  border-top-left-radius: var(--el-border-radius-base);
}

.el-tabs.is-always-shadow {
  box-shadow: var(--el-box-shadow-light);
}
</style>

<style scoped>
div.container {
  display: flex;
  gap: 1em;
}
</style>
