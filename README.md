# Mail server as a Docker image

    > docker build -t pennasol.su/mail .
    > mkdir maildirs
    > docker run -p 25:25 -v `pwd`/maildirs:/var/mail pennasol.su/mail

Note: You have to setup a reverse DNS entry pointing back to your mail server's
hostname.
