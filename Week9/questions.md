1. Your shell forks multiple child processes when executing piped commands. How does your implementation ensure that all child processes complete before the shell continues accepting user input? What would happen if you forgot to call waitpid() on all child processes?

_My implementation ensures that all child processes are complete befroe the shell continues accepting new input by using the waitpid() function inside a loop after forking all of the child processes. If I forgot to waitpid on all child processes, the shell wouldn't wait for the pipeline to finish before accepting new input._

2. The dup2() function is used to redirect input and output file descriptors. Explain why it is necessary to close unused pipe ends after calling dup2(). What could go wrong if you leave pipes open?

_It is necessary to close unused pipes because leaving them open can waste memory and file descriptors. If you leave it open, it can lead to unexpected behavior when running the code along with other pipes._

3. Your shell recognizes built-in commands (cd, exit, dragon). Unlike external commands, built-in commands do not require execvp(). Why is cd implemented as a built-in rather than an external command? What challenges would arise if cd were implemented as an external process?

_cd is implemented as a built-in function because changing the directory impacts the shell's process. If cd were an external command it would change the directory only for the child process, making it inefficeint for the user._

4. Currently, your shell supports a fixed number of piped commands (CMD_MAX). How would you modify your implementation to allow an arbitrary number of piped commands while still handling memory allocation efficiently? What trade-offs would you need to consider?

_If I didn't use a fixed number of piped commands, and allowed for an unknown number of piped commands, I would dynamically allocate memory for pipes and pids based on the number of commands. I would need to consider potential allocation failures to reallocate memory and add proper checks to handle unexpected behavior._