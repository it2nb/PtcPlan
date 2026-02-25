# --- OLD VERSION (Kept for reference) ---
# # Dockerfile
# FROM node:16.16.0-alpine
# 
# # create destination directory
# RUN mkdir -p /usr/src/ptcplan
# WORKDIR /usr/src/ptcplan
# 
# # update and install dependency
# RUN apk update && apk upgrade
# RUN apk add git
# 
# # copy the app, note .dockerignore
# COPY . /usr/src/ptcplan/
# RUN npm install
# RUN npm run build
# 
# EXPOSE 3000
# 
# ENV NUXT_HOST=0.0.0.0
# ENV NUXT_PORT=3000
# 
# CMD [ "npm", "start" ]
# ----------------------------------------

# Stage 1: Build
FROM node:16.16.0-alpine AS builder

WORKDIR /usr/src/ptcplan

# Install git if needed by any npm packages (using --no-cache to keep the builder image smaller)
RUN apk add --no-cache git

# Copy only package files first to cache the npm install step
COPY package*.json ./
RUN npm install

# Copy the remaining project files
COPY . .

# Build the nuxt project
RUN npm run build

# Remove development dependencies to reduce node_modules size
RUN npm prune --production

# Stage 2: Production
FROM node:16.16.0-alpine

WORKDIR /usr/src/ptcplan

# Copy necessary files from the builder stage
COPY --from=builder /usr/src/ptcplan/package.json ./
COPY --from=builder /usr/src/ptcplan/nuxt.config.js ./
COPY --from=builder /usr/src/ptcplan/static ./static
COPY --from=builder /usr/src/ptcplan/.nuxt ./.nuxt
COPY --from=builder /usr/src/ptcplan/node_modules ./node_modules
COPY --from=builder /usr/src/ptcplan/.env ./

# Set strictly necessary environment variables
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000
ENV NODE_ENV=production

EXPOSE 3000

CMD [ "npm", "start" ]
