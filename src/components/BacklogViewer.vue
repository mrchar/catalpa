<script lang="ts" setup>
import {defineProps} from "vue"

const {data} = defineProps({data: {type: String, required: true}})

const backlog = JSON.parse(data)

</script>
<template>
  <div>
    <el-descriptions :title="backlog.title" :column="1">
      <el-descriptions-item label="标签">{{ backlog.tags.toString() }}</el-descriptions-item>
      <el-descriptions-item label="成员">{{ backlog.members.toString() }}</el-descriptions-item>
      <el-descriptions-item label="阶段">{{ backlog.phases.toString() }}</el-descriptions-item>
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
</template>