# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Install PM2 globally
RUN npm install pm2@latest -g 
RUN npm install @pm2/pm2-version-check@latest 
RUN npm install openapi-types@latest

# Clean up some packages
RUN npm prune

# Set PM2 monitoring keys
ENV PM2_PUBLIC_KEY i97hkqy2usiu0we
ENV PM2_SECRET_KEY ikm6i6lo1ttn5hq

# Copy the rest of the application code
COPY . .

# Copy the .env file to the working directory
COPY .env .env

# Expose the port the app runs on
EXPOSE 3000

# Define the command to run the application using PM2
#CMD ["sh", "-c", "npm list && npm start"]
CMD ["pm2-runtime", "src/app.js"]
