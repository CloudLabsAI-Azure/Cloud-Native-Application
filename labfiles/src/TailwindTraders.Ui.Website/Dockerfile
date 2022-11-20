FROM node:16-alpine 
WORKDIR /app
EXPOSE 3000
EXPOSE 443

COPY . .
RUN npm install
#RUN npm ci 

RUN npm run build

CMD [ "npx", "serve", "build" ]
