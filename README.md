# Mail server as a Docker image

## Build
```
docker build -t pennasol/postfix .
```
## Run
```
docker run -p 25:25 -v `pwd`/maildirs:/var/mail pennasol/postfix
```
## Run as demon
```
docker run -d --name postfix -p 25:25 -v `pwd`/maildirs:/var/mail pennasol/postfix
```
## Clean
```
docker rm `docker ps -a -q`
docker rmi `docker images -a -q`
```

