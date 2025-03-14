#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>

#include "dshlib.h"



#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>

#include "dshlib.h"

/**** 
 **** FOR REMOTE SHELL USE YOUR SOLUTION FROM SHELL PART 3 HERE
 **** THE MAIN FUNCTION CALLS THIS ONE AS ITS ENTRY POINT TO
 **** EXECUTE THE SHELL LOCALLY
 ****
 */

/*
 * Implement your exec_local_cmd_loop function by building a loop that prompts the 
 * user for input.  Use the SH_PROMPT constant from dshlib.h and then
 * use fgets to accept user input.
 * 
 *      while(1){
 *        printf("%s", SH_PROMPT);
 *        if (fgets(cmd_buff, ARG_MAX, stdin) == NULL){
 *           printf("\n");
 *           break;
 *        }
 *        //remove the trailing \n from cmd_buff
 *        cmd_buff[strcspn(cmd_buff,"\n")] = '\0';
 * 
 *        //IMPLEMENT THE REST OF THE REQUIREMENTS
 *      }
 * 
 *   Also, use the constants in the dshlib.h in this code.  
 *      SH_CMD_MAX              maximum buffer size for user input
 *      EXIT_CMD                constant that terminates the dsh program
 *      SH_PROMPT               the shell prompt
 *      OK                      the command was parsed properly
 *      WARN_NO_CMDS            the user command was empty
 *      ERR_TOO_MANY_COMMANDS   too many pipes used
 *      ERR_MEMORY              dynamic memory management failure
 * 
 *   errors returned
 *      OK                     No error
 *      ERR_MEMORY             Dynamic memory management failure
 *      WARN_NO_CMDS           No commands parsed
 *      ERR_TOO_MANY_COMMANDS  too many pipes used
 *   
 *   console messages
 *      CMD_WARN_NO_CMD        print on WARN_NO_CMDS
 *      CMD_ERR_PIPE_LIMIT     print on ERR_TOO_MANY_COMMANDS
 *      CMD_ERR_EXECUTE        print on execution failure of external command
 * 
 *  Standard Library Functions You Might Want To Consider Using (assignment 1+)
 *      malloc(), free(), strlen(), fgets(), strcspn(), printf()
 * 
 *  Standard Library Functions You Might Want To Consider Using (assignment 2+)
 *      fork(), execvp(), exit(), chdir()
 */
int free_cmd_buff(cmd_buff_t *cmd_buff) {
    if (cmd_buff->_cmd_buffer) {
        free(cmd_buff->_cmd_buffer);
        cmd_buff->_cmd_buffer = NULL;
    }
    free(cmd_buff);
    return OK;
 }


int execute_pipeline(command_list_t *clist) {
    int num_commands = clist->num;
    int num_pipes = num_commands - 1;
    int pipes[num_pipes][2];
    pid_t pids[num_commands];

    if (clist->num > CMD_MAX) {
        return ERR_TOO_MANY_COMMANDS;
    }

    for (int i = 0; i < num_pipes; i++) {
        if (pipe(pipes[i]) == -1) {
            perror("pipe");
            return ERR_EXEC_CMD;
        }
    }

    for (int i = 0; i < num_commands; i++) {
        pids[i] = fork();
        if (pids[i] == -1) {
            return ERR_EXEC_CMD;
        }

        if (pids[i] == 0) {
            if (i > 0) {
                dup2(pipes[i-1][0], STDIN_FILENO);
            }
            if (i < num_commands - 1) {
                dup2(pipes[i][1], STDOUT_FILENO);
            }

            for (int j = 0; j < num_pipes; j++) {
                close(pipes[j][0]);
                close(pipes[j][1]);
            }

            execvp(clist->commands[i].argv[0], clist->commands[i].argv);
            exit(EXIT_FAILURE);
        }
    }

    for (int j = 0; j < num_pipes; j++) {
        close(pipes[j][0]);
        close(pipes[j][1]);
    }

    for (int i = 0; i < num_commands; i++) {
        waitpid(pids[i], NULL, 0);
    }

    return OK;

}

int exec_cmd(cmd_buff_t *cmd) {
    pid_t pid = fork();
    int status;

    if (pid < 0) {
        return ERR_MEMORY;
    } else if (pid == 0) {
        execvp(cmd->argv[0], cmd->argv);
        exit(1);
    } else {
        waitpid(pid, &status, 0);
    }
    return OK;
 }

int build_cmd_buff(char *cmd_line, cmd_buff_t *cmd_buff) {
    cmd_buff->_cmd_buffer = strdup(cmd_line);
    char *copy_of_buff = cmd_buff->_cmd_buffer;
    char argument[ARG_MAX];
    int num_of_args = 0;
    int inside_quote = 0;
    int num_of_char = 0;

    while (*copy_of_buff != '\0') {
        while (*copy_of_buff == ' ' && inside_quote == 0) {
            copy_of_buff++;
        }
        if (*copy_of_buff == '"') {
            inside_quote = 1;
            copy_of_buff++;
            continue;
        } 

        while (*copy_of_buff != '\0' && (*copy_of_buff != ' ' || inside_quote == 1)) {
            if (*copy_of_buff == '"') {
                inside_quote = 0;
                copy_of_buff++;
                continue;
            }

            argument[num_of_char] = *copy_of_buff;
            num_of_char++;
            copy_of_buff++;
        }

        if (num_of_char > 0) {
            argument[num_of_char] = '\0';
            cmd_buff->argv[num_of_args] = strdup(argument);
            num_of_args++;
            num_of_char = 0;
        }
        while (*copy_of_buff == ' ' && inside_quote == 0) {
            copy_of_buff++;
        }
    }

    cmd_buff->argv[num_of_args] = NULL;
    cmd_buff->argc = num_of_args;

    if (cmd_buff->argc > CMD_ARGV_MAX) {
        return ERR_TOO_MANY_COMMANDS;
    }

    if (cmd_buff->argc == 0) {
        return WARN_NO_CMDS;
    }

    return OK;
}

int count_num_of_pipes(char *cmd_buff) {
    char *copy_cmd_buff = cmd_buff;
    int pipe_counter = 1;
    while (*copy_cmd_buff != '\0') {
        if (*copy_cmd_buff == PIPE_CHAR) {
            pipe_counter += 1;
        }
        copy_cmd_buff++;
    }

    return pipe_counter;
}

int handle_command_errors(int rc) {
    switch (rc) {
        case ERR_MEMORY:
            return rc;
        case WARN_NO_CMDS:
            return rc;
        case ERR_TOO_MANY_COMMANDS:
            return rc;
        default:
            return OK;
    }
}

int build_cmd_list(char *cmd_line, command_list_t *clist) {
    char *command_segment;
    int rc;

    clist->num = 0;
    command_segment = strtok(cmd_line, "|");
    while (command_segment != NULL) {
        if (clist->num >= CMD_MAX) {
            return ERR_TOO_MANY_COMMANDS;
        }

        cmd_buff_t *cmd_buff = malloc(sizeof(cmd_buff_t));
        rc = build_cmd_buff(command_segment, cmd_buff);

        if (handle_command_errors(rc) != OK) {
            free(cmd_buff);
            return rc;
        }

        clist->commands[clist->num] = *cmd_buff;
        clist->num++;


        command_segment = strtok(NULL, "|");
    }

    return OK;
}


int exec_local_cmd_loop() {
    char *cmd_buff = (char*)malloc(ARG_MAX);
    int rc = 0;
    cmd_buff_t *cmd = (cmd_buff_t*)malloc(sizeof(cmd_buff_t));

    while(1){
        printf("%s", SH_PROMPT);
        if (fgets(cmd_buff, ARG_MAX, stdin) == NULL){
            printf("\n");
            break;
        }
        cmd_buff[strcspn(cmd_buff,"\n")] = '\0';
        
        if (cmd_buff[0] == '\0') {
            continue;
        }
        
        int pipe_counter = count_num_of_pipes(cmd_buff);

        if (pipe_counter == 1) {
            rc = build_cmd_buff(cmd_buff, cmd);
            if (handle_command_errors(rc)) {
                continue;
            }
            if (strcmp(cmd->argv[0], "cd") == 0) {
                if (cmd->argc == 1) {
                    continue;
                }
            }
            if (strcmp(cmd->argv[0], EXIT_CMD) == 0) {
                return OK_EXIT;
            }
            exec_cmd(cmd);

        } else {
            command_list_t *cmd_list = malloc(sizeof(command_list_t));
            cmd_list->num = 0;

            rc = build_cmd_list(cmd_buff, cmd_list);

            execute_pipeline(cmd_list);

        }

 
    }

    free_cmd_buff(cmd);
    free(cmd_buff);

    return OK;
}