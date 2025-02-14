1. In this assignment I suggested you use `fgets()` to get user input in the main while loop. Why is `fgets()` a good choice for this application?

    > **Answer**:  _fgets() is good for preventing buffer overflow and supporting file pipelines. It also preserves new lines._

2. You needed to use `malloc()` to allocte memory for `cmd_buff` in `dsh_cli.c`. Can you explain why you needed to do that, instead of allocating a fixed-size array?

    > **Answer**:  _We needed to malloc space for the cmd_buff because we need to dynamically resize based on the user's input which prevents from wasting space._

3. In `dshlib.c`, the function `build_cmd_list(`)` must trim leading and trailing spaces from each command before storing it. Why is this necessary? If we didn't trim spaces, what kind of issues might arise when executing commands in our shell?

    > **Answer**:  _Trimming leading and trailing spaces from each command before storing it is necessary because if a user input has a lot of trailing spaces there might be incorrect argument handling and parsing issues with piping._

4. For this question you need to do some research on STDIN, STDOUT, and STDERR in Linux. We've learned this week that shells are "robust brokers of input and output". Google _"linux shell stdin stdout stderr explained"_ to get started.

- One topic you should have found information on is "redirection". Please provide at least 3 redirection examples that we should implement in our custom shell, and explain what challenges we might have implementing them.

    > **Answer**:  _For STDIN, we can use the input direction < to redirect a file's content as input. For STDOUT, we can use the output redirction > to write output to a file which can be good if we want to save information. FOR STDERR, we can use 2> to redirect error messages like writing error messages into a file._

- You should have also learned about "pipes". Redirection and piping both involve controlling input and output in the shell, but they serve different purposes. Explain the key differences between redirection and piping.

    > **Answer**:  _Redirction is typically used to redirect information somewhere else like a file, whereas piping is primarily used for executing multiple commands._

- STDERR is often used for error messages, while STDOUT is for regular output. Why is it important to keep these separate in a shell?

    > **Answer**:  _Keeping STDERR and STDOUT seperate in a shell is important because it prevents the mixing between regular outputs and errors. It also can make it easier for debugging a certain output._

- How should our custom shell handle errors from commands that fail? Consider cases where a command outputs both STDOUT and STDERR. Should we provide a way to merge them, and if so, how?

    > **Answer**:  _For handling custom shell error commands that fail we should probably use the return error codes and store error information into a file. For cases where both the command outputs both STDOUT and STDERR we should have a seperate files for errors, non-errors, and outputs that produce both errors and non-errors._