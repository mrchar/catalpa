<script lang="ts" setup>
import {computed} from "vue"
import parser from "../../packages/parser/index.jison"
import {Board} from "../../packages/catalpa"

const props = defineProps({value: {type: String, required: true}})

const script = computed(() => {
  return props.value
})

const board = computed<Board>(() => {
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
      <el-descriptions :title="board.title" :column="1">
        <el-descriptions-item label="标签">
          {{
            board.tags
            && board.tags
                .map(item => typeof item === "string" ? item : item.name)
                .toString()
          }}
        </el-descriptions-item>
        <el-descriptions-item label="成员">
          {{
            board.members
            && board.members
                .map(item => typeof item === "string" ? item : item.name)
                .toString()
          }}
        </el-descriptions-item>
        <el-descriptions-item label="阶段">{{
            board.phases
            && board.phases
                .map(item => typeof item === "string" ? item : item.name)
                .toString()
          }}
        </el-descriptions-item>
      </el-descriptions>
      <el-table border stripe :data="board.tasks" row-key="description" default-expand-all height="100%">
        <el-table-column label="名称" prop="description" show-overflow-tooltip/>
        <el-table-column label="标签">
          <template v-slot="{row}">
            <el-tag v-for="tag in row.tags">
              {{ tag.value || tag }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="成员">
          <template v-slot="{row}">
            <el-tag v-for="member in row.members">
              @{{ member.value || member }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="截止日">
          <template #default="{row}">
            {{ row.ddl && row.ddl.value || row.ddl }}
          </template>
        </el-table-column>
        <el-table-column label="状态">
          <template #default="{row}">
            {{ row.phase && row.phase.value || row.phase }}
          </template>
        </el-table-column>
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