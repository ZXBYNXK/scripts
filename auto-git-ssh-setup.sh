#!/bin/bash
echo "Auto Git SSH Configuration"
echo "Author & Source: https://github.com/ZXBYNXK/scripts/bash/git/auto-git-ssh-conf.sh "
printf "Email: "
read email
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
