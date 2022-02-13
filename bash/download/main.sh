#!/bin/bash

# temp = ~/Downloads/temp/

verify() {
    temp = ~/Downloads/temp/
    # Log id 
    echo "-----------------------------------------------------------"
    gpg --keyid-format long --list-options show-keyring $temp/*.asc
    echo "-----------------------------------------------------------"
    echo "[* Check the official software source for matching keyid *]"
    echo "[* Y: Import key to gpg and continue downloads.          *]"
    echo "[* n: Won't import to gpg and program will exit.         *]"
    
    printf "Verified (Y/n):"
    read inspect_value
    
    if [[ "$inspect_value" =~ Y|y{1} ]]; then
        gpg --import $temp*.asc 
    else
        echo "Exiting..."
        return        
    fi
}

download() {
    # Download
    echo "Downloading from $1 ..."
    wget -q -O - $1 -P $2
}

init() {
    rm -rf $1
    mkdir $1
}

main() {
    temp = ~/Downloads/temp/
    init $temp
    count = 0

    until [ $count -gt 4 ]
    do
            # Download official key
        if [[ $count -eq 0 ]];
        then

            # Get link
            printf "Official source's key URL (https://<URL>/<FILE-NAME>.asc):"
            read o_key_sig_url

            # Download
            echo "Downloading from $o_key_sig_url ..."
            # wget -q -O - $o_key_sig_url -P $temp
            download $o_key_sig_url $temp

        # Download Software 
        if [[ $count -eq 1 ]];
        then

            # Get link
            printf "Software package URL (https://<URL>/<FILE-NAME>.<ANY>):"
            read software_pkg_url

            # Download
            echo "Downloading software package from $software_pkg_url ..."
            # wget "$software_pkg_url" -P $temp
            download $software_pkg_url $temp
        
        # Download SHA256SUMS 
        if [[ $count -eq 2 ]];
        then
            
            # SHA256SUMS
            pintf "Software SHA256SUMS URL (https://<URL>/SHA256SUMS):"
            read software_pkg_sha_url

            # Download
            echo "Downloading SHA256SUMS from $software_pkg_sha_url ..."
            download $software_pkg_sha_url $temp
        
        # Verify download
        if [[ $count -eq 3 ]];
        then
            
            echo "Verifying software... "
            cd $temp
            sha256sum -c SHA256SUMS 2>&1 | grep OK

        # Exit
        if [[ $count -eq 4 ]];
        then
            echo "Download located in $temp"    
        ((count=count+1))
    done;
    return
}

main
# read official_key_source

