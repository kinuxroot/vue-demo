# prebuild stage
FROM node:lts-alpine as builder
WORKDIR /app
COPY package*.json ./
# RUN npm install --registry=https://registry.npm.taobao.org
RUN npm ci

# build stage
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY --from=builder /app /app
COPY . .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
