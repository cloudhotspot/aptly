FROM        ubuntu:14.04.2
MAINTAINER  Justin Menga "justin.menga@yellow.co.nz"

# Instructions from: http://www.aptly.info/download/
RUN echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list; \
apt-key adv --keyserver keys.gnupg.net --recv-keys 2A194991; \
apt-get update; \
apt-get install aptly -y

# Create repo
RUN aptly repo create -distribution=trusty -component=main yellow-test-repo

# Expose volumes
# VOLUME ["/aptly"]

# Exposing salt master and api ports
EXPOSE 80

# Add and set start script
# ADD start.sh /start.sh
# CMD ["bash", "start.sh"]