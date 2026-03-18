# syntax=docker/dockerfile:1

FROM klakegg/hugo:0.125.7-ext-alpine AS builder
WORKDIR /src
COPY site/ /src/
RUN hugo --minify

FROM nginx:1.27-alpine
RUN rm -f /etc/nginx/conf.d/default.conf
COPY deploy/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /src/public /usr/share/nginx/html
EXPOSE 8080 8081
CMD ["nginx", "-g", "daemon off;"]
