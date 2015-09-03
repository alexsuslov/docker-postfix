# Mail server as a Docker image

    > docker build -t pennasol/mail .
    > mkdir maildirs
    > docker run -p 25:25 -v `pwd`/maildirs:/var/mail pennasol/mail

Note: You have to setup a reverse DNS entry pointing back to your mail server's
hostname.

```
docker build -t pennasol/postfix .
```

```
docker run -d --name postfix -p 25:25 --restart always pennasol/postfix mail.pennasol.su
```
