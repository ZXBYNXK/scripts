#!/bin/bash
init_menu() {
    printf "
        Auto SSH Setup Options:
        
            1) Default  [*Make SSH key for any general purpose*]
            
            2) Github   [* Make SSH key specifically for GitHub *]

            3) Manual   [* Just will run ssh-keygen *]

            4) Exit  
    : "
}

export -f init_menu
../*