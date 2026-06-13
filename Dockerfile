FROM openjdk:21-jdk-slim
EXPOSE 8081
COPY devopproject/target/devopproject-1.0-SNAPSHOT.jar app.jar
# This keeps the container engine running and prints your logs
ENTRYPOINT ["java", "-jar", "-Dserver.address=0.0.0.0", "-Dserver.port=8081", "/app.jar"]
