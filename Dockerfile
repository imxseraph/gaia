FROM node:latest AS node

ENV LANG C.UTF-8

COPY muxin.io /muxin.io
WORKDIR /muxin.io
RUN npm install -g hexo && npm install && hexo g

FROM nginx:latest AS nginx

ENV LANG C.UTF-8

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d /etc/nginx/conf.d

COPY --from=node /muxin.io/public/ /data/site/muxin.io/
COPY yating.love/ /data/site/yating.love/
