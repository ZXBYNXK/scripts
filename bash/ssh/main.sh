#!/bin/bash

landing_art
init_menu
read option

if [[ "$option" == "1" ]]; then
    setup
fi

if [[ "$option" == "2" ]]; then
    git_setup
fi


if [[ "$option" == "3" ]]; then
    ssh-keygen
fi

echo "Exiting..."

