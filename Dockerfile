# Multi-stage Dockerfile for building and running the Spring Boot application
# Build stage: use Maven to compile and package the app (Java 26)
# NOTE: official maven images with OpenJDK 26 may not exist depending on registry; Docker will try to pull
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /workspace

# Copy only the files needed for dependency resolution first to leverage Docker cache
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Copy source and package (skip tests to speed up; remove -DskipTests to run tests)
COPY src ./src
# Ensure the Maven wrapper is executable and use it to build (avoids depending on the maven image tag)
RUN chmod +x mvnw && ./mvnw -B -DskipTests package

# Run stage: smaller runtime image with only the JRE (Java 26)
# If this tag doesn't exist in your registry, replace with an available JRE 26 image or build with Java 17 instead
# Run stage: smaller runtime image with only the JRE (Java 17)
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# JVM options can be supplied at runtime via the JAVA_OPTS env var
ENV JAVA_OPTS="-Xms256m -Xmx512m"

# Activate the 'docker' Spring profile which uses host.docker.internal for MySQL
# Override with -e SPRING_PROFILES_ACTIVE=container to use container profile instead
ENV SPRING_PROFILES_ACTIVE="docker"

# Copy the fat jar produced by the build stage (adjust name if your artifactId/version differs)
# Copy the built jar (use wildcard so the Dockerfile doesn't need to be updated for version changes)
COPY --from=build /workspace/target/*.jar ./app.jar

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]

# Tips:
# Build image: docker build -t sistema-financeiro:latest .
# Run container (WSL/docker for Windows): docker run --rm -p 8080:8080 sistema-financeiro:latest


