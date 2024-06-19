# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

ARG NODE_VERSION=20.12.2

FROM node:${NODE_VERSION}-alpine

# Use production node environment by default.
ENV NODE_ENV production
ENV DB_HOST 157.245.73.11
ENV DB_PORT 3307
ENV DB_USER Member
ENV DB_PASSWORD "a4fiadsfj(ower!oadv30"
ENV DB_DATABASE NearMintGamingDB


WORKDIR /usr/src/app

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.npm to speed up subsequent builds.
# Leverage a bind mounts to package.json and package-lock.json to avoid having to copy them into
# into this layer.
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev
RUN npm install pm2-runtime
# Run the application as a non-root user.

# Copy the rest of the source files into the image.
COPY . .

# Expose the port that the application listens on.
EXPOSE 3000

# Run the application.
CMD ["pm2-runtime", "src/app.js"]