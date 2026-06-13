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
        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'devopproject/target/*.jar', followSymlinks: false
            }
        }
        stage('Run Java Application') {
            steps {
                sh '''
                    # Kill any old version running on port 8081 to avoid crashes
                    pkill -f "devopproject.*.jar" || true
                    
                    # Launch application on port 8081 in the background
                    nohup java -jar -Dserver.port=8081 devopproject/target/devopproject-1.0-SNAPSHOT.jar > app.log 2>&1 &
                    sleep 2
                '''
            }
        }
    }
}
