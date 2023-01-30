/* description: A simple markup language for Backlog. */

%{
const backlog = {};

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
* 对标记列表进行归类处理
*/
function parseLabels(labels){
    const parsed = {}

    for(const label of labels){
        switch(label.key){
            case "tag":
                if(parsed.tags == null) parsed.tags = [];
                parsed.tags.push(label.value);
                break;
            case "member":
                if(parsed.members == null) parsed.members = [];
                parsed.members.push(label.value);
                break;
            case "ddl":
                parsed.ddl = label.value;
                break;
            case "begin":
                parsed.begin = label.value;
                break;
            case "end":
                parsed.end = label.value;
                break;
            case "phase":
                parsed.phase = label.value;
                break;
            case "begin_end":
                if (label.value[0]) parsed.begin = label.value[0];
                if (label.value[1]) parsed.end = label.value[1];
                break;
        }
    }

    return parsed;
}
%}

/* lexical grammar */
%lex

%%
[ \t]+("tag:"|"#")                                              { return 'TAG_LABEL'; }
[ \t]+("member:"|"@")                                           { return 'MEMBER_LABEL'; }
[ \t]+("ddl:"|"!")                                              { return 'DDL_LABEL'; }
[ \t]+("begin:"|"^")                                            { return 'BEGIN_LABEL'; }
[ \t]+("end:"|"$")                                              { return 'END_LABEL'; }
[ \t]+("phase:"|":")                                            { return 'PHASE_LABEL'; }
[ \t]+"["                                                       { return 'BEGIN_END_LEFT_LABEL'; }
"]"                                                             { return 'BEGIN_END_RIGHT_LABEL'; }
[\d\/-]+                                                        { return 'DATE'; }
","                                                             { return 'COMMA'; }
" "+                                                            { return 'INDENT'; }
[ \t]+                                                          { return 'SPACES'; }
[^\s]+                                                          { return 'NON_SPACES'; }
\n                                                              { return 'EOL'; }
<<EOF>>                                                         { return 'EOF'; }

/lex

/* operator associations and precedence */

%start backlog

%% /* language grammar */

backlog
    : EOF
    { return backlog; }
    | task_list
    { backlog.tasks = $task_list; return backlog; }
    ;

task_list
    : task_list task
    { $$ = $task_list; $$.push($task); }
    | task
    { $$ = [$task]; }
    ;

task
    : task_content
    { $$ = $task_content; }
    | task_content sub_task_list
    { $$ = $task_content; $$.children = sortSubTaskList($sub_task_list); }
    ;

sub_task_list
    : sub_task_list sub_task
    { $$ = $sub_task_list; $$.push($sub_task); }
    | sub_task
    { $$ = [$sub_task]; }
    ;

sub_task
    : INDENT task_content
    { $$ = $task_content; $$.depth = $INDENT.length; }
    ;

task_content
    : task_description EOL
    { $$ = {description: $task_description} }
    | task_description EOF
    { $$ = {description: $task_description} }
    | task_description EOL EOF
    { $$ = {description: $task_description} }
    | task_description label_list EOL
    { $$ = {description: $task_description, ...parseLabels($label_list)}; }
    | task_description label_list EOF
    { $$ = {description: $task_description, ...parseLabels($label_list)}; }
    | task_description label_list EOL EOF
    { $$ = {description: $task_description, ...parseLabels($label_list)}; }
    ;

task_description
    : NON_SPACES
    { $$ = $NON_SPACES; /*NON_SPACES 不能只包含[\d\/-]，否则会被识别为DATE*/}
    | NON_SPACES SPACES NON_SPACES
    { $$ =  $1+$2+$3}
    ;

label_list
    : label_list label
    { $$ = $label_list; $$.push($label); }
    | label
    { $$ = [$label]; }
    ;

label
    : tag
    { $$ = {key: "tag", value: $1}; }
    | member
    { $$ = {key: "member", value: $1}; }
    | ddl
    { $$ = {key: "ddl", value: $1}; }
    | begin
    { $$ = {key: "begin", value: $1}; }
    | end
    { $$ = {key: "end", value: $1}; }
    | phase
    { $$ = {key: "phase", value: $1}; }
    | begin_end
    { $$ = {key: "begin_end", value: $1}; }
    ;

tag
    : TAG_LABEL NON_SPACES
    { $$ = $NON_SPACES; }
    | TAG_LABEL NON_SPACES SPACES NON_SPACES
    { $$ =  $2+$3+$4; }
    ;

member
    : MEMBER_LABEL NON_SPACES
    { $$ = $NON_SPACES; }
    | MEMBER_LABEL NON_SPACES SPACES NON_SPACES
    { $$ =  $2+$3+$4; }
    ;

ddl
    : DDL_LABEL DATE
    { $$ = $DATE; }
    ;

begin
    : BEGIN_LABEL DATE
    { $$ = $DATE; }
    ;

end
    : END_LABEL DATE
    { $$ = $DATE; }
    ;

phase
    : PHASE_LABEL NON_SPACES
    { $$ = $NON_SPACES; }
    | PHASE_LABEL NON_SPACES SPACES NON_SPACES
    { $$ =  $2+$3+$4; }
    ;

begin_end
    : BEGIN_END_LEFT_LABEL DATE BEGIN_END_RIGHT_LABEL
    { $$ = [$DATE]; }
    | BEGIN_END_LEFT_LABEL DATE COMMA BEGIN_END_RIGHT_LABEL
    { $$ = [$DATE]; }
    | BEGIN_END_LEFT_LABEL DATE COMMA SPACES BEGIN_END_RIGHT_LABEL
    { $$ = [$DATE]; }
    | BEGIN_END_LEFT_LABEL DATE COMMA DATE BEGIN_END_RIGHT_LABEL
    { $$ = [$DATE1, $DATE2]; }
    | BEGIN_END_LEFT_LABEL DATE COMMA SPACES DATE BEGIN_END_RIGHT_LABEL
    { $$ = [$DATE1, $DATE2]; }
    ;