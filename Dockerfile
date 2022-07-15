#
# conductor-community:server - Netflix conductor community server
#

# ===========================================================================================================
# 0. Builder stage
# ===========================================================================================================
FROM openjdk:11-jdk AS builder

LABEL maintainer="Netflix OSS <conductor@netflix.com>"

# Copy the project directly onto the image
COPY . /conductor
WORKDIR /conductor

# Build the server on run
RUN ./gradlew build -x test --stacktrace

# ===========================================================================================================
# 1. Bin stage
# ===========================================================================================================
FROM openjdk:11-jre

LABEL maintainer="Netflix OSS <conductor@netflix.com>"

# Make app folders
RUN mkdir -p /app/config /app/logs /app/libs

# Copy the compiled output to new image
COPY --from=builder /conductor/docker/bin /app
COPY --from=builder /conductor/docker/config /app/config
COPY --from=builder /conductor/community-server/build/libs/conductor-community-server-*-boot.jar /app/libs

# Copy the files for the server into the app folders
RUN mv /app/startup-community.sh /app/startup.sh
RUN chmod +x /app/startup.sh

HEALTHCHECK --interval=60s --timeout=30s --retries=10 CMD curl -I -XGET http://localhost:8080/health || exit 1

CMD [ "/app/startup.sh" ]
ENTRYPOINT [ "/bin/sh"]
