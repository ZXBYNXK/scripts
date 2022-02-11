#!/bin/bash
new_line() {
    echo ""
}
prompt_alert() {
    # End user needs to complete the above for the below to execute
    printf "$1"
    read none
}

prompt_email() {
    new_line
    printf "Enter Email: "
    read email
    echo "$email"
}

prompt_password() {
    new_line
    echo "[* Enter for default: n is the option set by default... *]"
    printf "Password for your keys (Y/n): "
}

prompt_directory() {
    new_line
    echo "[* Enter for default: ~/.ssh/ is the path set by default... *]"
    printf "Directory to store your keys: "
}

msg_git_key_gen_procces() {
    new_line
    echo "Generating SSH key for GitHub user $1..."
}

msg_git_public_key() {
    echo "------------------------------------------------------------"
    cat ~/.ssh/id_rsa.pub
    echo "------------------------------------------------------------"
    echo "Go to https://github.com/settings/keys and copy then paste the above public key. (IMPORTANT)"
    echo "NOTE: Copy text inbetween the dashes!"
}



export -f new_line email password directory
../*