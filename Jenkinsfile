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
                // This builds a container package out of your JAR file
                sh 'docker build -t devopproject:latest .'
            }
        }
        stage('Deploy Staging Container') {
            steps {
                sh '''
                    # Stop and clear the old container to avoid name clashes
                    docker stop devops-staging || true
                    docker rm devops-staging || true
                    
                    # Run your app inside the isolated Docker environment
                    docker run -d --name devops-staging -p 8081:8081 devopproject:latest
                '''
            }
        }
    }
}
