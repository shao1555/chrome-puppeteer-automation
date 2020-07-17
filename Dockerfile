FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
# Basic
RUN apt-get update \
    && apt-get install -y sudo curl wget zip unzip git nodejs npm fontconfig \
    && apt-get purge -y nodejs npm \
    && curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn

# Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
    && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable

# Remove cache & workfile
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Japanese font
RUN mkdir /noto
ADD https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip /noto
WORKDIR /noto
RUN unzip NotoSansCJKjp-hinted.zip && \
    mkdir -p /usr/share/fonts/noto && \
    cp *.otf /usr/share/fonts/noto && \
    chmod 644 -R /usr/share/fonts/noto/ && \
    /usr/bin/fc-cache -fv
WORKDIR /
RUN rm -rf /noto

# Work dir
RUN mkdir -p /app
WORKDIR /app
