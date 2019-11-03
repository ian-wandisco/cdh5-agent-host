# Cloudera Agent

FROM ubuntu:16.04

#ENV CM_SERVER_URL 172.31.4.74

#SSH
RUN apt-get -qq update && apt-get -qq install -y openssh-server curl vim apt-transport-https ca-certificates iputils-ping

RUN mkdir /var/run/sshd
RUN echo 'root:wandisco99' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22 9000 9001
CMD ["/usr/sbin/sshd", "-D"]
RUN service ssh restart
# Add a Repository Key
RUN curl -L https://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/cloudera.list -o /etc/apt/sources.list.d/cloudera.list
# Add the Cloudera Public GPG Key to your repository
RUN curl -L http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/archive.key -o archive.key
RUN apt-key add archive.key
# Clean repository cache

RUN apt-get -qq update && apt-get -qq install -y perl apache2 netbase python2.7-minimal fuse mysql-common  ntp make ssl-cert rename netbase 

#RUN apt-get update && apt-get -qq install -y cloudera-manager-agent cloudera-manager-daemons
#RUN service cloudera-scm-agent stop
#RUN sed -i "s|server_host=.*|server_host=${CM_SERVER_URL}|" /etc/cloudera-scm-agent/config.ini
#RUN service cloudera-scm-agent restart

#ADD post-install.sh /tmp/post-install.sh
#RUN chmod +x /tmp/post-install.sh
#RUN /bin/bash -c /tmp/post-install.sh
