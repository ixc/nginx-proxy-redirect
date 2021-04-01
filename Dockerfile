# syntax = docker/dockerfile:experimental

# Dockerize releases use a different label for arm64 than ${TARGETARCH}, so we need to
# explicitly set ${DOCKERIZE_ARCH} in a base image for each platform.

FROM alpine:3 as base-amd64
ENV DOCKERIZE_ARCH=amd64

FROM alpine:3 as base-arm64
ENV DOCKERIZE_ARCH=armhf

FROM base-${TARGETARCH}
ARG TARGETARCH

RUN apk update \
    && apk upgrade \
    && apk add \
        bash \
        jq \
        nginx \
        py3-pip \
        tini \
    && rm -rf /var/cache/apk/*

# Do NOT use dockerize 0.6.1 due to https://github.com/jwilder/dockerize/issues/125
ENV DOCKERIZE_VERSION=0.6.0
RUN wget -nv -O - "https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-${DOCKERIZE_ARCH}-v${DOCKERIZE_VERSION}.tar.gz" | tar -xz -C /usr/local/bin/ -f -

RUN --mount=type=cache,id=nginx-proxy-redirect,target=/root/.cache/pip pip install --no-cache-dir yq

ENV PATH="/opt/nginx-proxy-redirect/bin:$PATH"

EXPOSE 80

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["nginx.sh"]

WORKDIR /opt/nginx-proxy-redirect/
COPY . .
