# Minimal Config for Cloudera Agent - CDH 5 Based on Ubuntu Xenial

FROM ubuntu:16.04

#Setup SSH
RUN apt-get -qq update && apt-get -qq install -y openssh-server curl vim apt-transport-https ca-certificates iputils-ping
EXPOSE 22 9000 9001
RUN mkdir /var/run/sshd
RUN echo 'root:wandisco999' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
CMD ["/usr/sbin/sshd", "-D"]
RUN service ssh restart

# Add a Repository Key
RUN curl -L https://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/cloudera.list -o /etc/apt/sources.list.d/cloudera.list
# Add the Cloudera Public GPG Key to your repository
RUN curl -L http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/archive.key -o archive.key
RUN apt-key add archive.key

# Clean repository cache

RUN apt-get -qq update && apt-get -qq install -y perl apache2 netbase python2.7-minimal fuse mysql-common ntp make ssl-cert rename netbase x11-common 
RUN service ntp start

