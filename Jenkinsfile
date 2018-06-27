pipeline {
    agent {
                label 'swarm'
            }
    stages {
        stage('Build Stage') {
            steps {
                echo "Run docker build Stage"
                script {
                    def customImage = docker.build("catalinalab/jenkins-swarm:${BUILD_NUMBER}")
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-catalinalab') {
                        echo "Pushing artifacts to registry"
                        customImage.push()
                        customImage.push("latest")
                    }
                }
            }
        }
        stage('deploy'){
          agent {
            label 'deb-04'
          }
          steps{
            echo "Start deploy"
            sh "chmod +x ./run.sh && ./run.sh"
          }
        }
    }
}