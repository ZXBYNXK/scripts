#!/bin/bash
# Info: https://www.ssh.com/academy/ssh/agent
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent

generate_key() {

    # Obtain end user email
    printf "Email: "
    read email

    # Generate a ssh key with specified email
    # Info: https://www.ssh.com/academy/ssh/keygen#what-is-ssh-keygen?
    echo "Generating SSH key for $email (Use default values below)"

    # ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
    ssh-keygen -t rsa -b 4096 -C "$email"

    # Show end user their public ssh key and direct them to copy and paste it to the link provided
    echo "------------------------------------------------------------"

    cat ~/.ssh/id_rsa.pub

    echo "------------------------------------------------------------"

    # End user needs to complete the above for the below to execute
    printf "Done with the above? (Hit Enter)"
    read none

    # Start ssh-agent to manage client authenticity on ssh protocol connections
    
    echo "Starting ssh-agent..."
    eval "$(ssh-agent -s)"

    # Add the private key into current running ssh-agent
    # Info: https://www.ssh.com/academy/ssh/add
    echo "Adding private key for $email to ssh-agent..."
    ssh-add ~/.ssh/id_rsa
}

export -f generate_key
./setup ./git-setup