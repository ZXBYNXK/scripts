#!/bin/bash
# Source: https://github.com/ZXBYNXK/scripts/bash/auto-git-ssh-setup.sh
printf "Email: "
read email
echo "Generating ssh key for $email"
ssh-keygen -t rsa -b 4096 -C "$email"
cat ~/.ssh/id_rsa.pub
echo "Go to https://github.com/settings/keys and copy then paste the above. (IMPORTANT)"
printf "Done with the above? (Hit Enter)"
read none
echo "Testing SSH to git@github.com ..."
ssh -T git@github.com || echo "Something is wrong :( **see comments in this file**"
# (Caution) If test did not work check your input, see 'COMMAND: ...' (i.e. Not found, not installed, unsupported). 
#  Unfortunately if there is no solution then web search your error logs :("
# Above git remote commands only needed for existing repos not using SSH (IMPORTANT) Otherwise you are successfully SSH configured.
# echo Feel free to change this code :) or open an issue @https://github.com/ZXBYNXK/scripts/issues
