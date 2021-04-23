FROM ubuntu:20.04

MAINTAINER ad1tya2

ARG GRAALVM_URL=https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.1.0/graalvm-ce-java16-linux-amd64-21.1.0.tar.gz
ENV DEBIAN_FRONTEND=noninteractive 
COPY slim-java* /usr/local/bin/

ENV JAVA_HOME /jdk
ENV PATH $JAVA_HOME/bin:$PATH

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends binutils curl ca-certificates openssl git tar sqlite fontconfig tzdata iproute2 \
  && useradd -d /home/container -m container \
  && mkdir /jdk && curl -L ${GRAALVM_URL} -o /tmp/graalvm.tar.gz && tar -xvf /tmp/graalvm.tar.gz --strip-components=1 --directory /jdk/ \
  && rm -rf /tmp/graalvm.tar.gz \
  && /usr/local/bin/slim-java.sh /jdk \
  &&  rm -rf /var/lib/apt/lists/* \
  && apt-get remove -y binutils git && apt autoremove -y && rm -r /jdk/languages /jdk/lib/visualvm /jdk/lib/installer

USER container
ENV  USER=container HOME=/home/container


WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]