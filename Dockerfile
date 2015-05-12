FROM        ubuntu:14.04.2
MAINTAINER  Justin Menga "justin.menga@yellow.co.nz"
ENV REPO_NAME=my-repository

# Instructions from: http://www.aptly.info/download/
RUN echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list; \
apt-key adv --keyserver keys.gnupg.net --recv-keys 2A194991; \
apt-get update; \
apt-get install aptly -y

# Exposing salt master and api ports
EXPOSE 80

# Add and set start script
ADD keys/gpgkey_pub.gpg /etc/aptly/keys/gpgkey_pub.gpg
ADD keys/gpgkey_sec.gpg /etc/aptly/keys/gpgkey_sec.gpg
ADD start.sh start.sh
ADD aptly.conf /etc/aptly/aptly.conf

# Expose volumes
VOLUME ["/aptly", "/etc/aptly", "/etc/aptly/packages", "/etc/aptly/keys"]
	
CMD ["bash", "start.sh"]