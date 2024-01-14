FROM linuxserver/ffmpeg:latest

# Install dependencies
RUN apt update && apt upgrade -y \
 && apt install -y --no-install-recommends openssl python3 ca-certificates gnupg gosu build-essential curl git \
 && gosu nobody true \
 && rm /var/lib/apt/lists/* -fR

# Add peertube user
RUN groupadd -r peertube \
    && useradd -r -g peertube -m peertube

# Install PeerTube
COPY --chown=peertube:peertube . /app
WORKDIR /app

# Install Node.js, npm, yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
sudo apt install -y nodejs

USER peertube

ENV NODE_MAJOR=18

# Install manually client dependencies to apply our network timeout option
RUN cd client && yarn install --pure-lockfile --network-timeout 1200000 && cd ../ \
    && yarn install --pure-lockfile --network-timeout 1200000 \
    && npm run build \
    && rm -r ./node_modules ./client/node_modules ./client/.angular \
    && yarn install --pure-lockfile --production --network-timeout 1200000 --network-concurrency 20 \
    && yarn cache clean

USER root

RUN mkdir /data /config
RUN chown -R peertube:peertube /data /config

ENV NODE_ENV production
ENV NODE_CONFIG_DIR /app/config:/app/support/docker/production/config:/config
ENV PEERTUBE_LOCAL_CONFIG /config

VOLUME /data
VOLUME /config

COPY ./support/docker/production/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

# Expose API and RTMP
EXPOSE 9000 1935

# Run the application
CMD [ "node", "dist/server" ]
