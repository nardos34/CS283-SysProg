#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define BUFFER_SZ 50

//prototypes
void usage(char *);
void print_buff(char *, int);
int  setup_buff(char *, char *, int);

//prototypes for functions to handle required functionality
int  count_words(char *, int, int);

//add additional prototypes here
void word_print(char *, int);
void reverse(char *, int);

int setup_buff(char *buff, char *user_str, int len){
    //TODO: #4:  Implement the setup buff as per the directions
	
	// Initializes user string counter
	int str_length = 0;

	// Sets the internal buffer with 50 dots
	memset(buff, '.', len);

	// If the user provides a string that starts will white space this will skip over it until it reaches only one space.
	if (*user_str == ' ') {
		while (*user_str == ' ') {
			user_str++;
		}
	}

	// This copies every character from the user supplied string to the internal buffer skipping duplicate consequitve whitespace.
    while (*user_str != '\0') {
    	//If the user supplied a string that is too large it will return with an error code, otherwise it will return the length of the users string.
    	if (str_length >= len) {
			return -1;
    	}

		*buff = *user_str;	
		buff++;

		// This part skips over duplicate whitespace
		if (*user_str == ' ') {
			while (*user_str == ' ') {
            	user_str++;
            }
		} else {
			user_str++;
		}

		str_length += 1;
    }
    
	// Returns the length of the given string
	return str_length;

}

// Prints out the internal buffer
void print_buff(char *buff, int len){
    printf("Buffer:  ");
    for (int i=0; i<len; i++){
        putchar(*(buff+i));
    }
    putchar('\n');
}

// Used for printing out the usage string for the -h or any errors
void usage(char *exename){
    printf("usage: %s [-h|c|r|w|x] \"string\" [other args]\n", exename);

}

// Counts the number of words in the buffer
int count_words(char *buff, int len, int str_len){
	// Initializes the number of words in ther user string, starting with the first word.
	int count_word = 1;
	char *next_char = buff;
	next_char++;
	

	if (str_len > len) {
		return -1;
	}
	
	// If the string length is 0 that means the given string has no words
	if (str_len == 0) {
		count_word = 0;
	} else {
		// Goes through the string to count the number of words in the buffer
    	for (int i = 0; i < str_len + 1; i++) {
			if ((*buff == ' ') && (*next_char != '.')) {
				count_word += 1;
			}
			buff++;
			next_char++;
    	}

    }
	
	// Checks for errors when getting the number of words
	return count_word;
	
}

//ADD OTHER HELPER FUNCTIONS HERE FOR OTHER REQUIRED PROGRAM OPTIONS
void word_print(char *buff, int str_len) {
	
	printf("Word Print\n");
	printf("----------\n");

	// Counter determines the length of the word
	int counter = 0;
	int num_of_words = 0;
	
	// Prints out each word in the buffer along with the length of the word
	for (int i = 1; i < str_len + 1; i++) {
		printf("%d. ", i);

		// Until it reaches the end of the word it will print each letter out
		while (*buff != ' ' && *buff != '.') {
			putchar(*buff);
			counter += 1;
			buff++;
		}

		// Counter resets everytime there is a new word
		printf("(%d)\n", counter);
		counter = 0;
		buff++;
		
		num_of_words = i;
	}

	printf("\nNumber of words returned: %d\n", num_of_words);

}

// Reverses the string
void reverse(char *buff, int str_len) {
	// Initializing a copy of the buffer by creating space
	char *copy_buff = malloc(str_len);

	// Copying over the buffer without the remainder of the internal buffer
	// This is so that I am copying only the string without the .........
	memcpy(copy_buff, buff, str_len);

	// This sets the pointer to the end of the copied string
	for (int i = 0; i < str_len; i++) {
        copy_buff++;
    }
	copy_buff--;

	// Copying over the reversed string to the buffer
	for (int i = 0; i < str_len; i++) {
        *buff = *copy_buff;
        buff++;
        copy_buff--;
    }
	
	// Free copy of buffer
	copy_buff++;
	free(copy_buff);

}

int main(int argc, char *argv[]){

    char *buff;             //placehoder for the internal buffer
    char *input_string;     //holds the string provided by the user on cmd line
    char opt;               //used to capture user option from cmd line
    int  rc;                //used for return codes
    int  user_str_len;      //length of user supplied string

    //TODO:  #1. WHY IS THIS SAFE, aka what if arv[1] does not exist?
    //      PLACE A COMMENT BLOCK HERE EXPLAINING
    // Answer #1: This is safe because if the program is missing arguments, it will print out a usage string to let the user know how to properly use the program. This makes sure that the program is called with the proper arguments, and exits safely otherwise.
    if ((argc < 2) || (*argv[1] != '-')){
        usage(argv[0]);
        exit(1);
    }

    opt = (char)*(argv[1]+1);   //get the option flag

    //handle the help flag and then exit normally
    if (opt == 'h'){
        usage(argv[0]);
        exit(0);
    }

    //WE NOW WILL HANDLE THE REQUIRED OPERATIONS

    //TODO:  #2 Document the purpose of the if statement below
    //      PLACE A COMMENT BLOCK HERE EXPLAINING
    // Answer #2: If there is less than 3 arguments it will print out a usage string to let the user know how to use the program correctly.
    // This means that either the option or the string is missing in the program command.
    if (argc < 3){
        usage(argv[0]);
        exit(1);
    }

    input_string = argv[2]; //capture the user input string

    //TODO:  #3 Allocate space for the buffer using malloc and
    //          handle error if malloc fails by exiting with a 
    //          return code of 99
    // CODE GOES HERE FOR #3
	
	buff = (char*)malloc(BUFFER_SZ);

    user_str_len = setup_buff(buff, input_string, BUFFER_SZ);     //see todos
    if (user_str_len < 0){
        printf("Error setting up buffer, error = %d", user_str_len);
        exit(2);
    }
	
    switch (opt){
        case 'c':
            rc = count_words(buff, BUFFER_SZ, user_str_len);  //you need to implement
            if (rc < 0){
                printf("Error counting words, rc = %d\n", rc);
                exit(2);
            }
            printf("Word Count: %d\n", rc);
            break;
        //TODO:  #5 Implement the other cases for 'r' and 'w' by extending
        //       the case statement options
		case 'r':
			reverse(buff, user_str_len);
			break;
        case 'w':
        	int word_count = count_words(buff, BUFFER_SZ, user_str_len);
        	word_print(buff, word_count); 
        	break;
        default:
            usage(argv[0]);
            exit(1);
    }

    //TODO:  #6 Dont forget to free your buffer before exiting
    print_buff(buff,BUFFER_SZ);
    free(buff);
    exit(0);
}

//TODO:  #7  Notice all of the helper functions provided in the 
//          starter take both the buffer as well as the length.  Why
//          do you think providing both the pointer and the length
//          is a good practice, after all we know from main() that 
//          the buff variable will have exactly 50 bytes?
//  
//          PLACE YOUR ANSWER HERE
//			Answer #7:
//			It is important to have both the buffer and the length 
//			as the parameters for the functions because it makes it 
//			easier to debug issues related to memory allocation and 
//			the prevention of the buffer overflowing. Since, each 
//			function either changes or analyzes the buffer, it is 
//			important to have the buffer as one of the parameters to 
//			be able to print out the number of words, reverse the 
//			string, or print the individual words.

