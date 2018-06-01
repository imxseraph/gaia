FROM node:latest AS node

WORKDIR ../blog
RUN npm install -g hexo && npm install && hexo g

FROM nginx:latest AS nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/conf.d /etc/nginx/conf.d
COPY site /data/site

COPY --from=node ../blog/public/* /data/site/muxin.io/
