#!/bin/bash

init() {
    rm -rf ./temp
    mkdir ./temp
}

main() {    
    init
    
    log_dir_name=$(date '+%d_%m_%y')
    log_file_name=$(date '+%H_%M_%S')
    log_file_path = "./log/$log_dir_name/$log_file_name"
    log_dir_path = "./log/$log_dir_name/"
    mkdir $log_dir_path && touch $log_file_path
    
    # SOFTWARE_NAME = FILE[0]
    # HTTP_LINK_OWNER_PGP = FILE[1]
    # HTTP_LINK_SOFTWARE_SHA = FILE[2]
    # HTTP_LINK_SOFTWARE = FILE[3]

    counter=0
    until [ $counter -gt 4 ]
    do
        # Download official key
        if [[ $counter -eq 0 ]];
        then

            # Get link
            printf "Official source's key URL (https://<URL>/<FILE-NAME>.asc):"
            read o_key_sig_url

            # Download
            echo "Downloading from $o_key_sig_url ..."
            wget -nv -O - $o_key_sig_url -P > ./temp/$ -a $log_file_path
        fi

        # Download SHA256SUMS 
        if [[ $counter -eq 1 ]];
        then
            
            # SHA256SUMS
            printf "Software SHA256SUMS URL (https://<URL>/SHA256SUMS):"
            read software_pkg_sha_url

            # Download
            echo "Downloading SHA256SUMS from $software_pkg_sha_url ..."
            wget -r -l 1 -nd -A "sha256sum*" --ignore-case -P ./temp -a $log_file_path
            # if ! wget -q $software_pkg_sha_url/SHA256SUMS{.gpg,} -P ./temp 
        fi

        # Download Software 
        if [[ $counter -eq 2 ]];
        then

            # Get link
            printf "Software package URL (https://<URL>/<FILE-NAME>.<ANY>):"
            read software_pkg_url

            # Download
            echo "Downloading software package from $software_pkg_url ..."
            wget -v $software_pkg_url -P ./temp -a $log_file_path
        fi
        
        # Verify download
        if [[ $counter -eq 3 ]];
        then
            
            echo "Verifying software... "
            cd ./temp
            sha256sum -c SHA256SUMS 2>&1 | grep OK
        fi
        
        # Exit
        if [[ $counter -eq 4 ]];
        then
            echo "Download located in /Scripts/bash/download/iso/temp"    
        echo "$counter"
        fi
        ((++counter))
    done
    # return
}

main
# read official_key_source

