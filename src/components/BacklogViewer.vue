<script lang="ts" setup>
import {computed, defineProps} from "vue"
import parser from "../../packages/parser/index.jison"

const props = defineProps({value: {type: String, required: true}})

const script = computed(() => {
  return props.value
})

const backlog = computed(() => {
  try {
    return parser.parse(script.value)
  } catch (e) {
    return {}
  }
})

</script>
<template>
  <el-card>
    <div class="container">
      <el-descriptions :title="backlog.title" :column="1">
        <el-descriptions-item label="标签">{{ backlog.tags && backlog.tags.toString() }}</el-descriptions-item>
        <el-descriptions-item label="成员">{{ backlog.members && backlog.members.toString() }}</el-descriptions-item>
        <el-descriptions-item label="阶段">{{ backlog.phases && backlog.phases.toString() }}</el-descriptions-item>
      </el-descriptions>
      <el-table border stripe :data="backlog.tasks" row-key="description" default-expand-all height="100%">
        <el-table-column label="名称" prop="description" show-overflow-tooltip/>
        <el-table-column label="标签">
          <template v-slot="{row}">
            <el-tag v-for="tag in row.tags">{{ tag }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="成员">
          <template v-slot="{row}">
            <el-tag v-for="member in row.members">@{{ member }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="截止日" prop="ddl"/>
        <el-table-column label="状态" prop="phase"/>
      </el-table>
    </div>
  </el-card>
</template>

<style scoped>
div.container {
  width: 50em;
  height: 30em;
  display: flex;
  flex-direction: column;
}
</style>