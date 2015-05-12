#!/bin/bash
# Check if the repository already exists
PACKAGES=/etc/aptly/packages/*


# Import GPG Keys
# Need to execute this command TWICE!
gpg --list-keys
gpg --list-keys
gpg --list-keys | grep -qv '.'
if [ $? -eq 1 ]; then
    gpg --import /etc/aptly/keys/gpgkey_pub.gpg
    gpg --allow-secret-key-import --import /etc/aptly/keys/gpgkey_sec.gpg
fi

aptly repo list -config=/etc/aptly/aptly.conf -raw=true | grep -xq $REPO_NAME
if [ $? -eq 1 ]; then
    aptly repo create -distribution=trusty -component=main -config=/etc/aptly/aptly.conf  $REPO_NAME
    for p in $PACKAGES
    do
        aptly repo add -config=/etc/aptly/aptly.conf $REPO_NAME $p
    done
    aptly publish --distribution=trusty -config=/etc/aptly/aptly.conf repo $REPO_NAME
fi

exec aptly serve -listen=":80" -config=/etc/aptly/aptly.conf
