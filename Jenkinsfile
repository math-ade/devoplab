pipeline {
    agent { label 'Staging-Agent' } 
    stages {
        stage('Build with Maven') {
            steps {
                dir('devopproject') {
                    sh 'mvn clean package -DskipTests'
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
