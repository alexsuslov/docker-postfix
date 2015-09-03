###
# Postfix
# Alex Suslov
###
FROM ubuntu:14.04

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get install postfix rsyslog -y

ADD conf/main.cf /
ADD conf/startservices.sh /
RUN chmod +x startservices.sh

ENTRYPOINT ["/startservices.sh"]