/* description: A simple markup language for describe agility board. */

%{
/**
* 解析前言
*/
function parseForeword(propertyList){
    const foreword = {};
    for(const property of propertyList){
        if(property.title ==="title"){
            if(property.content.length > 0){
                foreword.title = property.content[0].name;
            }
        }else{
            const items = property.content.reduce((items, item)=>{
                if(!items[item.name]){
                    items[item.name] = item;
                    return items;
                }

                // 如果没有别名，说明重复定义，直接返回
                if(!item.alias){
                    return items
                }

                if(!items[item.name].aliases) {
                    items[item.name].aliases = [];
                }

                items[item.name].aliases.push(item.alias);
                return items;
            }, {});

            foreword[property.title] = Object.values(items)
                .map(item=>{
                    return item.aliases?item:item.name
                }
            );
        }
    }

    return foreword
}

/**
* 根据子任务的缩进深度，处理子任务的从属关系
*/
function sortSubTaskList(subTaskList){
    const srcTaskList = subTaskList;
    const dstTaskList = [];

    /**
     * 向前查找遇到的第一个深度更小的子任务的地址
     * 如果没有找到，则返回-1
     */
    function findParentIndex(index){
        for(let j = index-1; j >=0; j--){
            if(srcTaskList[index].depth > srcTaskList[j].depth){
                return j;
            }
        }

        return -1;
    }

    for(let i = 0; i < srcTaskList.length; i++){
        if(dstTaskList.length === 0){
            dstTaskList.push(srcTaskList[i]);
        }else{
            const parentIndex = findParentIndex(i);
            if(parentIndex>=0){
                if(srcTaskList[parentIndex].children==null){
                   srcTaskList[parentIndex].children = [];
                }

                srcTaskList[parentIndex].children.push(srcTaskList[i]);
            }else{
                dstTaskList.push(srcTaskList[i]);
            }
        }
    }

    return dstTaskList;
}

/**
* 解析标记列表
*/
function parseLabelList(labelList){
    return labelList.reduce((labels, label)=>{
        switch(label.type){
            case "tag":
                if (!labels.tags) labels.tags = [];
                label = label.key === "tag" ? label.value : label;
                labels.tags.push(label);
                break;
            case "member":
                if (!labels.members) labels.members = [];
                label = label.key === "member" ? label.value : label;
                labels.members.push(label);
                break;
            case "ddl":
            case "begin":
            case "end":
            case "phase":
                labels[label.type] = label.type === label.key ? label.value : label;
                break;
            case "period":
                if(labels.begin || labels.end) {
                    throw new Error("begin or end cannot be used together with period")
                };
                labels.period = {begin:label.begin, end:label.end}
                break;
            default:
                if(!labels.labels) labels.labels = {};
                if(!labels.labels[label.key]) labels.labels[label.key] = [];
                labels.labels[label.key].push(label.value);
        }

        return labels;
    },{});
}

%}

/* lexical grammar */
%lex

%%
\n/\n                                   { /* 跳过空白行 */ }
\s+/\n                                  { /* 跳过行尾空白字符 */ }
\-{3}/\n                                { console.debug('triple_dash'); return 'triple_dash'; }
[^\s\:\,\-\>\#\@\!\^\$\[\]\"]+/\:       { console.debug('title'); return 'title'; }
":"                                     { console.debug('colon'); return 'colon'; }
","                                     { console.debug('comma'); return 'comma'; }
"->"                                    { console.debug('arrow'); return 'arrow'; }
" alias "                               { console.debug('alias'); return 'alias'; }
[#@!^$]/[^\s\:\,\-\>\#\@\!\^\$\[\]\"]+  { console.debug('symbol'); return 'symbol'; }
"["                                     { console.debug('period_prefix'); return 'period_prefix'; }
"]"                                     { console.debug('period_suffix'); return 'period_suffix'; }
" "+                                    { console.debug('spaces'); return 'spaces'; }
[^\s\:\,\-\>\#\@\!\^\$\[\]\"]+          { console.debug('literal'); return 'literal'; }
\".*\"                                  { console.debug('string'); return 'string'}
\n                                      { console.debug('newline'); return 'newline'; }
<<EOF>>                                 { console.debug('eof'); return 'eof'; }

/lex

/* operator associations and precedence */

%left newline
%left spaces
%start expression

%% /* language grammar */

expression
    : board
    { console.log($board); return $board; }
    ;

board
    : final_line
    { $$ = {}; }
    | foreword final_line
    { $$ = {...$foreword}; }
    | task_list final_line
    { $$ = {tasks: $task_list}; }
    | foreword task_list final_line
    { $$ = {...$foreword, tasks: $task_list}; }
    ;

final_line
    : eof
    | spaces eof
    ;

foreword
    : triple_dash newline triple_dash newline
    { $$ = {}; }
    | triple_dash newline property_list triple_dash newline
    { $$ = parseForeword($property_list); }
    ;

property_list
    : property_list property
    { $$ = $property_list; $$.push($property); }
    | property
    { $$ = [$property]; }
    ;

property
    : title colon item_list newline
    {
        $$ = {title: $title, content: $item_list};
    }
    ;

item_list
    : item_list comma item
    { $$ = $item_list; $$.push($item); }
    | item
    { $$ = [$item]; }
    ;

item
    : item_content
    { $$ = $item_content; }
    | spaces item_content
    { $$ = $item_content; }
    ;

item_content
    : description
    { $$ = {name: $description}; }
    | description arrow description
    { $$ = {name: $description1, alias: $description2}; }
    | description spaces arrow description
    { $$ = {name: $description1, alias: $description2}; }
    | description arrow spaces description
    { $$ = {name: $description1, alias: $description2}; }
    | description spaces arrow spaces description
    { $$ = {name: $description1, alias: $description2}; }
    | description alias description
    { $$ = {name: $description1, alias: $description2}; }
    ;

task_list
    : task_list task
    { $$ = $task_list; $$.push($task); }
    | task
    { $$ = [$task]; }
    ;

task
    : task_content newline
    { $$ = $task_content; }
    | task_content newline subtask_list
    { $$ = $task_content; $$.children = sortSubTaskList($subtask_list); }
    ;

subtask_list
    : subtask_list subtask
    { $$ = $subtask_list; $$.push($subtask) }
    | subtask
    { $$ = [$subtask]; }
    ;

subtask
    : spaces task_content newline
    { $$ = $task_content; $$.depth = $spaces.length; }
    ;

task_content
    : description
    { $$ = {description: $description}; }
    | description label_list
    { $$ = {description: $description, ...parseLabelList($label_list)}; }
    ;

label_list
    : label_list spaces label
    { $$ = $label_list; $$.push($label) }
    | spaces label
    { $$ = [$label]; }
    ;

label
    : title colon description
    { $$ = {type: $title, key: $title, value: $description}; }
    | colon description
    { $$ = {type: "phase", key: $colon, value: $description}; }
    | symbol description
    {
        $$ = {key: $symbol, value: $description};
        switch($symbol){
            case "#":
                $$.type = "tag";
                break;
            case "@":
                $$.type = "member";
                break;
            case "!":
                $$.type = "ddl";
                break;
            case "^":
                $$.type = "begin";
                break;
            case "$":
                $$.type = "end";
                break;
        }
    }
    | period
    { $$ = $period; }
    ;

period
    : period_prefix description comma description period_suffix
    { $$ = {type:"period", begin: $description1, end: $description2}; }
    | period_prefix description comma spaces description period_suffix
    { $$ = {type:"period", begin: $description1, end: $description2}; }
    ;

description
    : literal
    { $$ = $literal; }
    | string
    { $$ = $string.substring(1, $string.length-1); }
    ;