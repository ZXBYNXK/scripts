#!/bin/bash
# Source: https://github.com/ZXBYNXK/scripts/bash/auto-git-ssh-setup.sh
# Help: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

# Obtain end user email
printf "Email: "
read email

# Generate a ssh key with specified email
# Info: https://www.ssh.com/academy/ssh/keygen#what-is-ssh-keygen?
echo "Generating SSH key for $email (Use default values below)"
ssh-keygen -t rsa -b 4096 -C "$email"

# Show end user their public ssh key and direct them to copy and paste it to the link provided
echo "------------------------------------------------------------"
cat ~/.ssh/id_rsa.pub
echo "------------------------------------------------------------"
echo "Go to https://github.com/settings/keys and copy then paste the above public key. (IMPORTANT)"
echo "NOTE: Copy text inbetween the dashes!"

# End user needs to complete the above for the below to execute
printf "Done with the above? (Hit Enter)"
read none

# Start ssh-agent to manage client authenticity on ssh protocol connections
# Info: https://www.ssh.com/academy/ssh/agent
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
echo "Starting ssh-agent..."
eval "$(ssh-agent -s)"

# Add the private key into current running ssh-agent
# Info: https://www.ssh.com/academy/ssh/add
echo "Adding private key for $email to ssh-agent..."
ssh-add ~/.ssh/id_rsa

# To avoid client not knowing if ssh connection to github is authentic (May see this when pushing a commit)
# Info: https://github.com/ome/devspace/issues/38#issuecomment-211515244
echo "Adding kown_hosts for github (~/.ssh/known_hosts)..."
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Run a test to let the end user know if connection is good
echo "Testing SSH to git@github.com connection..."
ssh -T git@github.com || echo "Something is wrong :( >>> See: https://docs.github.com/en/authentication/connecting-to-github-with-ssh"