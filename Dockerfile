# Start by building the application.
FROM node:lts-alpine as build

WORKDIR /app

COPY . .

RUN npm ci
RUN npm run build

FROM nginx:1.22.1
WORKDIR /usr/share/nginx/html
COPY --chown=nginx:nginx --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]