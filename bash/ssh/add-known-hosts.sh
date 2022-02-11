#!/bin/bash

# Avoid client not knowing if ssh connection to github is authentic (May see this when pushing a commit)
# Info: https://github.com/ome/devspace/issues/38#issuecomment-211515244

add_known_hosts() {

    echo "Adding kown_hosts for github (~/.ssh/known_hosts)..."
    ssh-keyscan github.com >> ~/.ssh/known_hosts

    # Run a test to let the end user know if connection is good
    echo "Testing SSH to git@github.com connection..."
    ssh -T git@github.com || echo "Something is wrong :( >>> See: https://docs.github.com/en/authentication/connecting-to-github-with-ssh"

}

export -f add_known_hosts
./*
