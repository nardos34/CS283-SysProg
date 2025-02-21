#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>
#include "dshlib.h"

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



int exec_local_cmd_loop()
{
    char *cmd_buff;
    int rc = 0;
    cmd_buff_t *cmd = (cmd_buff_t*)malloc(sizeof(cmd_buff_t));
    cmd_buff = (char*)malloc(ARG_MAX);

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
        
        rc = build_cmd_buff(cmd_buff, cmd);
        switch (rc) {
            case ERR_MEMORY:
                return rc;
            case WARN_NO_CMDS:
                printf(CMD_WARN_NO_CMD);
                continue;
            case ERR_TOO_MANY_COMMANDS:
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
    }

    free_cmd_buff(cmd);
    free(cmd_buff);

    return OK;
}