#!/usr/bin/env bats

# File: student_tests.sh
# 
# Create your unit tests suit in this file

@test "Example: check ls runs without errors" {
    run ./dsh <<EOF                
ls
exit
EOF

    # Assertions
    [ "$status" -eq 0 ]
}


setup() {
    kill -f dsh || true
    ./dsh -s -i 0.0.0.0 -p 7890 &
    server_pid=$!
    sleep 1
}

teardown() {
    kill -9 $server_pid || true
    sleep 1
}


@test 'Simple command execution: echo "Hello"' {
    ip=$(hostname -I | tr -d '[:space:]')
    run "./dsh" -c -i $ip -p 7890 <<EOF
echo "Hello"
exit
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:$ip:7890dsh4>$(echo "Hello" | tr -d '[:space:]')dsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}" | od -c
    echo "Expected Output: ${expected_output}" | od -c

    expected=$(echo "$expected_output" | tr -d '[:cntrl:]')
    stripped=$(echo "$stripped_output" | tr -d '[:cntrl:]')

    [ "$stripped" = "$expected" ]

    [ "$status" -eq 0 ]
}

@test 'Simple command execution: pwd' {
    ip=$(hostname -I | tr -d '[:space:]')
    run "./dsh" -c -i $ip -p 7890 <<EOF
pwd
exit
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:$ip:7890dsh4>$(pwd | tr -d '[:space:]')dsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}" | od -c
    echo "Expected Output: ${expected_output}" | od -c

    expected=$(echo "$expected_output" | tr -d '[:cntrl:]')
    stripped=$(echo "$stripped_output" | tr -d '[:cntrl:]')

    [ "$stripped" = "$expected" ]

    [ "$status" -eq 0 ]
}

@test "Simple command execution: ls" {
    ip=$(hostname -I | tr -d '[:space:]')
    run "./dsh" -c -i $ip -p 7890 <<EOF
ls
exit
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:$ip:7890dsh4>$(ls | tr -d '[:space:]')dsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}" | od -c
    echo "Expected Output: ${expected_output}" | od -c


    expected=$(echo "$expected_output" | tr -d '[:cntrl:]')
    stripped=$(echo "$stripped_output" | tr -d '[:cntrl:]')

    [ "$stripped" = "$expected" ]

    [ "$status" -eq 0 ]
}

@test "Piped command: ls -a | grep '.c'" {
    ip=$(hostname -I | tr -d '[:space:]')
    run "./dsh" -c -i $ip -p 7890 <<EOF
ls -a | grep ".c"
exit
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:$ip:7890dsh4>$(ls -a | grep ".c" | tr -d '[:space:]')dsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}" | od -c
    echo "Expected Output: ${expected_output}" | od -c


    expected=$(echo "$expected_output" | tr -d '[:cntrl:]')
    stripped=$(echo "$stripped_output" | tr -d '[:cntrl:]')

    [ "$stripped" = "$expected" ]

    [ "$status" -eq 0 ]
}

@test "Pipes with quoted strings with spaces" {
    ip=$(hostname -I | tr -d '[:space:]')
    run "./dsh" -c -i $ip -p 7890 <<EOF
ls -a | echo "                                hi"
exit
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:$ip:7890dsh4>$(ls -a | echo "                                hi" | tr -d '[:space:]')dsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}" | od -c
    echo "Expected Output: ${expected_output}" | od -c


    expected=$(echo "$expected_output" | tr -d '[:cntrl:]')
    stripped=$(echo "$stripped_output" | tr -d '[:cntrl:]')

    [ "$stripped" = "$expected" ]

    [ "$status" -eq 0 ]
}

@test "Pipes with duplicate space" {
    ip=$(hostname -I | tr -d '[:space:]')
    run "./dsh" -c -i $ip -p 7890 <<EOF
                ls -a |           grep ".c" |             echo "hi"
exit
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:$ip:7890dsh4>$(ls -a | grep ".c" | echo "hi" | tr -d '[:space:]')dsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}" | od -c
    echo "Expected Output: ${expected_output}" | od -c


    expected=$(echo "$expected_output" | tr -d '[:cntrl:]')
    stripped=$(echo "$stripped_output" | tr -d '[:cntrl:]')

    [ "$stripped" = "$expected" ]

    [ "$status" -eq 0 ]
}

@test "Pipes with no commands or arguments" {
    ip=$(hostname -I | tr -d '[:space:]')
    run "./dsh" -c -i $ip -p 7890 <<EOF
|||
exit
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:$ip:7890dsh4>rdsh-error:commandexecutionerrordsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}" | od -c
    echo "Expected Output: ${expected_output}" | od -c


    expected=$(echo "$expected_output" | tr -d '[:cntrl:]')
    stripped=$(echo "$stripped_output" | tr -d '[:cntrl:]')

    [ "$stripped" = "$expected" ]

    [ "$status" -eq 0 ]
}

@test "Max number of pipes (8 commands)" {
    ip=$(hostname -I | tr -d '[:space:]')
    run "./dsh" -c -i $ip -p 7890 <<EOF
echo "welcome" | echo "cat" | echo "cool" | echo "hello" | echo "bye" | echo "food" | echo "dogs" | echo "cows"
exit
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:$ip:7890dsh4>$(echo "welcome" | echo "cat" | echo "cool" | echo "hello" | echo "bye" | echo "food" | echo "dogs" | echo "cows" | tr -d '[:space:]')dsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}" | od -c
    echo "Expected Output: ${expected_output}" | od -c


    expected=$(echo "$expected_output" | tr -d '[:cntrl:]')
    stripped=$(echo "$stripped_output" | tr -d '[:cntrl:]')

    [ "$stripped" = "$expected" ]

    [ "$status" -eq 0 ]
}

@test "Pipeline works even with invalid command" {
    ip=$(hostname -I | tr -d '[:space:]')
    run "./dsh" -c -i $ip -p 7890 <<EOF
ls -a | food | echo "hi"
exit
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:$ip:7890dsh4>$(ls -a | food | echo "hi" | tr -d '[:space:]')dsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}" | od -c
    echo "Expected Output: ${expected_output}" | od -c


    expected=$(echo "$expected_output" | tr -d '[:cntrl:]')
    stripped=$(echo "$stripped_output" | tr -d '[:cntrl:]')

    [ "$stripped" = "$expected" ]

    [ "$status" -eq 0 ]
}

@test "Elimates duplicate spaces inside quotes" {
    ip=$(hostname -I | tr -d '[:space:]')
    run "./dsh" -c -i $ip -p 7890 <<EOF
                          echo                    "hello                            how are you"
exit
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:$ip:7890dsh4>$(echo "hello how are you" | tr -d '[:space:]')dsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}" | od -c
    echo "Expected Output: ${expected_output}" | od -c


    expected=$(echo "$expected_output" | tr -d '[:cntrl:]')
    stripped=$(echo "$stripped_output" | tr -d '[:cntrl:]')

    [ "$stripped" = "$expected" ]

    [ "$status" -eq 0 ]
}

@test "Eliminates leading spaces" {
    ip=$(hostname -I | tr -d '[:space:]')
    run "./dsh" -c -i $ip -p 7890 <<EOF
                          ls -a
exit
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:$ip:7890dsh4>$(ls -a | tr -d '[:space:]')dsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}" | od -c
    echo "Expected Output: ${expected_output}" | od -c


    expected=$(echo "$expected_output" | tr -d '[:cntrl:]')
    stripped=$(echo "$stripped_output" | tr -d '[:cntrl:]')

    [ "$stripped" = "$expected" ]
    [ "$status" -eq 0 ]
}

@test "Stop-server command stops server" {
    ip=$(hostname -I | tr -d '[:space:]')
    run "./dsh" -c -i $ip -p 7890 <<EOF
stop-server
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="socketclientmode:addr:$ip:7890dsh4>Serverclosedconnectioncmdloopreturned-50"


    echo "Stripped Output: ${stripped_output}" | od -c
    echo "Expected Output: ${expected_output}" | od -c


    expected=$(echo "$expected_output" | tr -d '[:cntrl:]')
    stripped=$(echo "$stripped_output" | tr -d '[:cntrl:]')

    [ "$stripped" = "$expected" ]
    [ "$status" -eq 0 ]
}










