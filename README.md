# Peertube Docker Image with latest FFMPEG and Hardware Acceleration support.

By default Peertube's docker image based on Debian with outdated ffmpeg version and lacks hardware acccleration support.
This custom docker image based on [linuxserver/docker-ffmpeg](https://github.com/linuxserver/docker-ffmpeg) and aims to fix addressed issues.

## Build

1. Clone Peertube and custom Dockerfile
```
git clone https://github.com/Chocobozzz/PeerTube.git \
&& cd PeerTube/support/docker/production \
&& wget https://raw.githubusercontent.com/ilfarpro/peertube-docker-ffmpeg-hwaccel/main/Dockerfile.linuxserver
```
2. Open PeerTube's repo folder and build from custom Dockerfile.linuxserver
```
cd PeerTube
docker build . -t peertube:linuxserver -f support/docker/production/Dockerfile.linuxserver
```

3. Follow official instructions to deploy https://docs.joinpeertube.org/install/docker
4. **Make sure to change** `image: chocobozzz/peertube:production-bookworm` **in docker-compose.yml to** `image: peertube:linuxserver`
