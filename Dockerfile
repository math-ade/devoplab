FROM amazoncorretto:21-alpine
EXPOSE 8081
COPY devopproject/target/devopproject-1.0-SNAPSHOT.jar app.jar
# This prints your success message AND keeps the container alive forever
ENTRYPOINT ["sh", "-c", "java -jar -Dserver.address=0.0.0.0 -Dserver.port=8081 /app.jar && tail -f /dev/null"]
