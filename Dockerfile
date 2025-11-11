# Stage 1: Build the app using Maven (this creates the WAR file)
FROM maven:3.8.1-openjdk-17-slim AS builder

# Build arguments: allow overriding the final WAR name produced by Maven
ARG WAR_NAME=EmailListWebApp.war

# Set the working directory inside the container for the build
WORKDIR /app

# Copy only necessary files first (speeds up rebuilds)
COPY pom.xml ./
COPY src ./src

# Run Maven to clean and build the WAR file (skip tests to speed up)
RUN mvn -B clean package -DskipTests

# Stage 2: Runtime environment with Tomcat (smaller image, no build tools)
FROM tomcat:9.0-jdk17-corretto

# Expose port 8080 (Tomcat's default port for HTTP)
EXPOSE 8080

# Remove default webapps to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# Allow overriding the WAR filename at build time and copy the WAR from builder
ARG WAR_NAME=EmailListWebApp.war
COPY --from=builder /app/target/${WAR_NAME} /usr/local/tomcat/webapps/ROOT.war

# Create a non-root user for slightly improved security (Tomcat image runs as root by default)
RUN groupadd -r app && useradd -r -g app app \
		&& chown -R app:app /usr/local/tomcat
USER app

# Healthcheck for hosting platforms that support Docker HEALTHCHECK
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
	CMD curl -f http://localhost:8080/ || exit 1

# Use the default Tomcat start command
CMD ["catalina.sh", "run"]
COPY target/EmailListWebApp.war /usr/local/tomcat/webapps/