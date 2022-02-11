#!/bin/bash
output[ask][o_key_sig_url] = "Official key source (https://<URL>/<FILE-NAME>.asc):"


main() {

    ask "OKS"
}

ask() {
    if [[ $1 == "OKS" ]]; then
        printf $output[o_key_sig_url]
        read 
    fi
}



# read official_key_source
# echo "Downloading official key @$official_key_source..."
# wget -q -O - $official_key_source | gpg --import
# gpg --fingerprint 44C6513A8E4FB3D30875F758ED444FF07D8D0BF6

