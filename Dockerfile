# generate static file
FROM node:14-alpine as builder
WORKDIR /nuxt
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
RUN npm run generate


FROM nginx:1.23-alpine as production-build
COPY ./nginx/default.conf /etc/nginx/conf.d

## remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# copy from the builder
COPY --from=builder /nuxt/dist /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]