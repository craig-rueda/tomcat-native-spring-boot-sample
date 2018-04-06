# Spring Boot with Embedded Tomcat + APR/OpenSSL sample

This sample project shows how to build a Spring Boot 2.0 app using Embedded Tomcat 
leveraging both Tomcat's AprConnector, as well as Tomcat Native for handling SSL.

## Why??

If you've ever perf tested JSSE's SSL handling, you'd know that it's SLOW! In order to
take advantage of native libraries, such as OpenSSL, the
[Tomcat native](http://tomcat.apache.org/native-doc/) library was built, along with
the `org.apache.coyote.http11.Http11AprProtocol` which comes built into Tomcat and 
operates in conjunction with native bindings provided by tcnative.

## Building

1. Build the included source

    ```shell
    $ ./mvnw install
    ```
    
2. Build the docker image

    ```shell
    $ docker build -t apr-sample .
    ```
    
3. Run it!

    ```shell
    $ docker run -itP --rm apr-sample
    ```

## Running things locally (OSX) 

1. Install OpenSSL 1.0.2+

    ```shell
    $ brew install openssl
    ``` 

2. Install APR 

    ```shell
    $ brew install apr    
    ```
    
3. Download the latest Tomcat [release](https://tomcat.apache.org/download-80.cgi)

4. Extract tomcat somewhere and cd into the `bin` folder

5. Extract the file `tomcat-native.tar.gz`

6. cd into `tomcat-native-<version>-src/native`

7. Configure using the aforementioned OpenSSL

    ```shell
    $ ./configure --with-ssl=/usr/local/Cellar/openssl/1.0.2o
    ```

8. Copy your built libs to a well known location

    ```shell
    $ cp ./.libs/* /usr/lib/tcnative
    ```

9. Set the Java lib path appropriately

    ```shell
    $ java ... -Djava.library.path=/usr/lib/tcnative ...
    ``` 

## Creating certificates

1. Create a self-signed cert using OpenSSL

    ```shell
    $ openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes -subj '/CN=localhost'
    ```
    
2. Import your key/cert into a Java Keystore

    ```shell
    # First, create a PKCS12 file which contains both your pkey, along with your cert
    $ openssl pkcs12 -export -out keyStore.p12 -inkey key.pem -in cert.pem
    
    # Next, import your pkey/cert into a JKS file
    $ keytool -importkeystore -deststorepass password -destkeypass password -destkeystore keystore.jks -srckeystore keyStore.p12 -srcstoretype PKCS12 -srcstorepass password -alias 1
    ```