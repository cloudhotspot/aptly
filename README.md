# Docker Aptly

A Docker image for creating and publishing an Ubuntu repository using <a href="http://aptly.info" target="_blank">aptly</a>.

## Instructions

### GPG Keys

The image has a couple of baked in GPG keys which you should replace.

You can replace thes GPG keys as follows:

Step 1.  Generate your GPG keys

```console
	# OS X Example
	
	$ brew uninstall Caskroom/cask/gpgtools
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

Step 3.  Export the GPG keys to environments variables as follows:

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