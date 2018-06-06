ecrAcc=$1
ecrRepo=$2

tmpLog="tmp.log"

cd app
cat >> "Dockerfile" << EOF
FROM 3.5.3-jdk-8-alpine as BUILD
WORKDIR /usr/src/
COPY . .
RUN cd initial && mvn package

# STAGE 2 - Test service 
#RUN apt-get update && apt-get install curl -y
#RUN java -jar /usr/src/initial/target/gs-spring-boot-0.1.0.jar
#RUN curl http://localhost:8080

# STAGE 3 - Pack container
FROM tomcat:alpine
EXPOSE 80
RUN mkdir app
WORKDIR /app
COPY --from=BUILD /usr/src/initial/target/gs-spring-boot-0.1.0.jar /app/
ENTRYPOINT ["java", "-jar", "gs-spring-boot-0.1.0.jar"]
EOF

ecrlogin=$(~/.local/bin/aws ecr get-login --no-include-email --region us-east-1)
sudo $ecrlogin

sudo docker build -t ${ecrAcc}/${ecrRepo} . > "${tmpLog}"
cat "${tmpLog}"
grep -q "Successfully built" ""${tmpLog}""
if [ $? -ne 0 ]; then {
    echo "Docker has been built with error"
    exit 1
} else {
    echo "Docker has been built successfully"
    rm -f "${tmpLog}"
    }
fi

sudo docker push ${ecrAcc}/${ecrRepo}:latest > "${tmpLog}"
cat "${tmpLog}"
grep -q "digest" ""${tmpLog}""
if [ $? -ne 0 ]; then {
    echo "Docker image has been pushed with error"
    exit 1
} else {
    echo "Docker image has been pushed successfully"
    rm -f "${tmpLog}"
}
fi
