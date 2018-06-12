FROM alpine:latest AS alpine
ENV LANG C.UTF-8

COPY . /gaia
# install yarn
RUN apk update && apk add yarn \
  # build muxin.io
  && yarn global add hexo-cli && yarn --cwd /gaia/muxin.io && hexo g --cwd /gaia/muxin.io \
  # build chronos
  && yarn --cwd /gaia/chronos && yarn build --cwd /gaia/chronos

# setup nginx
FROM nginx:alpine AS nginx
ENV LANG C.UTF-8

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d /etc/nginx/conf.d

COPY --from=alpine /gaia/muxin.io/public/ /data/site/muxin.io/
COPY --from=alpine /gaia/chronos/build/ /data/site/tool.muxin.io/
COPY yating.love/ /data/site/yating.love/
