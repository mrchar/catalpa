export interface label {
    name: string // 解析到的标签原文
    alias: string[] // 按照别名定义的倒序，直到查找到显示名称的列表
    displayName: string // 显示名称
}