/* description: A simple markup language for Backlog. */

/* lexical grammar */
%lex

%%
[ \t]+                {return 'SPACES';}
[^\s]+                {return 'NON_SPACES';}
\n                    {return 'EOL';}
<<EOF>>               {return 'EOF';}

/lex

/* operator associations and precedence */

%% /* language grammar */

backlog
    : EOF
    { return {tasks:[]};}
    | task_list
    { return {tasks:$task_list}; }
    | task_list blank
    { return {tasks:$task_list}; }
    ;

task_list
    : task_list task
    { $$ = $task_list; $$.push($task);}
    | task
    { $$ = [$task];}
    ;

task
    : task_description EOL
    { $$ = {description: $task_description}; }
    | task_description EOF
    { $$ = {description: $task_description}; }
    | task_description EOL EOF
    { $$ = {description: $task_description}; }
    | task_description EOL sub_task_list
    {
        $$ = {description: $task_description, children: $sub_task_list};
        /* TODO: 排序 */
    }
    ;

sub_task_list
    : sub_task_list sub_task
    { $$ = $sub_task_list; $$.push($sub_task); }
    | sub_task
    { $$ = [$sub_task];}
    ;

sub_task
    : SPACES task_description EOL
    { $$ = {description: $task_description, depth: $SPACES.length}; }
    | SPACES task_description EOF
    { $$ = {description: $task_description, depth: $SPACES.length}; }
    | SPACES task_description EOL EOF
    { $$ = {description: $task_description, depth: $SPACES.length}; }
    ;

task_description
    : NON_SPACES
    { $$ = $NON_SPACES; }
    | NON_SPACES SPACES NON_SPACES
    { $$ =  $1+$2+$3}
    ;