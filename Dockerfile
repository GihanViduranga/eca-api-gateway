FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN apk add --no-cache maven && mvn clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

ENV PORT=9000
EXPOSE 9000

ENTRYPOINT ["java", \
  "-Dserver.port=${PORT}", \
  "-Dspring.cloud.config.fail-fast=false", \
  "-Dspring.cloud.config.enabled=false", \
  "-Dspring.config.import=", \
  "-Deureka.client.service-url.defaultZone=${EUREKA_CLIENT_SERVICEURL_DEFAULTZONE}", \
  "-Deureka.instance.prefer-ip-address=true", \
  "-jar", "app.jar"]
