ARG PYTHON_VERSION=latest

FROM <registry>/<org>/tooling-python:${PYTHON_VERSION} as build

# hadolint doesnt know how to differentiate build images vs release images in multistage
# https://github.com/hadolint/hadolint/issues/405
# hadolint ignore=DL3002
USER root

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && \
    curl -sLo /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod 755 /usr/bin/jq

RUN mkdir -p /src/dist

WORKDIR /src

COPY . /src

RUN python setup.py install --user

FROM <registry>/<org>/tooling-python:${PYTHON_VERSION}

ARG BUILD_VERSION

ARG OCI_AUTHORS
ARG OCI_CREATED
ARG OCI_DESCRIPTION
ARG OCI_SOURCE
ARG OCI_TITLE
ARG OCI_URL
ARG OCI_VCS_REF

COPY --from=build /usr/bin/jq /usr/bin/jq
COPY --from=build /usr/src/app /usr/src/app

LABEL org.opencontainers.image.title="${OCI_TITLE}"
LABEL org.opencontainers.image.description="${OCI_DESCRIPTION}"
LABEL org.opencontainers.image.url="${OCI_URL}"
LABEL org.opencontainers.image.source="${OCI_SOURCE}"
LABEL org.opencontainers.image.authors="${OCI_AUTHORS}"
LABEL org.opencontainers.image.vendor="Mezmo, Inc."
LABEL org.opencontainers.image.created="${OCI_CREATED}"
LABEL org.opencontainers.image.version="${BUILD_VERSION}"
LABEL org.opencontainers.image.revision="${OCI_VCS_REF}"

USER 1000

CMD ["filesync"]
