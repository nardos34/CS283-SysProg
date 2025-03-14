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

setup() {
    ./dsh -s -p 7890 &
    server_pid=$!
    sleep 1
}

@test "Simple command execution: ls" {
    run "./dsh" -c -p 7890 <<EOF
ls
exit
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:127.0.0.1:7890dsh4>$(ls | tr -d '[:space:]')dsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}"
    echo "Expected Output: ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}

