# # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Content: Dockerfile for Sandstorm app porting
# Author: Jan Jambor, XWare GmbH
# Author URI: https://xwr.ch
# Project URI: https://github.com/JamborJan/Sandstorm-Docker-Base-Image
# Date: 10.12.2018
#
# # # # # # # # # # # # # # # # # # # # # # # # # # #

# This Dockerfile generates an image that is just the base alpine image plus
# sandstorm-http-bridge. It is not runnable as an app itself, but is probably
# a good base to build other stock images from.

FROM debian:testing-slim as builder
ENV DEBIAN_FRONTEND noninteractive

# For strip:
RUN apt-get update && apt-get install -y \
    wget \
    xz-utils \
    binutils

# to get latest version number: curl --silent --show-error -f "https://install.sandstorm.io/dev?from=0&type=install"
ENV SANDSTORM_VERSION=241

# Download the sandstorm distribution, and extract sandstorm-http-bridge from it:
RUN wget https://dl.sandstorm.io/sandstorm-${SANDSTORM_VERSION}.tar.xz
RUN tar -x sandstorm-${SANDSTORM_VERSION}/bin/sandstorm-http-bridge -f sandstorm-*.tar.xz
RUN cp sandstorm-*/bin/sandstorm-http-bridge ./
# Stripping the binary reduces its size by about 10x:
RUN strip sandstorm-http-bridge

FROM debian:testing-slim
COPY --from=builder sandstorm-http-bridge /
