ecrAcc=$1
ecrRepo=$2

tmpLog="tmp.log"

cd app
cat >> "Dockerfile" << EOF
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
