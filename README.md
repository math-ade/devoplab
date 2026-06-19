# Distributed CI/CD Pipeline for Enterprise Java Applications

A production-ready, multi-node Continuous Integration and Continuous Deployment (CI/CD) automation pipeline. This architecture decouples build orchestration from compute-heavy container runtimes to optimize performance and server resource allocation.

## 🏗️ System Architecture & Pictorial Diagram

```text
                       +-------------------------------------------------+

                       |                  GitHub Repo                    |
                       |          (math-ade/devoplab.git)                |
                       +-------------------------------------------------+
                                                |
                                                | Webhook Trigger (Port 80)
                                                v
+---------------------------------------------------------------------------------------------------+

| AWS EC2 Instance 1: Jenkins Controller (Master Node)                                              |
| • Public IP: 50.19.58.84                                                                          |
| • Tasks: Orchestration, Pipeline Syntax Parsing, User Access Management                           |
| • Security Filters: CSRF Protection, Default Crumb Issuer                                         |
+---------------------------------------------------------------------------------------------------+
                                                |
                                                | Secure SSH Tunnel (Port 22 Key Exchange)
                                                v
+---------------------------------------------------------------------------------------------------+

| AWS EC2 Instance 2: Staging Worker (Agent Node)                                                   |
| • Private IP: 172.31.30.114                                                                       |
| • Runtime Environment: Java 21 (Amazon Corretto), Apache Maven 3.x, Docker Engine                 |
| • Execution Workspace: /home/ec2-user/jenkins/workspace/My-First-Java-App                         |
+---------------------------------------------------------------------------------------------------+

        |                                                                           |
        | 1. Compile & Package                                                      | 2. Containerize & Deploy
        v                                                                           v
+------------------------------------+                             +--------------------------------+

|        Apache Maven Build          |                             |        Docker Casing           |
| • Command: mvn clean package       |                             | • Container: devops-staging    |
| • Artifact: devopproject.jar       |                             | • Port Binding: 8081:8081      |
+------------------------------------+                             +--------------------------------+
```

## 🛠️ Tech Stack & Infrastructure
*   **Orchestration:** Jenkins Automation Server (Distributed Master-Agent Architecture)
*   **Infrastructure:** Amazon Web Services (AWS) EC2 Linux Virtual Servers
*   **Source Control:** GitHub Core Repository with Webhook Integration
*   **Compilation Engine:** OpenJDK / Amazon Corretto Java 21 Development Environment
*   **Build Automation:** Apache Maven 3.x Lifecycle Management
*   **Container Runtime:** Docker Containerization Engine

## 💻 Core Configurations Used

### 1. Final Multi-Node Production `Jenkinsfile`
```groovy
pipeline {
    agent { label 'Staging-Agent' }
    environment {
        JAVA_HOME = '/usr/lib/jvm/java-21-amazon-corretto.x86_64'
        PATH = "\({env.JAVA_HOME}/bin:\){env.PATH}"
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
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
    post {
        always {
            echo "Pipeline complete. Processing status logs..."
        }
        success {
            echo "SUCCESS: Build #\${env.BUILD_NUMBER} has deployed cleanly to Workstation 2!"
        }
        failure {
            echo "FAILURE: Pipeline crashed at build stage level for Build #\${env.BUILD_NUMBER}."
        }
    }
}
```

### 2. Application Packaging Template (`Dockerfile`)
```dockerfile
FROM amazoncorretto:21-alpine
EXPOSE 8081
COPY devopproject/target/devopproject-1.0-SNAPSHOT.jar app.jar
ENTRYPOINT ["sh", "-c", "java -jar -Dserver.address=0.0.0.0 -Dserver.port=8081 /app.jar && tail -f /dev/null"]
```

## 🚀 Key Technical Milestones Met
1.  **Distributed Worker Clustering:** Configured a secure cryptographic SSH public/private key-pair connection between a master orchestration interface and an isolated environment node.
2.  **Resource Bottleneck Remediation:** Identified and mitigated kernel-level Linux process terminations (Exit Code 137 Out-Of-Memory limits) during Maven code compilations by offloading the build workloads from a 1GB RAM instance onto a dedicated target environment server.
3.  **Cross-Platform Automation:** Connected external GitHub code repositories to Jenkins infrastructure utilizing token payloads to instantly trigger build cycles upon code check-ins.
