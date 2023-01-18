<script setup lang="ts">
import {computed, ref} from "vue"
import parser from "../../packages/parser/index.jison"

const script = ref<string>("1+1")

const result = computed(() => {
  try {
    return parser.parse(script.value)
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
