FROM alpine:latest AS alpine
ENV LANG C.UTF-8

COPY . /gaia

RUN apk update && apk add yarn && yarn global add hexo-cli \
  && cd /gaia/muxin.io && yarn && hexo g \
  && cd /gaia/muxin.io-en && yarn && hexo g \
  && cd /gaia/chronos && yarn && yarn build

FROM nginx:alpine AS nginx
ENV LANG C.UTF-8

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d /etc/nginx/conf.d

COPY --from=alpine /gaia/muxin.io/public/ /data/site/muxin.io/
COPY --from=alpine /gaia/muxin.io-en/public/ /data/site/muxin.io/en/
COPY --from=alpine /gaia/chronos/build/ /data/site/treehole.muxin.io/
