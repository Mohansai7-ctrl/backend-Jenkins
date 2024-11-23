FROM node:20 AS build
WORKDIR /opt/server
COPY *.js .
COPY package.json .
RUN npm install


FROM node:20.18.0-alpine3.20
EXPOSE 8080
ENV DB_HOST="mysql"
RUN addgroup -S expense && adduser -S expense -G expense && \
    mkdir /opt/server && \
    chown -R expense:expense /opt/server
WORKDIR /opt/server
COPY --from=build /opt/server /opt/server
USER expense
CMD ["node", "index.js"] 
# Above will start the index.js application with node build tool