# Download
An automated shell script for securely downloading <br />
i.e.: Verify integrety of software with PGP keys & sha256sums verificaton.
Dependencies: gpg, wget, sha256sums

## Setup
Where to begin HOME/USERNAME/GIT-CLONE-LOCATION/scripts/bash/download

```bash
$ pwd
    /home/zxbynxk/Documents/scripts/bash/download

$ chmod +x ./main.sh

$ cat ./example/centos.txt
    CentOS
    https://www.centos.org/keys/RPM-GPG-KEY-CentOS-7
    http://mirror.cs.pitt.edu/centos/7.9.2009/isos/x86_64/
    http://mirror.cs.pitt.edu/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-Everything-2009.iso

$ ./main.sh ./example/centos.txt

$ ls ./verified/centos
    sha256sum.txt sha256sum.gpg centos.gpg centos log/
```

## Usage
```bash
$ ./scripts/bash/download/main.sh <FILE>.txt 
```

File format = any.txt 
See example [./download/example/centos.txt](#)
```
<SOFTWARE-NAME>
<URL-WHERE-SOFTWARE-OWNER-PUBLIC-PGP-KEY-IS-LOCATED>
<URL-WHERE-SHA256SUMS-IS-LOCATED>
<URL-WHERE-SOFTWARE-IS-LOCATED>
``` 
