# Start by building the application.
FROM node:lts-alpine as build

WORKDIR /app

COPY . .

RUN npm ci
RUN npm run build

FROM ubuntu as ssl
WORKDIR /app

RUN openssl req -subj '/CN=localhost' -x509 -sha256 -newkey rsa:4096 -nodes -keyout server.key -out server.crt -days 30

FROM nginx:1.22-alpine as final
WORKDIR /usr/share/nginx/html
COPY --chown=nginx:nginx --from=build /app/build /usr/share/nginx/html
COPY --chown=nginx:nginx --from=ssl /app /etc/nginx/keys
COPY conf/nginx.conf.template /etc/nginx/templates/default.conf.template

EXPOSE 8080
EXPOSE 8443

CMD ["nginx", "-g", "daemon off;"]