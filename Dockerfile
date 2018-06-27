#maintainer 
MAINTAINER kononenkomi@gmail.com
FROM maven:alpine as BUILD
WORKDIR /app
ADD ./complete/src .
ADD ./complete/pom.xml .
RUN pwd && ls -la
RUN cd /app && mvn clean install

FROM java:8
ENV VERSION 0.0.1
COPY --from=BUILD /app/target/*.jar /app/hello-world-0.1.0.jar
EXPOSE 8080/tcp
#default command
CMD java -jar /app/hello-world-0.1.0.jar