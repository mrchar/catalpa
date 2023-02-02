<script lang="ts" setup>
import {ref} from "vue"
import {useDark} from "@vueuse/core"
import BacklogEditor from "./components/BacklogEditor.vue"
import BacklogViewer from "./components/BacklogViewer.vue"

const isDark = useDark()

const script = ref<string>(`---
title: title
tags: tag1, tag2, tag1 -> tag3, tag2 alias tag4
members: member1, member2, member1 alias name1
phases: phase1, phase2, phase1 alias phase3
labels: label1, label2
---
main_task1                 tag:tag1 tag:tag2 member:all ddl:2023/1/15 begin:2023/1/12 phase:phase1
    sub_task1              #tag1 @member1 !2023/1/12 [2023/1/12, 2023/1/12] :phase2
    sub_task2              #tag1 #tag2 @member2 !2023/1/13 ^2023/1/13 :phase3
    sub_task3              #tag1 @member1 !2023/1/13 :phase1
    sub_task4              #tag1 @member1 !2023/1/13
        1.sub_task4_1
        2.sub_task4_2
    sub_task5              #tag2 @zhou !2023/1/15
    sub_task6              #tag2 @Tim !2023/1/20
`)

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
