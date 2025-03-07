#!/usr/bin/env bats

# File: student_tests.sh
# 
# Create your unit tests suit in this file

@test "Example: check ls runs without errors" {
    run ./dsh <<EOF                
ls
EOF

    # Assertions
    [ "$status" -eq 0 ]
}
@test "Checks the command pwd if it works correctly" {
    current=$(pwd)

    run "${current}/dsh" <<EOF                
pwd
EOF
    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="${current// /}dsh3>dsh3>cmdloopreturned0"
    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"
    [ "$stripped_output" = "$expected_output" ]
    [ "$status" -eq 0 ]
}

@test "cd into nonexistent directory should move to next line" {
    current=$(pwd)

    run "${current}/dsh" <<EOF
cd nonexistent_directory
pwd
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="dsh3>${current// /}dsh3>dsh3>dsh3>cmdloopreturned0"
    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]
    [ "$status" -eq 0 ]
}

@test "Invalid command does nothing" {
    current=$(pwd)

    run "${current}/dsh" <<EOF
invalid_command_that_does_not_exist
pwd
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')

    expected_output="dsh3>${current// /}dsh3>dsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}

@test "exit command breaks out of the system" {
    current=$(pwd)

    run "${current}/dsh" <<EOF
exit
EOF

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
   
    [ "$status" -eq 0 ]

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="dsh3>cmdloopreturned-7"
    [ "$stripped_output" = "$expected_output" ]
}

@test "No commands in line" {
    current=$(pwd)

    run "${current}/dsh" <<EOF

EOF
    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"

    [ "$status" -eq 0 ]

}

@test "Checks for quoted strings with spaces" {
    current=$(pwd)

    run "${current}/dsh" <<EOF
echo "hello world"
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="helloworlddsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]
    [ "$status" -eq 0 ]
}

@test "Checks for eliminating leading spaces" {
    current=$(pwd)

    run "${current}/dsh" <<EOF
                          ls -a
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="$(ls -a | tr -d '[:space:]')dsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]
    [ "$status" -eq 0 ]
}


@test "Checks for eliminating duplicate spaces between commands and arguments" {
    current=$(pwd)

    run "${current}/dsh" <<EOF
                          echo                    "hello how are you"
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="$(echo "hello how are you" | tr -d '[:space:]')dsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]
    [ "$status" -eq 0 ]
}

@test "Checks for eliminating duplicate spaces inside quotes" {
    current=$(pwd)

    run "${current}/dsh" <<EOF
                          echo                    "hello                            how are you"
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="$(echo "hello how are you" | tr -d '[:space:]')dsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]
    [ "$status" -eq 0 ]
}


@test "Multiple different running pipes" {
    run "./dsh" <<EOF                
ls | grep dsh | sort | echo "hi"
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="$(ls -a | grep dsh | sort | echo "hi" | tr -d '[:space:]')dsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}

@test "Working pipeline even with invalid command in pipeline" {
    run "./dsh" <<EOF                
ls -a | food | echo "hi"
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="$(ls -a | food | echo "hi" | tr -d '[:space:]')dsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}

@test "Max number of pipes (8 commands)" {
    run "./dsh" <<EOF                
echo "welcome" | echo "cat" | echo "cool" | echo "hello" | echo "bye" | echo "food" | echo "dogs" | echo "cows"
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="cowsdsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}




@test "Too many pipes - invalid error" {
    run "./dsh" <<EOF                
ls -a | echo "hi" | grep ".c" | echo "welcome" | echo "cat" | echo "cool" | echo "hello" | echo "bye" | echo "food" | echo "dogs" | echo "cows"
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="dsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}

@test "Pipes with no commands or args" {
    run "./dsh" <<EOF                
|||
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="dsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}

@test "Pipes with duplicate spaces" {
    run "./dsh" <<EOF                
                ls -a |           grep ".c" |             echo "hi"
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="$(ls -a | grep ".c" | echo "hi" | tr -d '[:space:]')dsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}

@test "Pipes with quoted strings with spaces" {
    run "./dsh" <<EOF                
ls -a | echo "                                hi"
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="$(ls -a | echo "                                hi" | tr -d '[:space:]')dsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}







