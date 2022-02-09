#!/bin/bash
new_line() {
    echo ""
}

email() {
    new_line
    printf "Enter Email: "
}

password() {
    new_line
    echo "[* Enter for default: n is the option set by default... *]"
    printf "Password for your keys (Y/n): "
}

directory() {
    new_line
    echo "[* Enter for default: ~/.ssh/ is the path set by default... *]"
    printf "Directory to store your keys: "
}

export -f new_line email password directory
../*