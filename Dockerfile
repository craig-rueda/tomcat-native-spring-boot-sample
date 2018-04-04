FROM craigrueda/tcnative:latest

MAINTAINER craig@craigrueda.com

# Make a self-signed cert...
RUN mkdir -p /certs \
    && cd /certs \
    && openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes -subj '/CN=localhost'

COPY target/tcnativeapp*.jar /app.jar
COPY entrypoint.sh /entrypoint.sh

EXPOSE 8080

ENV JAVA_OPTS="-Djava.library.path=${APR_LIB}" \
    SERVER_SSL_CERTIFICATEKEYFILE="/certs/key.pem" \
    SERVER_SSL_CERTIFICATEFILE="/certs/cert.pem"

ENTRYPOINT [ "/entrypoint.sh" ]