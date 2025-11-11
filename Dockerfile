# Stage 1: Build the app using Maven (this creates the WAR file)
FROM maven:3.8.1-openjdk-17-slim AS builder

# Build arguments: allow overriding the final WAR name produced by Maven
ARG WAR_NAME=EmailListWebApp.war

# Set the working directory inside the container for the build
WORKDIR /app

# Copy project files (non-standard Maven structure)
COPY pom.xml ./
COPY src ./src
COPY web ./web

# Run Maven to clean and build the WAR file (skip tests to speed up)
RUN mvn -B clean package -DskipTests

# Stage 2: Runtime environment with Tomcat 9 (supports Java EE / javax.servlet)
FROM tomcat:9.0-jdk17

# Expose port 8080 (Tomcat's default port for HTTP)
EXPOSE 8080

# Remove default webapps to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from builder stage and deploy as ROOT application
ARG WAR_NAME=EmailListWebApp.war
COPY --from=builder /app/target/${WAR_NAME} /usr/local/tomcat/webapps/ROOT.war


# Healthcheck for container orchestration platforms
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]
