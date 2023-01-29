<script setup lang="ts">
import {computed, ref} from "vue"
import parser from "../../packages/parser/index.jison"

const script = ref<string>("task description")

const result = computed(() => {
  try {
    const parsed = parser.parse(script.value)
    return JSON.stringify(parsed)
  } catch (e) {
    return e
  }
})

</script>

<template>
  <form>
    <input v-model="script" type="text"/>
    <input :value="result" type="text" disabled/>
  </form>
</template>

<style scoped>
form {
  display: flex;
  gap: 1em;
}

input {
  width: 100em;
  height: 50em;
}
</style>
