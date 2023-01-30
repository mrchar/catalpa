<script lang="ts" setup>
import {useDark} from "@vueuse/core"
import BacklogEditor from "./components/BacklogEditor.vue"

const isDark = useDark()

</script>

<template>
  <div>
    <backlog-editor/>
  </div>
</template>

<style scoped>
</style>
