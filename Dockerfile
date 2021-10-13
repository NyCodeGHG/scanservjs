# Builder image.
FROM node:14-alpine AS builder
ENV APP_DIR=/app
WORKDIR "$APP_DIR"

COPY package*.json "$APP_DIR/"
COPY packages/server/package*.json "$APP_DIR/packages/server/"
COPY packages/client/package*.json "$APP_DIR/packages/client/"

RUN npm run install

COPY packages/client/ "$APP_DIR/packages/client/"
COPY packages/server/ "$APP_DIR/packages/server/"

RUN npm run build

# production image
FROM node:14-buster-slim

ENV APP_DIR=/app
WORKDIR "$APP_DIR"
RUN apt-get update \
  && apt-get install -yq curl gpg \
  && echo 'deb http://download.opensuse.org/repositories/home:/pzz/Debian_10/ /' \
    | tee /etc/apt/sources.list.d/home:pzz.list \
  && curl -fsSL https://download.opensuse.org/repositories/home:pzz/Debian_10/Release.key \
    | gpg --dearmor \
    | tee /etc/apt/trusted.gpg.d/home:pzz.gpg \
    > /dev/null \
  && apt-get update \
  && apt-get install -yq \
    imagemagick \
    sane \
    sane-utils \
    sane-airscan \
    tesseract-ocr \
    libsane-hpaio \
  && sed -i \
    's/policy domain="coder" rights="none" pattern="PDF"/policy domain="coder" rights="read | write" pattern="PDF"'/ \
    /etc/ImageMagick-6/policy.xml \
  && sed -i \
    's/policy domain="resource" name="disk" value="1GiB"/policy domain="resource" name="disk" value="8GiB"'/ \
    /etc/ImageMagick-6/policy.xml \
  && npm install -g npm@7.11.2

ENV \
  # This goes into /etc/sane.d/net.conf
  SANED_NET_HOSTS="" \
  # This gets added to /etc/sane.d/airscan.conf
  AIRSCAN_DEVICES="" \
  # This directs scanserv not to bother querying `scanimage -L`
  SCANIMAGE_LIST_IGNORE="" \
  # This gets added to scanservjs/server/config.js:devices
  DEVICES="" \
  # Override OCR language
  OCR_LANG=""

# Copy entry point
COPY run.sh /run.sh
RUN ["chmod", "+x", "/run.sh"]
ENTRYPOINT [ "/run.sh" ]

# Copy the code and install
COPY --from=builder "$APP_DIR/dist" "$APP_DIR/"
RUN npm install --production

EXPOSE 8080
