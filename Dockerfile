ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.17

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG MA1SD_VERSION

ENV MA1SD_VERSION=${MA1SD_VERSION:-"2.5.0"} \
    MA1SD_REPO_URL=https://github.com/ma1uta/ma1sd \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED=ma1sd \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    IMAGE_NAME="tiredofit/ma1sd" \
    IMAGE_REPO_URL="https://github.com/tiredofit/ma1sd/"

RUN source assets/functions/00-container && \
    set -x && \
    addgroup -S -g 8090 ma1sd && \
    adduser -D -S -s /sbin/nologin \
            -h /dev/null \
            -G ma1sd \
            -g "ma1sd" \
            -u 8090 ma1sd \
            && \
    \
    package update && \
    package upgrade && \
    package install .ma1sd-build-deps \
                git \
                openjdk13-jdk \
                && \
    \
    package install .ma1sd-run-deps \
                openjdk13-jre \
                postgresql15-client \
                sqlite \
                yq \
                && \
    \
    clone_git_repo "${MA1SD_REPO_URL}" "${MA1SD_VERSION}" && \
    ./gradlew shadowJar && \
    mkdir -p /app && \
    cp -R build/libs/ma1sd.jar /app/ma1sd.jar && \
    mkdir -p /assets/ma1sd && \
    cp ma1sd.example.yaml /assets/ma1sd/example.yaml && \
    package remove .ma1sd-build-deps \
                   && \
    package cleanup && \
    \
    rm -rf /root/.gradle \
           /usr/src/*

EXPOSE 8090

COPY install /

