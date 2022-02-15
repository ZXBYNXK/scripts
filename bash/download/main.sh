#!/bin/bash
# Script Name: ./scripts/bash/download/main.sh
#
# Author: https://github.com/ZXBYNXK
# Date : 02/14/22
#
# Description: The following script automates signature verification for downloads.
# 
#              Usage: 
#               ./scripts/bash/download/main.sh <FILE>
#               ./main.sh <FILE>
# 
#              Example: 
#               ./scripts/bash/download/main.sh ./scripts/bash/download/example/centos
#               ./main.sh ./example/centos
#
# Run Information: This script requires one argument and must be a plain text file 
#                  that follows the proper format.
# 
#                  Saved downloads: ./scripts/bash/download/offline/history/SOFTWARE_NAME
# 
#                  See Format: ./scripts/bash/download/example/centos
#                  
# 
# 
# Error Log: Any errors or output associated with the script can be found
#            in ./scripts/bash/download/log/<date>/<time>.txt

init() {
    rm -rf ./temp/*.*
    mkdir -p ./log
}

main() {    
    # DEBUG
    # echo "Problem Here ->\$NONE<-"
    init
    REGEX_URL_VALID='^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$'
    STATUS=0

    LOG_DIR_NAME=$(date '+%d_%m_%y')
    LOG_FILE_NAME=$(date '+%H_%M_%S')
    LOG_FILE_PATH="./log/$LOG_DIR_NAME/$LOG_FILE_NAME"
    LOG_DIR_PATH="./log/$LOG_DIR_NAME/"

    SOFTWARE_NAME=$(awk '{if(NR==1) print $0}' $1)
    HTTP_LINK_OWNER_PGP=$(awk '{if(NR==2) print $0}' $1)
    HTTP_LINK_SOFTWARE_SHA=$(awk '{if(NR==3) print $0}' $1)
    HTTP_LINK_SOFTWARE=$(awk '{if(NR==4) print $0}' $1)
    
    OFFLINE_PATH="./offline/$SOFTWARE_NAME"
    OFFLINE_OPK="$OFFLINE_PATH/$SOFTWARE_NAME.gpg"
    OFFLINE_FILES="$OFFLINE_PATH/files"

    BANNER_OWNER_PGP="\n-------------OWNER-PUBLIC-PGP-KEY--------------------\n"
    BANNER_SHA="\n-------------------SHA256SUMS------------------------\n"
    BANNER_SOFTWARE="\n-------------------SOFTWARE------------------------\n"
    BANNER_VERIFICATION="\n-----------------VERIFICATION-----------------------\n"
    BANNER_FINISHED="\n--------------------FINISHED------------------------\n"
    mkdir -p $LOG_DIR_PATH && touch $LOG_FILE_PATH
    mkdir -p ./offline/$SOFTWARE_NAME/files/
    # Obtain owner's PGP public key
    printf $BANNER_OWNER_PGP
    printf $BANNER_OWNER_PGP >> $LOG_FILE_PATH
    if [[ $HTTP_LINK_OWNER_PGP =~ REGEX_URL_VALID ]] 
    then
        echo "OWNER PUBLIC KEY: Downloading from $HTTP_LINK_OWNER_PGP ..."
        wget -nv -O - --show-progress $HTTP_LINK_OWNER_PGP -P > $OFFLINE_OPK -a $LOG_FILE_PATH
        gpg --import $OFFLINE_OPK
    else
        echo "OWNER PGP PUBLIC KEY: Loading from $HTTP_LINK_OWNER_PGP"
        mv "$HTTP_LINK_OWNER_PGP" "$OFFLINE_OPK"
    fi

    # Obtain software SHA256SUMS
    # DEBUG:  Get files saved as SHA256SUMS and SHA256SUMS.gpg
    printf $BANNER_SHA
    printf $BANNER_SHA >> $LOG_FILE_PATH
    if [[ $HTTP_LINK_SOFTWARE_SHA =~ REGEX_URL_VALID ]] 
    then
        echo "SHA256SUMS: Downloading from $HTTP_LINK_SOFTWARE_SHA ..."            
        wget -r -l 1 -nv -nd -A "sha256sum*" --ignore-case --show-progress $HTTP_LINK_SOFTWARE_SHA -P $OFFLINE_FILES -a $LOG_FILE_PATH
    else
        echo "SHA256SUMS: Loading from $HTTP_LINK_SOFTWARE_SHA"
        mv "$HTTP_LINK_SOFTWARE_SHA/sha*" $OFFLINE_FILES 
        mv "$HTTP_LINK_SOFTWARE_SHA/SHA*" $OFFLINE_FILES
    fi

    # Obtain software
    printf $BANNER_SOFTWARE
    printf $BANNER_SOFTWARE >> $LOG_FILE_PATH
    if [[ $HTTP_LINK_SOFTWARE =~ REGEX_URL_VALID ]] 
    then
        echo "SOFTWARE: Downloading from $HTTP_LINK_SOFTWARE ..."
        wget -nv --show-progress $HTTP_LINK_SOFTWARE -P $OFFLINE_FILES -a $LOG_FILE_PATH
    else
        echo "SOFTWARE: Loading from $HTTP_LINK_SOFTWARE"
        mv $HTTP_LINK_SOFTWARE $OFFLINE_FILES
    fi

    # Verify software
    printf $BANNER_VERIFICATION
    printf  $BANNER_VERIFICATION >> $LOG_FILE_PATH
    echo "Verifying software: $SOFTWARE_NAME ... "
    mv -n $OFFLINE_FILES/*.txt.asc $OFFLINE_FILES/*.asc $OFFLINE_FILES/SHA256SUMS.gpg
    mv -n $OFFLINE_FILES/sha256*.txt $OFFLINE_FILES/SHA256*.txt $OFFLINE_FILES/sha256sum $OFFLINE_FILES/sha256sums $OFFLINE_FILES/SHA256SUM $OFFLINE_FILES/SHA256SUMS

    cd $OFFLINE_PATH/files
    sha256sum -c SHA256SUMS 2>&1 | grep OK

    # Finish task, log results, exit.
    printf $BANNER_FINISHED
    printf $BANNER_FINISHED >> $LOG_FILE_PATH
    printf "Downloaded content location: file:/"
    readlink -f $OFFLINE_PATH
    printf "Log file location: file:/"
    readlink -f $LOG_FILE_PATH
}

main $1