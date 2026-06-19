pipeline {
    agent { label 'Staging-Agent' }
    environment {
        // Explicitly force the Java 21 path we verified on Workstation 2
        JAVA_HOME = '/usr/lib/jvm/java-21-amazon-corretto.x86_64'
        PATH = "${env.JAVA_HOME}/bin:${env.PATH}"
    }
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
