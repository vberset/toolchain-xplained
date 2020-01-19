FROM vberset/crosstool-ng:1.23 as build

WORKDIR /opt

COPY crosstool-ng.config .config

RUN mkdir xsources xtools

ADD https://fossies.org/linux/misc/old/libelf-0.8.13.tar.gz xsources/libelf-0.8.13.tgz

RUN ct-ng build && \
    ct-ng clean && \
    rm -rf xsources

FROM debian:stable-slim

COPY --from=build /opt/xtools /opt/xtools

RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get -y install --fix-missing make automake autoconf libtool gawk bc python && \
    rm -rf /var/lib/apt/lists/*

ENV CROSS_COMPILE arm-linux-
ENV PATH /opt/xtools/arm-cortexa5-linux-uclibcgnueabihf/bin:$PATH
VOLUME /src
WORKDIR /src
