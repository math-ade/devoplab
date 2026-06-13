pipeline {
    agent any
    tools {
        maven 'maven 3'
        jdk 'java 21'
    }
    stages {
        stage('Wipe Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Build with Maven') {
            steps {
                dir('devopproject') {
                    sh 'mvn clean package'
                }
            }
        }
        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'devopproject/target/*.jar', followSymlinks: false
            }
        }
        stage('Run Java Application') {
            steps {
                sh '''
                    nohup java -jar devopproject/target/devopproject-1.0-SNAPSHOT.jar > app.log 2>&1 &
                    sleep 2
                '''
            }
        }
    }
}
