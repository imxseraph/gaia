FROM node:alpine AS node

ENV LANG C.UTF-8

RUN apk update && apk add yarn
COPY . /gaia

# build muxin.io
WORKDIR /gaia/muxin.io
RUN npm install -g hexo && npm install && hexo g

# build chronos
WORKDIR /gaia/chronos
RUN yarn install && yarn build

# setup nginx
FROM nginx:latest AS nginx

ENV LANG C.UTF-8

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d /etc/nginx/conf.d

COPY --from=node /gaia/muxin.io/public/ /data/site/muxin.io/
COPY --from=node /gaia/chronos/build/ /data/site/tool.muxin.io/
COPY yating.love/ /data/site/yating.love/
