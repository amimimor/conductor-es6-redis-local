#
# conductor:server - Netflix conductor server
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
COPY --from=builder /conductor/server/build/libs/conductor-server-*-boot.jar /app/libs
# We inject /app/startup.sh using docker mount or k8s configmap file so that it would create the proper /app/config on boot if need

HEALTHCHECK --interval=60s --timeout=30s --retries=10 CMD curl -I -XGET http://localhost:8080/health || exit 1

CMD [ "/app/startup.sh" ]
ENTRYPOINT [ "/bin/sh"]