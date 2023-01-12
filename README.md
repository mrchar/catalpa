# 待办 backlog

一门用于描述 Backlog 的简易标记语言。

a simple markup language for describe backlog.

## 特性 Features

首先让我来快速了解一下如何使用 backlog 语法描述我们的待办事项。

```backlog
---
title: 团队待办事项
tags: 工作, 游戏, 计划, 执行, 检查, 回顾, 工作 alias Job
members: 小王, 小李, 小周, 小潘, 小潘 alias Tim, All alias 所有人
phases: Plan, Doing, Check, Action, Done, Done alias OK
---
周末组织团队到一个风景优美的地方转转             tag:团建 tag:摄影 member:所有人 ddl:2023/1/15 begin:2023/1/12 phase:Plan
    选择一个合适的目的地                        #计划 @小王 !2023/1/12 <2023/1/12, 2023/1/12> :Done
    计划出行的方式和路线                        #计划 #交通 @小王 !2023/1/13 >2023/1/13 :Doing
    整理出行要带的物品清单                      #计划 @小李 !2023/1/13 :Done
    1. 整理一个可行的时间表 2. 通知所有人      #计划 @小王 !2023/1/13
    行程中                                     #执行 @小周 !2023/1/15
    返回后整理游玩的照片并分享给团队             #回顾 @Tim  !2023/1/20
```

### 组成

backlog 语法按行解析， 每解析一行创建一条 backlog 项目，每个项目由项目描述和附加标记组成。
当解析到第一个附加标记的时候，说明项目描述已经结束，并且项目描述会剥离收尾的空白字符。
附加标记的基本语法为`标记名称:标记内容`，使用`:`连接标记的类型标识和标记内容。当解析到下一个标记的时候，标识上一个标记内容已经结束，并且会剥离标记内容的首位空白字符。
另外，一些常见的附加标记支持使用简写，例如`tag:`可以简写为`#`，`member:`可以简写为`@`，这些符号都是在其他领域广泛应用的，继续不需要解释也可以被新手理解。

### 缩进

backlog 语法使用缩进标识各项之间的层级关系，解析 backlog 项目时，将计算当前项目的缩进字符数，如果缩进数为 0，则当前项目是一条根项目，如果缩进数不为 0，当前项目将属于上方遇到的第 1 个缩进数小于当前项目数的记录。
为了方便控制缩进的外观，制表符的缩进数为 2,空格符的缩进数为 1。

### 附加标记

附加标记以空白字符进行分割，如果你的标记内容中包含标记关键字或者缩写，那么在关键字或者缩写前面不要有紧邻着的空白字符，因为这样会解析错误。

| 关键字 | 缩写 | 解释     |
| ------ | ---- | -------- |
| tag    | #    | 标签     |
| member | @    | 成员     |
| ddl    | !    | 截止日期 |
| begin  | >    | 开始时间 |
| end    | <    | 完成时间 |
| phase  | :    | 当前阶段 |

#### tag

tag 用来对当前 backlog 项目进行标记，你可以通过这些标签对 backlog 项目进行过滤，在未来推出支持 backlog 语法的编辑器后，你可以轻松的时候 tag 隐藏掉不关心的 backlog 项目。

**member**

member 用于标记当前项目的参与者，

如果你在 mail list 中使用 backlog 语法，可以使用 email 地址来标记参与者，例如`@mrchar@qq.com`，如果你在 github 的自述文档中使用 backlog 语法，你可以使用 github 用户名标记参与者, 例如`@mrchar`。

或者你可以在你的系统中对参与者进行解析，例如你可以定义参与者标记的语法为`name|uid`，这样即使在你的系统中用户名是可以重复的，你也可以使用`uid`检索到对应的成员。

**ddl**

ddl 表示项目的截至日期，在编写backlog的时候我们通常不是那么关系开始和结束的时间，反而是更在乎项目的截至日期。

**begin & end**

begin 和 end 分别用于表示项目的开始和结束时间，通常我们不需要标记项目的开始和结束时间，但是如果你特别在乎开始和结束的时间，也可以使用这两个标记明天表示项目的开始和结束时间。

因为开始和结束往往是成对存在的，为了更加方便的表示项目的开始和结束时间，我创建了一个例外的缩写，你可以将开始和结束时间使用尖括号包裹起来。

例如`<2023/1/12, 2023/1/13>`表示项目在2023/1/12日开始，在2023/1/13日结束，当前就算是在项目没有结束之前你也可以这种方式表示开始时间，例如`<2023/1/12, >`表示项目在2023/1/12日开始，但直到现在也没有结束，或者没有人知道他是什么时候结束的。如果你嫌写一个`,`很麻烦，你也可以不写， 但是这样的话，就不要在尖括号中包含任何空白自负了，因为这样会导致解析错误。

**phase**

phase表示现在当前项目处于哪个状态，我们推荐使用`PDCA`生命周期进行标记，一共创建了5个默认值，分别是`Plan`,`Doing`,`Check`,`Action`以及`Done`。这5个标记符都有特殊的含义，无论你是否在前言中声明，都可以使用这5个状态，但是你可以为这5个状态创建别名。

### 前言

backlog 支持前言语法，将对全局有影响的内容在前言中进行标记，例如标题、所有标签、成员、进程等， 这些内容将在后面的 backlog 中用到。

如果前言中的配置是一个列表，则使用`，`分割列表中的各项，通常列表项支持使用`alias`进行重命名，当使用别名的时候，相当于使用了别名对应的原始名称。

如果对一个标记进行多次重命名，则会不断向上追溯，直到找不到更上一层。
例如`tags: A, A alias B, B alias C`, 当你在标签中使用C的时候，就相当于使用的是A。

**title**

title是一个字符串，表示当前backlog列表的标题。

**tags**

tags是一个列表，在当前backlog列表中声明常用的标签，相当于为团队创建一种规范，尽可能的使用前言中声明的标签，而不是自定义一个语义相似的其他标签，在编写backlog时，编辑器可以使用声明的列表提供代码提示和自动补全功能。可以使用alias关键字声明标签的别名，在项目中使用别名，相当于使用了原始的标签。

**members**

members是一个列表，用来声明团队的全部成员，`All`是一个特殊的member标识，不需要声明就可以使用，用来表示members列表中的所有成员。你可以使用`alias`关键字对声明的成员进行重命名，例如`小潘 alias Tim`就是为`小潘`声明了一个别名`Tim`，当你在memmber中使用`Tim`时就相当于使用了`小潘`。

**phases**

phases是一个列表，用来声明backlog项目可以处于的阶段，我们声明了5个默认的阶段，分别是`Plan`,`Doing`,`Check`,`Action`以及`Done`，需要注意的是这5个标记有可能是别名，这主要取决于你使用的解析器。如果这5个标记是别名，那么在解析后，状态将显示为原始的标记，相当于解析器已经声明了5个标记，然后创建了对应的5个表名。

加入解析器默认声明了：
`phases: 🎯,🏃‍♂️,🔎,📦,🏆,🎯 alias Plan, 🏃‍♂️ alias Doing, 🔎 alias Check, 📦 alias Action, 🏆 alias Done`

那么你在使用Plan Doing Check Action Done的时候就会解析为原始的emoji符号。当然你也可以声明自己的标记和别名覆盖解析器缺省的标记。


## 巴科斯范式

TODO