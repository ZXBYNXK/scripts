#!/bin/bash

init() {
    rm -rf ./temp/*
    mkdir ./temp/key
    mkdir ./temp/pkg/
    mkdir ./temp/pkg_sig/

}

main() {

    init
    temp_key=(./temp/key/*)
    temp_pkg=(./temp/pkg/*)
    temp_pkg_sig=(./temp/pkg_sig/*)

    printf "Official source's key URL (https://<URL>/<FILE-NAME>.asc):"
    read o_key_sig_url

    printf "Software package URL (https://<URL>/<FILE-NAME>.<ANY>):"
    read software_pkg_url
    
    printf "Software SHA256SUMS URL (https://<URL>/SHA256SUMS):"
    read software_pkg_sha_url

    echo "Downloading from $o_key_sig_url ..."
    wget -q -O - $o_key_sig_url -P ./temp/key
    echo "-----------------------------------------------------------"
    gpg --keyid-format long --list-options show-keyring "${temp_key[0]}"
    echo "-----------------------------------------------------------"
    echo "[* Check the official software source for matching keyid *]"
    echo "[* Y: Import key to gpg and continue downloads.          *]"
    echo "[* n: Won't import to gpg and program will exit.         *]"
    
    printf "Verified (Y/n):"
    read inspect_value
    
    if [[ "$inspect_value" =~ Y|y{1} ]]; then
        gpg --import "${temp_key[0]}"
    else
        echo "Exiting..."
        return        
    fi

    echo "Downloading SHA256SUMS from $software_pkg_sha_url ..."
    wget -q "$software_pkg_sha_url{.gpg,}" -P ./temp/pkg_sig/

    echo "Downloading software package from $software_pkg_url ..."
    wget "$software_pkg_url" -P ./temp/pkg/

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

