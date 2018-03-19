FROM mono:latest
MAINTAINER Roger Castaldo <roger.castaldo@gmail.com>

RUN apt-get update -qq && \
	apt-get upgrade -qq -y && \
	apt-get install -qq curl tzdata binutils ca-certificates-mono fsharp mono-vbnc apache2 libapache2-mod-mono mono-apache-server4 mono-xsp4-base  -y && \
	apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/tmp/* && \
    rm -rf /tmp/* && \
	rm -rf /var/lib/apt/lists/*
	
RUN a2enmod mod_mono \
    && service apache2 stop \
    && mkdir -p /etc/mono/registry /etc/mono/registry/LocalMachine \
    && sed -ri ' \
      s!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g; \
      s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g; \
      ' /etc/apache2/apache2.conf

RUN rm -rf /etc/apache2/sites-enabled/000-default.conf
ADD ./config/apache2-site.conf /etc/apache2/sites-enabled/000-default.conf

WORKDIR /var/www
EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
