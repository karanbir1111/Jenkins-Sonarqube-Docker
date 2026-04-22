pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "karan-sonar-app"
        CONTAINER_NAME = "sonarqube-service"
    }

    stages {
        stage('Docker Cleanup') {
            steps {
                // Remove existing container to avoid name/port conflicts
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
            }
        }

        stage('Build Image') {
            steps {
                // Build using the Dockerfile in the repo
                sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                sh "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
            }
        }

        stage('Deploy Container') {
            steps {
                // Run SonarQube on port 9000
                sh "docker run -d --name ${CONTAINER_NAME} -p 9000:9000 ${DOCKER_IMAGE}:latest"
            }
        }
    }

    post {
        success {
            echo "Successfully deployed SonarQube!"
        }
    }
}
