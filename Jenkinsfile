        stage('Run Java Application') {
            steps {
                sh '''
                    # Kill any stale versions running on port 8081
                    pkill -f "devopproject.*.jar" || true
                    
                    # Force the embedded engine to bind to 0.0.0.0 (Global Internet)
                    nohup java -jar -Dserver.address=0.0.0.0 -Dserver.port=8081 devopproject/target/devopproject-1.0-SNAPSHOT.jar > app.log 2>&1 &
                    sleep 2
                '''
            }
        }
