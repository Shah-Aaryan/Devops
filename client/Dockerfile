# Stage 1: Build the client application
FROM node:20-slim AS client-builder
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./
RUN npm ci

# Copy the rest of the application code
COPY . .
RUN npm run build

# Stage 2: Production image (Nginx)
FROM nginx:1.27-alpine
ENV API_UPSTREAM=http://backend:8000

# Serve static assets and proxy API requests
COPY --from=client-builder /app/dist /usr/share/nginx/html
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

EXPOSE 80
