/* description: A simple markup language for Backlog. */

/* lexical grammar */
%lex

%%
[ \t]+"tag:"          {return 'TAG_LABEL';}
[ \t]+"#"             {return 'TAG_LABEL';}
[ \t]+"member:"       {return 'MEMBER_LABEL';}
[ \t]+"@"             {return 'MEMBER_LABEL';}
[ \t]+"ddl:"          {return 'DDL_LABEL';}
[ \t]+"begin:"        {return 'BEGIN_LABEL';}
[ \t]+">"             {return 'BEGIN_LABEL';}
[ \t]+"end:"          {return 'END_LABEL';}
[ \t]+"<"             {return 'END_LABEL';}
[ \t]+"phase:"        {return 'PHASE_LABEL';}
[ \t]+":"             {return 'PHASE_LABEL';}
[ \t]+                {return 'SPACES';}
[^\s]+                {return 'NON_SPACES';}
\n                    {return 'EOL';}
<<EOF>>               {return 'EOF';}

/lex

/* operator associations and precedence */

%right SPACES

%% /* language grammar */

backlog
    : EOF
    { return {tasks:[]};}
    | task_list
    { return {tasks:$task_list}; }
    ;

task_list
    : task_list task
    { $$ = $task_list; $$.push($task);}
    | task
    { $$ = [$task];}
    ;

task
    : task_content
    { $$ = $1; }
    | task_content EOL sub_task_list
    {
        const srcTaskList = $sub_task_list;
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
        $$ = {...$task_description, children: dstTaskList};
    }
    ;

sub_task_list
    : sub_task_list sub_task
    { $$ = $sub_task_list; $$.push($sub_task); }
    | sub_task
    { $$ = [$sub_task];}
    ;

sub_task
    : SPACES task_content
    { $$ = $1 }
    ;

task_content
    : task_description EOL
    { $$ = {description: $task_description} }
    | task_description EOF
    { $$ = {description: $task_description} }
    | task_description EOL EOF
    { $$ = {description: $task_description} }
    | task_description label_list EOL
    {
        $$ = {description: $task_description};
        for(const label of $label_list){
            switch(label.key){
                case "tag":
                    if($$.tags == null) $$.tags = [];
                    $$.tags.push(label.value);
                    break;
                case "member":
                    if($$.members == null) $$.members = [];
                    $$.members.push(label.value);
                    break;
                case "ddl":
                    $$.ddl = label.value;
                    break;
                case "begin":
                    $$.begin = label.value;
                    break;
                case "end":
                    $$.end = label.value;
                    break;
                case "phase":
                    $$.phase = label.value;
                    break;
            }
        }
    }
    | task_description label_list EOF
    {
            $$ = {description: $task_description};
            for(const label of $label_list){
                switch(label.key){
                    case "tag":
                        if($$.tags == null) $$.tags = [];
                        $$.tags.push(label.value);
                        break;
                    case "member":
                        if($$.members == null) $$.members = [];
                        $$.members.push(label.value);
                        break;
                    case "ddl":
                        $$.ddl = label.value;
                        break;
                    case "begin":
                        $$.begin = label.value;
                        break;
                    case "end":
                        $$.end = label.value;
                        break;
                    case "phase":
                        $$.phase = label.value;
                        break;
                }
            }
        }
    | task_description label_list EOL EOF
    {
            $$ = {description: $task_description};
            for(const label of $label_list){
                switch(label.key){
                    case "tag":
                        if($$.tags == null) $$.tags = [];
                        $$.tags.push(label.value);
                        break;
                    case "member":
                        if($$.members == null) $$.members = [];
                        $$.members.push(label.value);
                        break;
                    case "ddl":
                        $$.ddl = label.value;
                        break;
                    case "begin":
                        $$.begin = label.value;
                        break;
                    case "end":
                        $$.end = label.value;
                        break;
                    case "phase":
                        $$.phase = label.value;
                        break;
                }
            }
        }
    ;

task_description
    : NON_SPACES
    { $$ = $NON_SPACES; }
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
    : DDL_LABEL NON_SPACES
    { $$ = $NON_SPACES; }
    | DDL_LABEL NON_SPACES SPACES NON_SPACES
    { $$ =  $2+$3+$4; }
    ;

begin
    : BEGIN_LABEL NON_SPACES
    { $$ = $NON_SPACES; }
    | BEGIN_LABEL NON_SPACES SPACES NON_SPACES
    { $$ =  $2+$3+$4; }
    ;

end
    : END_LABEL NON_SPACES
    { $$ = $NON_SPACES; }
    | END_LABEL NON_SPACES SPACES NON_SPACES
    { $$ =  $2+$3+$4; }
    ;

phase
    : PHASE_LABEL NON_SPACES
    { $$ = $NON_SPACES; }
    | PHASE_LABEL NON_SPACES SPACES NON_SPACES
    { $$ =  $2+$3+$4; }
    ;