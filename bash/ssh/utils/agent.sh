#!/bin/bash

# Info: https://superuser.com/questions/284374/ssh-keys-ssh-agent-bash-and-ssh-add
agent() {

    echo "Starting ssh-agent..."
        
    # eval is needed to automatically add proccess to enviroment
    eval "$(ssh-agent -s)"
    
    
    # if custom path
    if [[-n "$1"]] then;
        
        # Add custom path 
        ssh-add ~./ssh/$1
    
    else
        # Add default path
        ssh-add ~/.ssh/id_rsa

    fi
}

# Export function(s) to following script paths
export -f agent
./*