FROM alpine:3.9

RUN apk update \
    && apk upgrade \
    && apk add \
        bash \
        jq \
        nginx \
        py2-pip \
        tini \
    && rm -rf /var/cache/apk/*

ENV DOCKERIZE_VERSION=0.6.1
RUN wget -nv -O - "https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz" | tar -xz -C /usr/local/bin/ -f -

RUN pip install --no-cache-dir yq

ENV PATH="/opt/nginx-proxy-redirect/bin:$PATH"

EXPOSE 80

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["nginx.sh"]

WORKDIR /opt/nginx-proxy-redirect/
COPY . /opt/nginx-proxy-redirect/
