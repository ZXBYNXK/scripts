#!/bin/bash
# Source: https://github.com/ZXBYNXK/scripts/bash/auto-git-ssh-setup.sh
# Help: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

setup() {
    
    generate_key
    agent
    add_known_hosts
    
}


export -f setup
../*


