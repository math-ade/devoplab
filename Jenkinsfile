pipeline {
    agent { label 'Staging-Agent' }
    environment {
        JAVA_HOME = '/usr/lib/jvm/java-21-amazon-corretto.x86_64'
        PATH = "${env.JAVA_HOME}/bin:${env.PATH}"
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com'
            }
        }
        stage('Build with Maven') {
            steps {
                dir('devopproject') {
                    sh 'mvn clean package -DskipTests -Dmaven.test.skip=true'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'sudo docker build -t devopproject:latest .'
            }
        }
        stage('Deploy Staging Container') {
            steps {
                sh '''
                    sudo docker stop devops-staging || true
                    sudo docker rm devops-staging || true
                    sudo docker run -d --name devops-staging -p 8081:8081 devopproject:latest
                '''
            }
        }
    }
    // Automated alerts system block
    post {
        always {
            echo "Pipeline complete. Processing status logs..."
        }
        success {
            emailext body: "Build Successful! My-First-Java-App Build #${env.BUILD_NUMBER} has deployed cleanly to production.",
                     subject: "SUCCESS: Jenkins Build #${env.BUILD_NUMBER}",
                     to: "your-email@example.com"
        }
        failure {
            emailext body: "Pipeline crashed at build stage level. Check console logs for Build #${env.BUILD_NUMBER}.",
                     subject: "FAILURE: Jenkins Build #${env.BUILD_NUMBER}",
                     to: "your-email@example.com"
        }
    }
}
