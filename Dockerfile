# -----------------------------
# Stage 1 - Build the JAR file
# -----------------------------
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml first (for dependency caching)
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests


# -----------------------------
# Stage 2 - Run the Application
# -----------------------------
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy JAR from Stage 1
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
