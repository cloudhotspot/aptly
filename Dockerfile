FROM        ubuntu:14.04.2
MAINTAINER  Justin Menga "justin.menga@cloudhotspot.co"
ENV REPO_NAME=my-repository REPO_CONF=/etc/aptly/conf/aptly.conf

# Instructions from: http://www.aptly.info/download/
RUN echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list; \
apt-key adv --keyserver keys.gnupg.net --recv-keys 2A194991; \
apt-get update; \
apt-get install aptly supervisor -y

EXPOSE 8888 8889

# Add and set start script
ADD keys/gpgkey_pub.gpg /etc/aptly/keys/gpgkey_pub.gpg
ADD keys/gpgkey_sec.gpg /etc/aptly/keys/gpgkey_sec.gpg
ADD start.sh /etc/aptly/start.sh
ADD start_api.sh /etc/aptly/start_api.sh
ADD aptly.conf $REPO_CONF
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose volumes
VOLUME ["/etc/aptly/packages", "/etc/aptly/conf", "/etc/aptly/keys", "/aptly"]

CMD ["/usr/bin/supervisord"]
