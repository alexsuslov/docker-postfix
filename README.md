# Mail server as a Docker image

## Build
```
docker build -t pennasol/postfix .
```
## Run
```
docker run -d --name postfix -p 25:25  pennasol/postfix mail.pennasol.su
```
