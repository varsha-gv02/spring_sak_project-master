pipeline {
    agent any

    tools {
        maven 'maven'
    }

    environment {
        IMAGE_NAME = "yourdockerhubusername/spring_app_sak"
        IMAGE_TAG = "v1.0.${BUILD_NUMBER}"
        CONTAINER_NAME = "spring_app_container"
    }

    stages {

        stage('Build Maven Project') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    echo "Building Docker image..."
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo "Logging into Docker Hub..."
                        echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                    echo "Pushing Docker image..."
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Deploy Container') {
            steps {
                sh """
                    echo "Stopping existing container if running..."
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true

                    echo "Running new container..."
                    docker run -d -p 8080:8080 --name ${CONTAINER_NAME} ${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Remove Local Docker Image') {
            steps {
                sh """
                    echo "Removing local Docker image..."
                    docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true
                """
            }
        }
    }

    post {
        success {
            echo "Build and Deployment Successful ✅"
        }
        failure {
            echo "Build or Deployment Failed ❌"
        }
    }
}
