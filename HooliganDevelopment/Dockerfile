FROM node:14

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies & setup docker image
ENV NODE_ENV=development
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 8080
CMD [ "npm", "run", "start" ]