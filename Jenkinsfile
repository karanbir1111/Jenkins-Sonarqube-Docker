pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "karan-sonar-app"
        CONTAINER_NAME = "onix-website-container"
        APP_PORT = "8085"
    }

    stages {
        stage('SonarQube Analysis') {
            steps {
                script {
                    // Pulls the scanner tool from Global Tool Configuration
                    def scannerHome = tool 'SonarScanner' 
                    
                    // 'SonarQubeServer' must match the Name in Manage Jenkins > System
                    withSonarQubeEnv('SonarQubeServer') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    // Waits for the Sonar VM to report back the results
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Docker Cleanup') {
            steps {
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
            }
        }

        stage('Build Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                sh "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
            }
        }

        stage('Deploy App') {
            steps {
                // Runs the container on port 8085
                sh "docker run -d --name ${CONTAINER_NAME} -p ${APP_PORT}:80 ${DOCKER_IMAGE}:latest"
            }
        }
    }

    post {
        success {
            echo "Successfully deployed! Access: http://<Jenkins-IP>:${APP_PORT}"
        }
        failure {
            echo "Build failed. Check the Jenkins Console or SonarQube Dashboard."
        }
    }
}
