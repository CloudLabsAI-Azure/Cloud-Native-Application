FROM node:16-alpine 
#FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app
EXPOSE 3000
EXPOSE 80
EXPOSE 443



COPY . .
RUN npm install --loglevel=error
#RUN npm ci 

RUN npm run build
#RUN npm run start

CMD [ "npx", "serve", "build" ]
