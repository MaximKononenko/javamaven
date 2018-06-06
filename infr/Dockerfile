FROM andreptb/maven:latest as BUILD
WORKDIR /usr/src/
COPY . .
RUN ls -la /usr/src/initial
RUN cd initial && mvn package
RUN ls -la /usr/src/initial/target

# STAGE 2 - Pack container
FROM tomcat:alpine
ENV VERSION 0.0.1
COPY --from=BUILD /usr/src/initial/target/gs-spring-boot-0.1.0.jar /usr/local/tomcat/webapps/
EXPOSE 8080/tcp
