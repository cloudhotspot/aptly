#!/bin/bash
# Check if the repository already exists
PACKAGES=/etc/aptly/packages/*

# Import GPG Keys
gpg --list-keys | grep -qv '.'
if [ $? -eq 1 ]; then
    gpg --import /etc/aptly/keys/gpgkey_pub.gpg
    gpg --allow-secret-key-import --import /etc/aptly/keys/gpgkey_sec.gpg
    rm /etc/aptly/keys/*.gpg
fi

aptly repo list -config=$REPO_CONF -raw=true | grep -xq $REPO_NAME
if [ $? -eq 1 ]; then
    aptly repo create -distribution=trusty -component=main -config=$REPO_CONF  $REPO_NAME
    for p in $PACKAGES
    do
        aptly repo add -config=$REPO_CONF $REPO_NAME $p
    done
    aptly publish --distribution=trusty -config=$REPO_CONF repo $REPO_NAME
fi

exec aptly serve -listen=":8888" -config=$REPO_CONF
