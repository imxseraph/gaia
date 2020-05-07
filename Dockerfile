FROM alpine:latest AS alpine
ENV LANG C.UTF-8

COPY . /gaia

RUN apk update && apk add yarn \
  && cd /gaia/muxin.io && yarn global add hexo-cli && yarn && hexo g \
  && cd /gaia/chronos && yarn && yarn build

FROM nginx:alpine AS nginx
ENV LANG C.UTF-8

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d /etc/nginx/conf.d

COPY nothing /data/site/nothing

COPY --from=alpine /gaia/muxin.io/public/ /data/site/muxin.io/
COPY --from=alpine /gaia/chronos/build/ /data/site/tools.muxin.io/
