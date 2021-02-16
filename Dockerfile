ARG TAG=current-alpine
FROM node:${TAG} as build

ARG tag=${TAG}

# ASH contains: https://stackoverflow.com/questions/39162967/compare-substrings-in-busybox-ash
# [ -z $(echo "$I"|sed "/$N$A/d") ] # Contains

RUN if [ -z $(echo "$tag"|sed "/alpine/d") ] ; then apk update \
    && apk add git gnupg python build-base; else \
    apt update && apt install git gnupg python build-base; fi

RUN set -ex \
    && for key in \
    5B7DC58D90FEC1E990A310BAF24F232D108B3AD4 \
    ; do \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" || echo "Key not found"; \
    # gpg --batch --keyserver pgp.mit.edu --recv-keys "$key" || echo "Key not found"; \
    # gpg --batch --keyserver keyserver.pgp.com --recv-keys "$key" || echo "Key not found"; \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || echo "Key not found"; \
    gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || echo "Key not found"; \
    done

RUN git clone --depth 1 https://github.com/braydonf/gpk \
    && echo cloned... \
    && cd gpk \
    && git verify-commit HEAD \
    && node ./bin/gpk install --global \
    && gpk test

RUN git clone --depth 1 git://github.com/bcoin-org/bcoin.git \
    && cd bcoin \
    && git verify-commit HEAD \
    && gpk rebuild \
    && gpk test \
    && gpk install

FROM node:${TAG}
LABEL maintainer="Michael Henke (@michaelhenke)" 

RUN if [ -z $(echo "$tag"|sed "/alpine/d") ] ; then apk update \
    && apk add bash; \
    else apt update && apt install bash; fi

RUN adduser --disabled-password --home /home/bcoin bcoin

COPY --from=build /bcoin /bcoin

EXPOSE 8333

VOLUME [ "/home/bcoin" ]

HEALTHCHECK CMD curl --fail localhost:8333 || exit 1

ENTRYPOINT [ "/bcoin/bin/bcoin" ]
