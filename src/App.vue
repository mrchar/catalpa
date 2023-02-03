<script lang="ts" setup>
import {defineAsyncComponent, ref} from "vue"
import {useDark} from "@vueuse/core"

const CatalpaEditor = defineAsyncComponent(() => import("./components/CatalpaEditor.vue"))
const CatalpaViewer = defineAsyncComponent(() => import("./components/CatalpaViewer.vue"))

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
    <catalpa-editor v-model="script"/>
    <catalpa-viewer :value="script"/>
  </div>
</template>

<style scoped>
div.container {
  display: flex;
  gap: 1em;
}
</style>
