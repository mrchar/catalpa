<script setup lang="ts">
import {computed, ref} from "vue"
import {Codemirror} from "vue-codemirror"
import {json} from "@codemirror/lang-json"
import {oneDark} from "@codemirror/theme-one-dark"
import parser from "../../packages/parser/index.jison"

const script = ref<string>("")

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
