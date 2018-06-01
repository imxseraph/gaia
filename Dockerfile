FROM node:latest AS node

COPY blog /blog
WORKDIR /blog
RUN npm install -g hexo && npm install && hexo g

FROM nginx:latest AS nginx

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d /etc/nginx/conf.d

COPY --from=node /blog/public/* /data/site/muxin.io/
COPY love/* /data/site/yating.love/
