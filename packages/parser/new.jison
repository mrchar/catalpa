/* description: A simple markup language for Backlog. */

/* lexical grammar */
%lex

%%
\n/\n                   { /* 跳过空白行 */ }
\s+/\n                  { /* 跳过行尾空白字符 */ }
\-{3}                   { return 'triple_dash'; }
":"                     { return 'colon'; }
","                     { return 'comma'; }
" -> "                  { return 'alias'; }
" alias "               { return 'alias'; }
[#@!^$]                 { return 'symbol'; }
"["                     { return 'period_prefix'; }
"]"                     { return 'period_suffix'; }
" "+                    { return 'spaces'; }
[ \t]+                  { return 'blank'; }
[^\s:,\[\]]+            { return 'non_blank'; } /* TODO 不应该解释为non_blank，应该是不包含起义的起始符号，用于包含一个描述 */
\n                      { return 'newline'; }
<<EOF>>                 { return 'eof'; }

/lex

/* operator associations and precedence */

%left eof
%left newline
%left spaces
%start board

%% /* language grammar */

board
    : final_line
    { return {}; }
    | foreword final_line
    { return {...$foreword}; }
    | task_list final_line
    { return {tasks: $task_list}; }
    | foreword newline task_list final_line
    { return {...$foreword, tasks: $task_list}; }
    ;

final_line
    : eof
    | spaces eof
    | newline spaces eof
    ;

foreword
    : triple_dash newline triple_dash
    { $$ = {}; }
    | triple_dash newline property_list newline triple_dash
    {
        $$ = {};
        for(const property of $property_list){
            if(property.label ==="title"){
                if(property.content.length > 0){
                    $$.title = property.content[0];
                }
            }else{
                $$[property.label] = property.content;
            }
        }
    }
    ;

property_list
    : property_list newline property
    { $$ = $property_list; $$.push($property); }
    | property
    { $$ = [$property]; }
    ;

property
    : non_blank colon item_list
    { $$ = {label: $non_blank, content: $item_list}; }
    ;

item_list
    : item_list comma item
    { $$ = $item_list; $$.push($item); }
    | item
    { $$ = [$item]; }
    ;

item
    : non_blank
    { $$ = $non_blank; }
    | spaces non_blank
    { $$ = $non_blank; }
    | non_blank alias non_blank
    { $$ = {}; $$[$non_blank1] = $non_blank2; }
    | spaces non_blank alias non_blank
    { $$ = {}; $$[$non_blank1] = $non_blank2; }
    ;

task_list
    : task_list newline task
    { $$ = $task_list; $$.push($task); }
    | task
    { $$ = [$task]; }
    ;

task
    : task_content
    { $$ = $task_content; }
    | task_content newline subtask_list
    { $$ = $task_content; $$.children = $subtask_list }
    ;

subtask_list
    : subtask_list newline subtask
    { $$ = $subtask_list; $$.push($subtask) }
    | subtask
    { $$ = [$subtask]; }
    ;

subtask
    : spaces task_content
    { $$ = $task_content; }
    ;

task_content
    : description
    { $$ = {description: $description}; }
    | description label_list
    { $$ = {description: $description, ...$label_list}; }
    ;

label_list
    : label_list spaces label
    { $$ = $label_list; $$.push($label) }
    | spaces label
    { $$ = [$label] }
    ;

label
    : non_blank colon description
    { $$ = {key: $non_blank, value: $description}; }
    | colon description
    { $$ = {key: $colon, value: $description}; }
    | symbol description
    { $$ = {key: $symbol, value: $description}; }
    | period
    { $$ = $period; }
    ;

period
    : period_prefix description comma description period_suffix
    { $$ = {begin: $description1, end: $description2}; }
    | period_prefix description comma spaces description period_suffix
    { $$ = {begin: $description1, end: $description2}; }
    ;

description
    : non_blank
    { $$ = $non_blank; }
    | description blank non_blank
    { $$ = $description+$blank+$non_blank; }
    ;