FROM centos:6
LABEL maintainer="Neil Farrington <me@neilfarrington.com>"

#To prevent DNS problemss
RUN echo 'nameserver 8.8.8.8' >> /etc/resolv.conf

# install required packages
RUN yum update -y
RUN yum -y install wget
RUN yum -y install tar
RUN yum -y install rsyslog
RUN yum -y install initscripts
RUN yum clean all

# download NLS
WORKDIR /tmp
RUN wget https://assets.nagios.com/downloads/nagios-log-server/nagioslogserver-latest.tar.gz
RUN tar xzf nagioslogserver-latest.tar.gz

# install NLS
WORKDIR nagioslogserver
RUN sed -i '/^do_install_check$/d' ./fullinstall
RUN touch installed.firewall
RUN ./fullinstall --non-interactive

# finalise build configuration
WORKDIR /usr/local/nagioslogserver
VOLUME ["/usr/local/nagioslogserver"]
EXPOSE 80 443 9300:9400 3515 5544 2056 2057 5544/udp

# configure start script
ADD start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]
