FROM alpine:latest AS alpine
ENV LANG C.UTF-8

COPY . /gaia

RUN apk update && apk add hugo \
  && cd /gaia/index && hugo

FROM nginx:alpine AS nginx
ENV LANG C.UTF-8

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d /etc/nginx/conf.d

COPY --from=alpine /gaia/index/public/ /data/site/muxin.io/
