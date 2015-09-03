###
# Postfix
# Alex Suslov
###
FROM ubuntu:14.04
MAINTAINER Alex Suslov

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -q -y language-pack-ru
RUN update-locale LANG=ru_RU.UTF-8

# Install Postfix.
RUN echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt
RUN echo "postfix postfix/mailname string mail.pennasol.su" >> preseed.txt
# Use Mailbox format.
RUN debconf-set-selections preseed.txt
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix

ADD hostname.txt /etc/hostname
ADD etc-hosts.txt /etc/hosts

RUN postconf -e myhostname=mail.pennasol.su
RUN postconf -e mydestination="mail.pennasol.su, pennasol.su, localhost.localdomain, Localhost"
RUN postconf -e mail_spool_directory="/var/spool/mail/"
RUN postconf -e mailbox_command=""

# Add a local user to receive mail at someone@example.com, with a delivery directory
RUN useradd -s /bin/bash office
RUN mkdir /var/spool/mail/office



ADD etc-aliases.txt /etc/aliases
RUN chown root:root /etc/aliases
RUN newaliases
# Use syslog-ng to get Postfix logs (rsyslog uses upstart which does not seem
# to run within Docker).
RUN apt-get install -q -y syslog-ng-core syslog-ng syslog-ng-mod-smtp

EXPOSE 25

# ADD conf/main.cf /
# ADD conf/startservices.sh /
# RUN chmod +x startservices.sh

# ENTRYPOINT ["/startservices.sh"]

RUN chown root:root /etc/hosts
RUN chown office:mail /var/spool/mail/office

CMD ["sh", "-c", "service syslog-ng start ; service postfix start ; tail -F /var/log/mail.log"]