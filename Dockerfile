FROM ubuntu:14.04

RUN \
	sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
 	apt-get update && \
 	apt-get -y upgrade && \
	apt-get install -q -y language-pack-ru && \
	update-locale LANG=ru_RU.UTF-8

RUN echo mail > /etc/hostname
ADD etc-hosts.txt /etc/hosts
RUN chown root:root /etc/hosts

RUN apt-get install -q -y nano

# Install Postfix.
RUN echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt
RUN echo "postfix postfix/mailname string mail.pennasol.su" >> preseed.txt
# Use Mailbox format.
RUN debconf-set-selections preseed.txt
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix

RUN postconf -e myhostname=mail.pennasol.su
RUN postconf -e mydestination="mail.pennasol.su, pennasol.su, localhost.localdomain, localhost"
RUN postconf -e mail_spool_directory="/var/spool/mail/"
RUN postconf -e mailbox_command=""

# Add a local user to receive mail at someone@example.com, with a delivery directory
# (for the Mailbox format).
RUN useradd -s /bin/bash office
RUN mkdir /var/spool/mail/office
RUN chown office:mail /var/spool/mail/office

ADD etc-aliases.txt /etc/aliases
RUN chown root:root /etc/aliases
RUN newaliases

# Use syslog-ng to get Postfix logs (rsyslog uses upstart which does not seem
# to rum within Docker).
RUN apt-get install -q -y syslog-ng

EXPOSE 25
CMD ["sh", "-c", "service syslog-ng start ; service postfix start ; tail -F /var/log/mail.log"]
