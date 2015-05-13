# Docker Aptly

A Docker image for creating and publishing an Ubuntu repository using <a href="http://aptly.info" target="_blank">aptly</a>.


## Quick Start

On container start, this image will:

* Create a repository defined by the environment variable `REPO_NAME` (set to "my-repository" by default).
* Install any packages found in `/etc/aptly/packages`.  This is exposed as a volume so you can mount this volume externally.
* Serve the repository on container port 8888.

For example, to create a repo called "yellow-repo", install any packages in `/hostpath/to/packages` on the Docker host and serve the repo externally on port 80:
  
```console
docker run -d --name aptly -e REPO_NAME=yellow-repo -p 80:8888 -v /hostpath/to/packages:/etc/aptly/packages cloudhotspot/aptly
```

## Testing

On a remote Ubuntu host import the GPG key for your repository.  You can use the baked in GPG key which has a key ID of 06956C56, or you can follow the steps in the [GPG Keys](#gpg-keys) section to use your own GPG key.

```console
$ gpg --keyserver keys.gnupg.net --recv-keys 06956C56
gpg: requesting key 06956C56 from hkp server keys.gnupg.net
gpg: /root/.gnupg/trustdb.gpg: trustdb created
gpg: key 06956C56: public key "Example Key (Simple solution) <key@example.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)
$ gpg -a --export 06956C56 | sudo apt-key add -
OK
```

Next add your new repository to `/etc/apt/sources.list`

```console
$ echo "deb http://your.docker.host/ trusty main" >> /etc/apt/sources.list
$ apt-get update
Get:1 http://your.docker.host trusty InRelease [2741 B]
Ign http://archive.ubuntu.com trusty InRelease
...
Reading package lists... Done
```

Finally test installing a package.  This repository includes an example package `rubygem-hello-world` in `/packages` that you can test installing (this requires you to mount `/packages` as a volume when you run the aptly container).

```console
$ apt-get install rubygem-hello-world
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following extra packages will be installed:
  ca-certificates libruby1.9.1 libyaml-0-2 openssl ruby ruby1.9.1
Suggested packages:
  ri ruby-dev ruby1.9.1-examples ri1.9.1 graphviz ruby1.9.1-dev ruby-switch
The following NEW packages will be installed:
  ca-certificates libruby1.9.1 libyaml-0-2 openssl ruby ruby1.9.1
  rubygem-hello-world
...
...
Running hooks in /etc/ca-certificates/update.d....done.
$ hello-world
this is executable hello-world
```
## Custom Configuration

By default, the image uses the following aptly configuration file.  This file is located in `/etc/aptly/aptly.conf`:

```
{
  "rootDir": "/aptly",
  "downloadConcurrency": 4,
  "downloadSpeedLimit": 0,
  "architectures": ["i386", "amd64"],
  "dependencyFollowSuggests": false,
  "dependencyFollowRecommends": false,
  "dependencyFollowAllVariants": false,
  "dependencyFollowSource": false,
  "gpgDisableSign": false,
  "gpgDisableVerify": false,
  "downloadSourcePackages": false,
  "ppaDistributorID": "ubuntu",
  "ppaCodename": "",
  "S3PublishEndpoints": {
  },
  "SwiftPublishEndpoints":{	
  }
}
```

`etc/aptly` is exposed as a volume so you can mount your own configuration file as follows:

```
docker run -d --name aptly -e REPO_NAME=yellow-repo -p 80:8888 -v /hostpath/to/conf/:/etc/aptly cloudhotspot/aptly
```

Note that the location of the `rootDir` setting must reflect the value of the `REPO_PATH` environment variable (set to `/aptly/base` by default). 

## GPG Keys

Docker containers have very low system entropy which means generating keys can take hours.  Hence keys need to be generated externally.

The image has a couple of baked-in GPG keys which you should replace if using this for anything other than testing/prototyping.

### Generating GPG Keys

The following provides an example of generating GPG keys on an OS X host.

Step 1.  Generate your GPG keys

```console
	# OS X Example
	
	$ brew install Caskroom/cask/gpgtools
	...
	...
	$ gpg --gen-key
	gpg (GnuPG/MacGPG2) 2.0.27; Copyright (C) 2015 Free Software Foundation, Inc.
	This is free software: you are free to change and redistribute it.
	There is NO WARRANTY, to the extent permitted by law.
	
	Please select what kind of key you want:
	   (1) RSA and RSA (default)
	   (2) DSA and Elgamal
	   (3) DSA (sign only)
	   (4) RSA (sign only)
	Your selection? 1
	RSA keys may be between 1024 and 8192 bits long.
	What keysize do you want? (2048) 2048
	Requested keysize is 2048 bits
	Please specify how long the key should be valid.
	         0 = key does not expire
	      <n>  = key expires in n days
	      <n>w = key expires in n weeks
	      <n>m = key expires in n months
	      <n>y = key expires in n years
	Key is valid for? (0) 0
	Key does not expire at all
	Is this correct? (y/N) y
	
	GnuPG needs to construct a user ID to identify your key.
	
	Real name: Example Key
	Email address: key@example.com
	Comment: Simple solution
	You selected this USER-ID:
	    "Example Key (Simple solution) <key@example.com>"
	
	Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
	You need a Passphrase to protect your secret key.
	
	You don't want a passphrase - this is probably a *bad* idea!
	I will do it anyway.  You can change your passphrase at any time,
	using this program with the option "--edit-key".
	
	We need to generate a lot of random bytes. It is a good idea to perform
	some other action (type on the keyboard, move the mouse, utilize the
	disks) during the prime generation; this gives the random number
	generator a better chance to gain enough entropy.
	We need to generate a lot of random bytes. It is a good idea to perform
	some other action (type on the keyboard, move the mouse, utilize the
	disks) during the prime generation; this gives the random number
	generator a better chance to gain enough entropy.
	gpg: key 06956C56 marked as ultimately trusted
	public and secret key created and signed.
	
	gpg: checking the trustdb
	gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
	gpg: depth: 0  valid:   2  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 2u
	pub   2048R/06956C56 2015-05-12
	      Key fingerprint = 1040 9D11 3C80 53FE 7A1E  6A4E B701 4BFE 0695 6C56
	uid       [ultimate] Example Key (Simple solution) <key@example.com>
	sub   2048R/95F251BE 2015-05-12
```

Step 2.  Note the ID of the key that was created.  In the example output above, the ID is listed on the line:

``` console
	...
	gpg: key 06956C56 marked as ultimately trusted
	...
```

Step 3.  Export the GPG keys to files:

``` console
	$ gpg --output gpgkey_pub.gpg --armor --export 06956C56
	$ gpg --output gpgkey_sec.gpg --armor --export-secret-key 06956C56
	
	$ export GPG_PUBLIC_KEY=`cat gpgkey_pub.gpg`
	$ export GPG_PRIVATE_KEY=`cat gpgkey_sec.gpg`
```

Step 4.  Publish the GPG key:

``` console
	$ gpg --send-key 06956C56
	gpg: sending key 06956C56 to hkps server hkps.pool.sks-keyservers.net
	
```

Now that you have generated a GPG key pair, there are two ways of replacing the keys in the container as described below.

### Re-build the image with your own keys (RECOMMENDED)

Simple replace the public and private key files in the `keys` folder under your Dockerfile root and rebuild the image.

```console
$ ls -l keys/*
total 16
-rw-r--r--  1 bob  staff  1741 13 May 01:30 gpgkey_pub.gpg
-rw-r--r--  1 bob  staff  3507 13 May 01:30 gpgkey_sec.gpg

$ docker build -t myaccount/aptly .
Sending build context to Docker daemon 114.2 kB
...
...
```

This method is non-destructive of your key files so you will need to clean up (delete) the GPG key files from your build machine yourself.

### Mount `/etc/aptly/keys` to your Docker host when running the container

This approach allows you to "override" the baked-in `/etc/aptly/keys` folder and mount the `/etc/aptly/keys` from your Docker host.

Note that the `start.sh` script deletes GPG key files after import, so they will be deleted from your Docker host after first container run.

```console
$ docker run -d --rm --name aptly -p 80:8888 -v /hostpath/to/keys:/etc/aptly/keys cloudhotspot/aptly 
```
