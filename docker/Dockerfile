FROM alpine:3

# Labels.
LABEL maintainer="serge.eximius@gmail.com" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.name="ssedov/pgdump-s3cmd" \
    org.label-schema.description="Dockerized mysql-dump with copy to s3 storage." \
    org.label-schema.url="https://github.com/sergeeximius/docker-pgdump-s3cmd" \
    org.label-schema.vcs-url="https://github.com/sergeeximius/docker-pgdump-s3cmd" \
    org.label-schema.vendor="Sergey Sedov" \
    org.label-schema.docker.cmd="docker run -it ssedov/pgdump-s3cmd:latest"

RUN apk add --update postgresql-client bash s3cmd && rm -rf /var/cache/apk/*

COPY --chmod=755 entrypoint.sh /entrypoint.sh
COPY --chmod=600 .s3cfg_yandex /root/.s3cfg_yandex
COPY --chmod=600 .s3cfg_selectel /root/.s3cfg_selectel

ENTRYPOINT ["/entrypoint.sh"]