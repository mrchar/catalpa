<script setup lang="ts">
import {computed, ref} from "vue"
import {Codemirror} from "vue-codemirror"
import {json} from "@codemirror/lang-json"
import {oneDark} from "@codemirror/theme-one-dark"
import parser from "../../packages/parser/index.jison"

const props = defineProps({
  modelValue: {type: String, default: ""},
})

const emit = defineEmits(["update:modelValue"])

const script = computed({
  get() {
    return props.modelValue
  },
  set(value) {
    emit("update:modelValue", value)
  },
})

const error = ref<string>("")

const result = computed(() => {
  try {
    const parsed = parser.parse(props.modelValue)
    return JSON.stringify(parsed, null, 2)
  } catch (e) {
    error.value = (e as Error).message
    console.error((e as Error).message)
    return ""
  }
})
</script>

<template>
  <div class="container">
    <el-tabs class="is-always-shadow" type="border-card">
      <el-tab-pane label="Script">
        <div class="script_editor_wrapper">
          <codemirror
              v-model:model-value="script"
              :autofocus="true"
              :extensions="[oneDark]"
              :style="{width: '50em', height: '30em'}"
              placeholder="从这里开始编写Backlog..."
          />
        </div>
      </el-tab-pane>
      <el-tab-pane label="Json">
        <codemirror
            :disabled="true"
            :model-value="result"
            :extensions="[json(),oneDark]"
            :style="{width: '50em', height: '30em'}"
        />
      </el-tab-pane>
    </el-tabs>

  </div>
</template>

<style scoped>
div.container {
  display: flex;
  flex-direction: column;
  gap: 1em;
}

div.script_editor_wrapper {
  display: flex;
  flex-direction: column;
  gap: 1em;
}
</style>
