1. Can you think of why we use `fork/execvp` instead of just calling `execvp` directly? What value do you think the `fork` provides?

    > **Answer**:  _We do this because fork allows us to run multiple child processes at the same time. If we called execvp() directly, we would losse the current process of the original program._

2. What happens if the fork() system call fails? How does your implementation handle this scenario?

    > **Answer**:  _When the fork() system call fails it returns -1, meaning that a new process couldn't be created. My implementation handles this by exiting out out of the and returning that the command did not work._

3. How does execvp() find the command to execute? What system environment variable plays a role in this process?

    > **Answer**:  _The execvp() finds the command to execute by checking the directories listed in the "PATH" environment variable._

4. What is the purpose of calling wait() in the parent process after forking? What would happen if we didn’t call it?

    > **Answer**:  _The wait() system call in the parent process after forking pauses the parent process until one of its child processes terminates. If we didn't call this, the child process would remain in the system which could cause performance issues._

5. In the referenced demo code we used WEXITSTATUS(). What information does this provide, and why is it important?

    > **Answer**:  _The WEXITSTATUS() provides information about the exit status of the child process. This let's us know if this was a successful process._

6. Describe how your implementation of build_cmd_buff() handles quoted arguments. Why is this necessary?

    > **Answer**:  _It handles quoted arguments as one singular argument. This is important when we are using commands like echo because we don't want to strip the leading spaces when we want to process the system call._

7. What changes did you make to your parsing logic compared to the previous assignment? Were there any unexpected challenges in refactoring your old code?

    > **Answer**:  _As for parsing logic I used strtok_r() for both part 1 and part 2 of the Drexel Shell project but it different ways. For part 1 I used it to seperate each pipe, but for part 2 I used it to separate each command and argument. I was a little confused about how to properly handle different arguments like ones that had quotes and ones that didn't._

8. For this quesiton, you need to do some research on Linux signals. You can use [this google search](https://www.google.com/search?q=Linux+signals+overview+site%3Aman7.org+OR+site%3Alinux.die.net+OR+site%3Atldp.org&oq=Linux+signals+overview+site%3Aman7.org+OR+site%3Alinux.die.net+OR+site%3Atldp.org&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBBzc2MGowajeoAgCwAgA&sourceid=chrome&ie=UTF-8) to get started.

- What is the purpose of signals in a Linux system, and how do they differ from other forms of interprocess communication (IPC)?

    > **Answer**:  _Signals in Linux systems are typically used to notify a process that a specific event has occurred, like the termination of a child process. This is different from other forms of interprocess communication because signals usually are very simple, one-way notifications and don't carry complex data. Other IPC's like pipes allow for more capabilities or complex interactions._

- Find and describe three commonly used signals (e.g., SIGKILL, SIGTERM, SIGINT). What are their typical use cases?

    > **Answer**:  _SIGKILL: Immediately terminates a process without excuting any signal handlers or clean up. This is typically used for forcefully shutting down processes. SIGTERM: This is similar to SIGKILL, but instead it allows to perform cleanup operations before terminating the process. This is typically used for shutting down applications gracefully. SIGINT: A signal that's sent to a process when a user interrups it from the terminal, when pressing Ctrl+C. It's best used for user interruptions or interactive programs.

- What happens when a process receives SIGSTOP? Can it be caught or ignored like SIGINT? Why or why not?

    > **Answer**:  _When a process receives SIGSTOP, it is immediately stopped by the operating system, so the process will not execute any further instructions. This process is non-catchable and non-ignorable, so the process cannot prevent itself from being stopped. SIGSTOP cannot be cleanedup and the process is simply halted. This is because the operating system enforces this behavior to ensure that certain processes stay intact.