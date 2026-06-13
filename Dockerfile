FROM openjdk:21-jdk-slim
EXPOST 8081
COPY devopproject/target/devopproject-1.0-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "-Dserver.port=8081", "/app.jar"]
