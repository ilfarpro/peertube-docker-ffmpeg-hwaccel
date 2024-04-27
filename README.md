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

Optionally add fix for preview and thumbnail sizes in
`server/core/initializers/constants.ts`
```
// Videos thumbnail size
const THUMBNAILS_SIZE = {
  width: 560,
  height: 317,
  minWidth: 300
}
const PREVIEWS_SIZE = {
  width: 1280,
  height: 720,
  minWidth: 600
}
```

2. Clone custom repo with ffmpeg and build it
```
git clone https://github.com/ilfarpro/docker-ffmpeg-psy.git
cd docker-ffmpeg-psy
docker build \
  --no-cache \
  --pull \
  -t ilfarpro/ffmpeg-psy:latest .
``` 
3. Open PeerTube's repo folder and build from custom Dockerfile.linuxserver
```
cd PeerTube
docker build . -t ilfarpro/peertube:latest -f support/docker/production/Dockerfile.linuxserver
```

3. Follow official instructions to deploy https://docs.joinpeertube.org/install/docker
4. **Change** `image: chocobozzz/peertube:production-bookworm` **in docker-compose.yml to** `image: peertube:linuxserver`
