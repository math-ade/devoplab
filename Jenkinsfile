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
        stage('SonarQube Analysis') {
            steps {
                dir('devopproject') {
                    sh 'mvn sonar:sonar -Dsonar.host.url=http://127.0.0.1:9000 -Dsonar.token=squ_f380980e4e9d35aff5247d4c85b473e9fa5841eb'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devopproject:latest .'
            }
        }
        stage('Deploy Staging Container') {
            steps {
                sh '''
                    docker stop devops-staging || true
                    docker rm devops-staging || true
                    docker run -d --name devops-staging -p 8081:8081 devopproject:latest
                '''
            }
        }
    }
}
