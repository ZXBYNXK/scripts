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
    temp = ~/Downloads/temp/
    # Download
    echo "Downloading from $1 ..."
    wget -q -O - $1 -P $temp
}


main() {
    rm -rf ~/Downloads/temp/
    mkdir ~/Downloads/temp/
    temp = ~/Downloads/temp/
    # 
    count = 0
    until [ $count -gt 3 ]
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
            download $o_key_sig_url

        # Download Software 
        if [[ $count -eq 1 ]];
        then

            # Get link
            printf "Software package URL (https://<URL>/<FILE-NAME>.<ANY>):"
            read software_pkg_url

            # Download
            echo "Downloading software package from $software_pkg_url ..."
            # wget "$software_pkg_url" -P $temp
            download $software_pkg_url
        
        # Download SHA256SUMS 
        if [[ $count -eq 2 ]];
        then
            
            # SHA256SUMS
            pintf "Software SHA256SUMS URL (https://<URL>/SHA256SUMS):"
            read software_pkg_sha_url

            # Download
            download $software_pkg_sha_url 
        
        ((count=count+1))
    done;

    # done
    # for file in $temp; do






    echo "Downloading SHA256SUMS from $software_pkg_sha_url ..."
    wget -q "$software_pkg_sha_url{.gpg,}" -P ./temp/pkg_sig/

  

    echo "Verifying files: ${temp_pkg_sig[0]}, ${temp_pkg_sig[1]} " 
    gpg --verify ./temp/pkg_sig/${temp_pkg_sig[0]} ./temp/pkg_sig/${temp_pkg_sig[1]}

    echo "Verifying software: ${temp_pkg[0]}"
    mv ./temp/pkg/* ./temp/pkg_sig/* ./temp
    rm -rf ./temp/key temp/pkg temp/pkg_sig
    cd ./temp
    sha256sum -c SHA256SUMS 2>&1 | grep OK

    mv ./temp verified_download
    rm -rf ~/Downloads/verified_download
    mv ./verified_download ~/Downloads
    cd ..
    echo "You can find verified_download in ~/Downloads/verified_download"
    return
}

main
# read official_key_source

