FROM amazoncorretto:21-alpine
EXPOSE 8081
COPY devopproject/target/devopproject-1.0-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "-Dserver.address=0.0.0.0", "-Dserver.port=8081", "/app.jar"]
