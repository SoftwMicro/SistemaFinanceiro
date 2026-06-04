# Multi-stage Dockerfile for building and running the Spring Boot application
# Build stage: use Maven to compile and package the app (Java 26)
# NOTE: official maven images with OpenJDK 26 may not exist depending on registry; Docker will try to pull
FROM maven:3.9.4-openjdk-26 AS build
WORKDIR /workspace

# Copy only the files needed for dependency resolution first to leverage Docker cache
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Copy source and package (skip tests to speed up; remove -DskipTests to run tests)
COPY src ./src
RUN mvn -B -DskipTests package

# Run stage: smaller runtime image with only the JRE (Java 26)
# If this tag doesn't exist in your registry, replace with an available JRE 26 image or build with Java 17 instead
FROM eclipse-temurin:26-jre-jammy
WORKDIR /app

# JVM options can be supplied at runtime via the JAVA_OPTS env var
ENV JAVA_OPTS="-Xms256m -Xmx512m"

# Copy the fat jar produced by the build stage (adjust name if your artifactId/version differs)
# Copy the built jar (use wildcard so the Dockerfile doesn't need to be updated for version changes)
COPY --from=build /workspace/target/*.jar ./app.jar

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]

# Tips:
# Build image: docker build -t sistema-financeiro:latest .
# Run container (WSL/docker for Windows): docker run --rm -p 8080:8080 sistema-financeiro:latest


