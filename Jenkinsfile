pipeline {
    agent any
    tools {
        maven 'maven 3'
        jdk 'java 21'
    }
    stages {
        stage('Build with Maven') {
            steps {
                dir('devopproject') {
                    sh 'mvn clean package'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                // This converts your JAR file into an isolated container image
                sh 'docker build -t devopproject:latest .'
            }
        }
        stage('Deploy Staging Container') {
            steps {
                sh '''
                    # Clear out any old versions to avoid conflicts
                    docker stop devops-staging || true
                    docker rm devops-staging || true
                    
                    # Launch your containerized application out to the internet
                    docker run -d --name devops-staging -p 8081:8081 devopproject:latest
                '''
            }
        }
    }
}
