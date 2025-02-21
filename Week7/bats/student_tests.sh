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
    expected_output="${current// /}dsh2>dsh2>cmdloopreturned0"
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
    expected_output="dsh2>${current// /}dsh2>dsh2>dsh2>cmdloopreturned0"
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

    expected_output="dsh2>${current// /}dsh2>dsh2>dsh2>cmdloopreturned0"

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
    expected_output="dsh2>cmdloopreturned-7"
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