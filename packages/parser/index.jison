/* description: A simple markup language for Backlog. */

/* lexical grammar */
%lex

%%
.+                    {return 'WORD';}
<<EOF>>               {return 'EOF';}

/lex

/* operator associations and precedence */

%% /* language grammar */

backlog
    : EOF
    { return {tasks:[]};}
    | task_list
    { return {tasks:$task_list}; }
    ;

task_list
    : task_list task
    { $$ = $task_list; $$.push($task)}
    | task
    { $$ = [$task]}
    ;

task
    : task_description EOL
    | task_description EOF
    { $$ = {description: $task_description} }
    ;

task_description
    : WORD
    { $$ = $WORD }
    ;