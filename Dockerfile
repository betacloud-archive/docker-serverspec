FROM ubuntu:16.04
MAINTAINER Betacloud Solutions GmbH (https://www.betacloud-solutions.de)

ENV DEBIAN_FRONTEND noninteractive
ARG VERSION
ENV VERSION ${VERSION:-2.39.1}

COPY files/run.sh /run.sh

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        netcat-traditional \
        ruby \
    && gem install serverspec -v $VERSION \
    && groupadd kolla \
    && useradd -m -d /var/lib/serverspec serverspec \
    && usermod -a -G kolla serverspec \
    && mkdir /var/lib/serverspec/.ssh \
    && mkdir /tests \
    && chown serverspec: /var/lib/serverspec/.ssh /tests \
    && ln -s /config/config /var/lib/serverspec/.ssh/config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER serverspec
